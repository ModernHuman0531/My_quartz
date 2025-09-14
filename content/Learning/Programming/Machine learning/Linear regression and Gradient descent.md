---
created: 2025-08-03T14:22
updated: 2025-09-10T21:14
title:
---
2025-09-10 12:56

Status:

Tags:
# Linear regression and Gradient descent
老師投影片重點
### **1. 線性回歸基礎**
- 線性模型方程式：h(x) = θ₀ + θ₁x₁ + ... + θₙxₙ
- 設計矩陣 X 和參數向量 θ
- 預測值計算：Xθ
- 問題: 
	1. why x0=1
	2. 線性模型的缺點
### **2. 成本函數 (Cost Function)**
- 均方誤差 (MSE)：J(θ) = (1/2m)∑(hθ(x⁽ⁱ⁾) - y⁽ⁱ⁾)²
- 矩陣形式：J(θ) = (1/2)(Xθ - y)ᵀ(Xθ - y)
### **3. 正規方程式 (Normal Equation)**
- 解析解：θ = (XᵀX)⁻¹Xᵀy
- 矩陣不可逆問題和解決方案
- 問題
	- 矩陣推導的詳細過程
	- theta是線性模型的參數，要找到使cost function最小的theta
	- Gradient是啥
	- optimizer是啥(2021年有)
### **4. 梯度下降基礎**
- 更新規則：θ := θ - α∇J(θ)，希望能降到最小值
- 學習率 α 的影響
- LMS 更新規則
- 問題:
	- 為啥要用gradient, 背後原理是啥
	- LMS update rule 在convex函數只會落到absolute minimum，因為沒有local minimum
### **5. 梯度下降變體**
在不是convex function 時要如何避免落到local minimum
- Batch Gradient Descent
	- Batch vs epoch
	- Batch size trade-off
- Stochastic Gradient Descent (SGD)
- Mini-batch Gradient Descent

### **6. 優化問題**
- Local minima vs Global minimum
- 凸函數特性
- 避免局部最小值的方法
### **7. 進階優化器**
- Momentum
- Adam
- RMSProp
### **8. 機率解釋**
- 高斯噪聲假設
- 最大似然估計 (MLE)
- 與最小二乘法的關係
### **9. 局部加權回歸 (LWR)**(只要了解概念就好了)
- 非參數方法
- 權重函數
- 帶寬參數 τ
---
# Reference
[Regression](https://www.youtube.com/watch?v=fegAeph9UaA)
[Gradient descent](https://www.youtube.com/watch?v=yKKNr-QKz2Q)
