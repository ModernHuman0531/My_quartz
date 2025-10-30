---
created: 2025-08-03T14:22
updated: 2025-10-28T19:38
title:
---
2025-10-24 14:54

Status:

Tags:
目錄:
# Kinematics
## Link connection
將每一個joint看成是一個座標系，而如果要將兩個不同的座標系要對齊我們要利用四個參數，分別為
$$\alpha_{i},d_{i},a_{i},\theta_{i}$$
有了這四個參數我們便能描述各個座標系間的關係，也就能找到轉換矩陣，而這個用來描述各個joint座標系關係model我們稱為**DH model**
* 參數定義

| Symbol         | Definition                                          |
| -------------- | --------------------------------------------------- |
| $$\theta_{i}$$ | $$\text{以$\hat{z}_{i-1}$方向看$X_{i-1}$與$X_{i}$間的夾角}$$ |
| $$d_{i}$$      | $$\text{以$\hat{z}_{i-1}$方向看$X_{i-1}$與$X_{i}$間的距離}$$ |
| $$a_{i}$$      | $$\text{以$\hat{X}_{i}$方向看$z_{i-1}$與$z_{i}$間的距離}$$   |
| $$\alpha_{i}$$ | $$\text{以$\hat{X}_{i}$方向看$z_{i-1}$與$z_{i}$間的夾角}$$   |
* 旋轉順序(要從frame i-1 到frame i 的步驟)
$$
\begin{align}
T^{i-1}_{i}&=A_{n} \\
&=R(z_{i-1},\theta)Trans(0,0,d_{i})Trans(a_{i},0,0)R(x_{i},\alpha_{i}) \\
&=\left[ \begin{array}{cc}
c\theta_{n}&-s\theta_{n}c\alpha_{n}&s\theta_{n}s\alpha_{n}&a_{n}c\theta_{n} \\
s\theta_{n}&c\theta_{n}c\alpha_{n}&-c\theta_{n}s\alpha_{n}&a_{n}s\theta_{n} \\
0&s\alpha_{n}&c\alpha_{n}&d_{n} \\
0&0&0&1
\end{array} \right]
\end{align}
$$
* Joint
	* Revolute joint：變數為theta_i
	* Prismatic joint：變數為d_i
	* tips:在畫這些變動的joint時我們會把他們假設為0畫
![[DH_graph.png]]
* Joint space vs Cartesian Space
從每個joint要轉多少度推到最後手臂末端在卡式座標系的位置稱為正向運動學(Foward kinematic)。
反過來說，我們想到空間中的一個特定位置，再回去求每個制動器(joint)要轉多少度，稱為反向運動學。
## Foward kinematics
foward kinematics我們會知道每個joint要轉的角度，列出旋轉矩陣後可以得到從世界座標系看手臂末端的座標。

## Inverse kinematics
有兩種解的方式：
1. 代數解：將整個轉換矩陣乘出來對應到最終手臂末端的座標，再回去解每個joint要旋轉的角度。
2. 幾何解:將整個手臂機構依照DH model畫出來，再根據三角函數來解角度
# Reference