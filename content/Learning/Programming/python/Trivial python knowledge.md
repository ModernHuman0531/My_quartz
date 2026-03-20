---
created: 2026-03-09T22:12
updated: 2026-03-14T22:29
---
2025-04-20 16:12

Status:

Tags

# Trivial python knowledge
## Open file

## Numpy (np)
* np.dot(a, b)
	* _a_ and _b_ are 1-D arrays, it is inner product of vectors
* np.random.rand(d0, d1, d2, ...)
	* create an $d_{0}*d_{1}*d_{2}*\dots$ arrays, with random samples from a uniform distribution over $[0, 1)$
	* For example, `np.random.rand(5)` will create like $[0.123, 0.456, 0.789, 0.321, 0.654]$, `np.random.rand(2,3)` will create like $[[[0.789, 0.321, 0.654], [[0.123, 0.456, 0.789]]]$
* np.exp(x)
	* x can be number or matrix, return each input's expotential number's value
* np.sum(x)
	* If x is array, calculate the sum of the elements in array
* np.random.choice(a, size=None, replace=True, p=None)
	* 抽取的對象(a)
		* 如果是array：就從裡面隨機選取元素
		* 如果是整數n：則從 `np.arange(n)` 中選取（即從 0 到 n−1 之間選）
	* 抽取的數量(size)
		* 預設為None(回傳一個值)
		* 可以設定為整數或元組（例如 `size=(3, 2)`），這樣會回傳一個指定形狀的矩陣
	* 是否重複抽取(replace)
		* True(預設)：取後放回
		* False:取後不放回
	* 抽取機率(p)
		* 這是一個與 `a` 等長的列表，用來指定每個元素被抽中的機率
		* 所有機率的總和必須等於 1
* np.zeros_like(a)
	* a為矩陣，是要建立跟a形狀相同但內容全為0的矩陣
## Draw figure functions
要先`import matplotlib.pyplot as plt`
### 基本function
* **plt.figure()** : Build the space for the figure, we can assign the size and dpi of the figure
```python
weight, height = 8, 6
plt.figure(figsize=(weight, height), dpi = 100)
```
* **plt.plot():** Draw the line chart
	* 'color' parameter can set color for that line
	* 'linewidth' parameter can set line's width 
```python
x_axis_info,y_axis_info=[1,2,3],[4,5,6]
plt.plot(x_axis_info, y_axis_info, label='Line 1', color='blue',linewidth=2)
```
* **plt.xlabel()/plt.ylabel()/plt.title():** Give the label for x and y axis, and give title to the chart
	* fontsize is the size of the char
```python
plt.xlabel('x-axis's name', fontsize=12)
plt.ylabel('y-axis's name', fontsize=12)
plt.title('Plot's name')
```
* plt.ylim()/plt.xlim():限制Y/X軸範圍
```python
plt.ylim(-7,2) # 將y軸範圍限制在(-7,2)
```

* **plt.legend():** Show the label of each line
```python
plt.legend()
```
* **plt.grid():** Show the grid line in the chart
```python
plt.grid(True)
```
* **plt.tight_layout():** Automatically adjust each subplot's distance
```python
plt.tight_layout()
```
* **plt.saveconfig():** Save th plot to the set name
```python
plt.savefig("my_plot")
```
* **plt.close():** Close the plot
```python
plt.close()
```

### 數據處理(最好要import numpy)
#### np.linspace()
* 要產生一個連續的輸入，像是從1開始到10有限個點作為連續輸入
```python
np.linspace(start, end, total_point_number)
```
#### np.argmin() : 在陣列中找到最小值的索引
```python
min_idx = np.argmin(E_N)
```

# Reference
[numy reference](https://steam.oxxostudio.tw/category/python/numpy/numpy-random.html)
