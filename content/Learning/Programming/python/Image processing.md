2025-04-22 20:14

Status:

Tags:

# Image processing
* 介紹簡易的影像處理流程，這裡以簡易的影像處理用於車道檢測作為例子。
## 預處理(Processing)
目的：為了簡化影像，突出車道特徵同時移出噪聲和不必要的細節
* Step 1.轉為灰度圖
	* 原理：將影像色彩轉化為灰度，減少所需處理的通道(3變1)，加快處理速度並簡化後續分析，因為色彩資訊在偵測通道中不如亮度資訊重要
	* frame, COLOR_BRG2GRAY
	* Syntax:
	```python
	gray = cv2.cvtcolor(frame, cv2.COLOR_BRG2GRAY)
	```
* Step 2.高斯模糊降噪
	* 原理：透過將每個像素與周圍取加權平均值，從而來模糊圖片，加權值則是由高斯分佈來決定，離越近越大
	* (5,5)是指高斯核大小，而0是指標準差
	* Syntax:
	```python
	blur = cv2.GaussianBlur(gray, (5,5),0)
	```
* Step 3.邊緣檢測(如Canny 邊緣檢測)
	* Canny 原理:
		* 1. 利用sobel濾波器來濾出邊緣的大小與方向
		* 2.尋找最大梯度方向:
			* 簡化計算，將梯度方向分成0, 45, 90, 135，尋找各個方向變化最大的點，以45度為例，變化最多為0.3->1，因此除了1以外的值歸0
		 ![](Canny1.jpg)
		 ![](Canny4.jpg) 
		 ![](Canny2.jpg)
		* 3.Connect Weak edge:
			* 透connect weak edge 把線連起來，設定高界線與低界線，依循以下機制找到邊緣
				* a. 高於高界線：一定是邊緣
				* b.低於低界線：一定不是邊緣
				* c.兩線之間：若附近有兩個高於高界線的點，也可視為邊緣
			* Syntax:	
			 50是低界線，150是高界線
		```python
		edges = cv2.Canny(blur, 50, 150)			
		```
			
## 感興趣(ROI)區域提取
### 後來發現先做ROI再做canny可以讓他集中在重要地區的邊緣處理，效果比較好 
* 原理：縮小處理範圍，僅關注包含車道線的區域，提高效率並減少誤檢
* 定義ROI多邊形：定義一個梯形區域，用來覆蓋影像的下半部份(從視角來看是道路區域)，透過以下參數來創建一個上窄下寬的梯形
```python
height, width = edges.shape# image.shape()可以得到圖片的長寬
roi_vertics = np.array(
		[[(0,height), (width/2-50, height/2+50), (width/2+50, height/2+50)
		,(width, height)]], dtype=np.int32)
```
* 創建遮罩與應用：創建一個全黑(都是0)遮罩(與原映像同尺寸)，用白色填充ROI區域，最後用AND操作合併遮罩與邊緣映像，僅保留ROI內邊緣
* edges 包含圖像中各個邊緣的強度與方向數值，與mask做and，則當兩張圖都是白色(255)的地方，則結果才會是白色，否則都是黑色，結果僅保留邊緣區域。
```python
mask = np.zeros_like(edges) #創建一個與edges大小相同但數值皆為0的矩陣
cv2.fillpoly(roi_vertics, mask, 255)# fillpoly 可以一次填多個圖形，255是指白色
masked_edge = cv2.bitwise_and(edges, mask)

```
## 特徵提取
* 對於直線，提取的最好方法便是用**霍夫找線** 
* 原理簡介：將在笛卡爾座標系的線中提出斜率與截距，作為霍夫空間中的x,y座標，在霍夫空間的點代表笛卡爾座標的一條線，反過來說，在霍夫座標中的兩個點所連成的線只要不是垂直線，代表在笛卡爾座標系交於一點
![](Hoff_change1.jpg)

* 其實(3,2),(4,1)也可以組成直線，但A,B的交點都是由三條線所交會而成，這也是霍夫變換的後處理基本方式：選擇由盡可能多的直線交會的點(得票數最多)
* Syntax:
```python
lines = cv2.HoughLinesP(
	masked_edges,
	rho=1,# 距離精度(1 pixel)
	theta=np.pi/180,# 角度精度(1度)
	threshold=20,# 檢測一條線至少需要的投票數
	minLineLength,# 最小線長度
	maxLineGap=300# 同意條線上兩點的最大允許間距
	
)
```
## 特徵分類
* 將車道分為左右車道，基於他們的位置和方向特徵
* 原理：
	* 1. 計算每條線的斜率
	* 2. 應用於以下分類規則：
		* 左車道線：負斜率，在畫面左半部
		* 右車道線：正斜率，在畫面右半部
	* 3.使用斜率域值(±0.3)，排除接近水平的線段(小於±0.3)，這些線通常不是車道
	* 4.忽略高度差小於10像素的線段(近似水平線)
* 實做：
```python
def classify_lane_lines(self, lines, image_shape):
	height,weight,_ = image_shape
	center_x = weight//2

	left_lines, right_lines = [], []
	if lines is None: # Exception for error input
		return None, None
	for line in lines:
		x1, y1, x2, y2 = line[0]

		if abs(y2-y1)<10:# 忽略水平線
			continue
		# Calculate slope
		slope = (y2-y1)/(x2-x1) if x2!=x1 # To avoid x2-x1=0

		if slope < -0.3 and center_x > x1, center_x > x2:
			left_lines.append(line)
		elif slope > 0.3 and center_x < x1, center_x < x2:
			right_lines.append(line) 
	return left_lines, right_lines
		
```
## 後處理
* 整合和平滑車道線資訊，提高穩定性和準確性
* 車道線擬合：
	* 對於當前這幀由霍夫變換所檢測道的線段分為左右測
	* 使用多項式擬合(np.polyfit)求解最佳的斜率與截距
	* 使用擬合所得到的參數來重出一個平滑且連續的線段
	* 將線段延伸到影像底部與預設高度
```python
def average_lane_line(self, lines, image_shape):
	if not lines:
		return None, None

	x_coords, y_coords = [], []
	for line in lines:
		x1,y1,x2,y2 = line[0]
		x_coords.extend([x1, x2])
		y_coords.extend([y1, y2])

	if not x_coords or not y_coords:
		return None, None
	try:
		solpe, intercept = np.polyfit(x_coords, y_coords)

		y1 = height
		y2 = 0.6*height
		x1 = (slope*x1)+intrercept
		x2 = (slope*x2)+intercept

		return np.array([[x1,y1,x2,y2]]),(slope, intercept)
	except:
		return None, None
```
 * 時間序列平滑化(對影片處理)：
	 * 維護一個固定長度的隊列(deque)，保存最近幾幀的車道線參數，當element超過預設長度時，會先從最前面開始pop出來
	 * 對這些參數取平均值，實現跨幀平滑
	 * 這種方法減少了車道線檢測抖動，提高了影片中視覺穩定性
```python
def update_line_fits(self, left_fit, right_fit):
	if left_fit is not None:
		self.left_fits.append(left_fit)
	if right_fit is not None:
		self.right_fits.append(right_fit)
def get_smooth_fits(self):
	left_fit, right = None, None
	if self.left_fits:
		left_fit = np.mean(self.left_fits, axis=0)
	elif self.right_fits:
		right_fit = np.mean(self.right_fits)
	return left_fit, right_fit
	
```
## 計算和視覺化
* 基於檢測結果計算關鍵指標(例如偏移量)，並以視覺化來呈現結果
* 車道中心計算：
	* 1.雙車線道：取兩條線底部x座標的平均值
	* 2.單車線道：假設標準車道寬度，推算車道中心
	* 3.無車道線：使用畫面中心為預設值
```python
def calculate_lane_center(self, left_line, right_line, image_shape):
	height, weight, _ = image_shape
	# If only one line
	if left_line is None and right_line is not None:# Only right line
		x1,y1,x2,y2 = right_line[0]
		lane_weight = 0.4*weight
		lane_center = (x1+x2)/2-lane_weight/2
	elif left_line is not None and right_line is None:
		x1,y1,x2,y2 = left_line[0]
		lane_weight = 0.4*weight
		lane_center = (x1+x2) + lane_weight/2
	elif left_line is not None and right_line is not None:
		left_x1, left_y1, left_x2, left_y2 = left_line[0]
		right_x1, right_y1, right_x2, right_y2 = right_line[0]
		left_x_bottom, right_x_bottom = left_x1, right_x1
		lane_center = (left_x_bottom+right_x_bottom)/2
	else:
		lane_center = width/2
	return lane_center
```
* 結果視覺化：
* 使用不同顏色繪製車道線標誌：
	* 紅色：左車道線
	* 綠色：右車道線
	* 藍色：車道中心線
	* 黃色：影像中心線
```python
# 畫線函數
cv2.line(image, (x_start, y_start),(x_end, y_end), (color), line_width)

cv2.putText(image, text, left_down_coords, fonttype, fontscale, color, thickness)
```
* 計算偏移量：車道中心x座標-影像中心x座標
* 根據偏移量判斷車量鄉對於車道的偏移方向
* 在影像上顯示車道線標籤，偏移量，和偏移方向
```python
def visualize_results(self, frame, left_line, right_line, lane_center):
	result = frame.copy()
	height, width, _ =frame.shape
# 繪製所偵測道的線
	if left_line is not None:
		x1, y1, x2, y2 = left_line[0]
		cv2.line(result, (x1,y1), (x2,y2), (0,0,255),5)
		cv2.putText(result, "Left Lane", (x2,y2-10), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0,0,255),2)
	if right_line is not None:
		x1,y1,x2,y2 = right_line[0]
		cv2.line(result, (x1,y1),(x2,y2), (0,255,0),5)
		cv2.putText(result, "Right Lane",(x2,y2-10),cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0,255,0),2)
	# 繪製中心線影像
	center_x = width // 2
	cv2.line(result, (int(lane_center), height), (int(lane_center), height-50), (255,0,0),5)
	cv2.line(result, (center_x,height), (center_x, height-50),(255,255,0),5)
	# 計算並顯示偏移量
	offset = lane_center - center_x
	offset_text = f"Offset: {offset:.2f} pixels"
	cv2.putText(result, offset_text, (width//2-100, height-20),cv2.FONT_HERSHEY_SIMPLEX,1,(255,255,255),2)
	if offset > 0:
		direction = "Offset right"
	elif offset < 0:
		direction = "Offset left"
	else:
		direction = "No offset"
	cv2.putText(result, direction, (width//2-80,height-60),cv2.FONT_HERSHEY_SIMPLEX, 1, (255,255,255),2)
	return result
```

## 新想法
* 先不要分左右車道，把hough find line所得到的結果先畫出來，看一下是否分了兩個車道
* 先不要處理x1,x2,y1,y2, 先將得到的結果畫出來就好了
* 分左右車道可以一句畫面上的位置，線的角度等等的來區分
* 可以優化的地方：
	* ROI的定義區域, 基本上就是下半部
	* 左右車道的定義
		* 也許可以寫分成如果只偵測道一個車道且x座標大於0.3 * width則必為右車道
		* 左右都有偵測到分開寫
		* 或是只偵測到一個的話去算如果大部分的x座標小於0.7*width將他全部規於左車道
		* 反之大於0.3*width全部規於右車道
* 在高斯降噪後可以使用thershold 或是 adaptivethreshold將影像轉為二值圖，以便之後的canny 邊緣檢測
### Threshold vs adaptiveThreshold
* Method 1. cv2.threshold(): Global Thresholding
	* 這個函數會根據你設定的一個thresh，將整張圖像素分為：
		* 高於thresh，設為maxval
		* 低於thresh，設為0
	* 適合用於:
		* 均勻光線，室外不適合
		* 反應較快
	* 語法:
	* src: 必須是灰階
	* type: 通常是  cv2.THRESH_BINARY
```python
_, binary = cv2.threshold(src, thresh, max_val, type)
```
* Method2. cv2.adaptiveThreshold():**自適應門檻值**
	*  將影像切成一個個小區域，每塊各自算自身門檻，在依據每個區域自定義門檻
	* 這讓影像
		* 亮部有自己門檻
		* 暗部也有，使整體更穩定，適合光影變化
	* 語法
		* src: 灰階圖
		* adaptiveMethod:`cv2.ADAPTIVE_THRESH_MEAN_C` 或 `cv2.ADAPTIVE_THRESH_GAUSSIAN_C`
		* thresholdType: cv2.THRESH_BINARY
		* blocksize: 門檻計算區域
		* c: 偏移值，越大越容易變黑色
```python
adaptive = cv2.adaptiveThreshold(src, maxval,adaptiveMethod, thresholdType, blocksize, C)
```

### 車道區分方式改進
* 原本是依據車道在畫面的左右位置進行劃分，如果是車道為水平線則值糾歸類於左車道
* **添加一個方法是車道不會突然變換**
* 核心概念：紀錄前一個幀數的車道，因為車道不會突然變化，在前一幀為左車道下一幀不可能突然變為右車道
* 一開始左右車道一定要辨認正確
* 判斷車道的方式：與前一幀左車道與右車道比較x座標，差距小於一定幀數就將其歸類於該車道
* 提高雜訊濾波
## Use findContour instead of Houghfindline
* Assume the lane_width at the bottom 
# Reference
[高斯模糊參考一](https://www.ruanyifeng.com/blog/2012/11/gaussian_blur.html)
[高斯模糊參考二](https://www.cnblogs.com/keye/p/18413299)
[Canny edge detection](https://medium.com/@bob800530/opencv-%E5%AF%A6%E4%BD%9C%E9%82%8A%E7%B7%A3%E5%81%B5%E6%B8%AC-canny%E6%BC%94%E7%AE%97%E6%B3%95-d6e0b92c0aa3)
[OpenCV函數大全](https://blog.csdn.net/Vici__/article/details/100714822)
[霍夫變換原理](https://zhuanlan.zhihu.com/p/203292567)
[膨脹跟侵蝕](https://shengyu7697.github.io/python-opencv-erode-dilate/)
[圖像輪廓辨識](https://vocus.cc/article/67ad8176fd897800019fcf64)