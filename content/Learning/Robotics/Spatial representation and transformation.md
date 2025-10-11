---
created: 2025-08-03T14:22
updated: 2025-10-12T01:47
title:
---
2025-10-07 18:00

Status:

Tags:

目錄: [[#Rotation matrix|Rotation matrix]]
- [[#NOAP matrix|NOAP matrix]]
- [[#Euler angle and RPY angle|Euler angle and RPY angle]]
	- [[#Euler angle and RPY angle#Fixed angle|Fixed angle]]
	- [[#Euler angle and RPY angle#Euler angle|Euler angle]]
- [[#Pre-multiply and Post-multiply|Pre-multiply and Post-multiply]]
- [[#繞一般軸旋轉𝜃|繞一般軸旋轉𝜃]]
- [[#Specification of Position|Specification of Position]]

# Spatial representation and transformation
## Rotation matrix
* **旋轉矩陣必為正交矩陣**(座標軸互相垂直且座標軸長度為1)，因此符合
$$R^T=R^{-1}$$
* 現在有兩個座標系A跟B，R(A->B)代表A座標系到B座標系的關係，而R(B->A)代表B座標系到A座標系的關係，這兩個矩陣會滿足:
$$R^A_{B}=(R_{A}^B)^T$$
	* **R(A->B)矩陣會等同於R(B->A)矩陣的轉置**，以下為證明:
	$$\begin{aligned}
R_{A}&=[X_{A},Y_{A},Z_{A}],R_{B}=[X_{B},Y_{B},Z_{B}] \\ \\
R_{A}^B&=(R_{B})^{-1}R_{A}=(R_{B})^TR_{A} \\
&=\left[ \begin{array}{cc}
X_{B} \\
Y_{B}  \\
Z_{B}
\end{array} \right]\left[ \begin{array}{cc}
X_{A}&Y_{A}&Z_{A} \\
\end{array} \right] \\
&=\left[ \begin{array}{cc}
X_{B}X_{A} & X_{B}Y_{A} & X_{B}Z_{A} \\
Y_{B}X_{A} & Y_{B}Y_{A} & Y_{B}Z_{A} \\
Z_{B}X_{A} & Z_{B}Y_{A} & Z_{B}Z_{A}
\end{array} \right]\\ \\
R_{B}^A&=(R_{A})^{-1}R_{B}=(R_{A})^TR_{B} \\
&=\left[ \begin{array}{cc}
X_{A} \\
Y_{A}  \\
Z_{A}
\end{array} \right]\left[ \begin{array}{cc}
X_{B}&Y_{B}&Z_{B} \\
\end{array} \right] \\
&=\left[ \begin{array}{cc}
X_{A}X_{B} & X_{A}Y_{B} & X_{A}Z_{B} \\
Y_{A}X_{B} & Y_{A}Y_{B} & Y_{A}Z_{B} \\
Z_{A}X_{B} & Z_{A}Y_{B} & Z_{A}Z_{B}
\end{array} \right]\\
&=(R^B_{A})^T\\
\end{aligned}$$
* 位移矩陣(相對於原本座標系移動px,py,pz)

$$\begin{aligned}
T(p)=\left[ \begin{array}{cc}
1&0&0&p_{x} \\
0&1&0&p_{Y} \\
0&0&1&p_{Z} \\
0&0&0&1
\end{array} \right]

\end{aligned}$$
* 對特殊軸的旋轉矩陣(X,Y,Z軸)
$$\begin{aligned}
R_{x}(\theta)&=\left[ \begin{array}{cc}
1&0&0&0 \\
0&\cos \theta&-\sin \theta&0  \\
0&\sin \theta & \cos \theta & 0 \\
0 & 0& 0& 1
\end{array} \right] \\ \\
R_{Y}(\theta)&=\left[ \begin{array}{cc}
\cos \theta&0&\sin \theta&0 \\
0&1&0&0 \\
-\sin \theta&0&\cos \theta&0 \\
0&0&0&1
\end{array} \right] \\ \\
R_{Z}(\theta)&=\left[ \begin{array}{cc}
\cos \theta&-\sin \theta&0&0 \\
\sin \theta&\cos \theta&0&0 \\
0&0&1&0 \\
0&0&0&1
\end{array} \right]
\end{aligned}$$

## NOAP matrix
*  NOAP的意義是，將旋轉與位移結合成一個`4*4`矩陣(**先旋轉在位移**)，我們也將NOAP矩陣稱為Homogenous transformation。

$$\begin{aligned}
P^A&=R_{B}^AP^B+P_{B(origin)}^A \\
&=\left[ \begin{array}{cc}
R_{B}^A & P_{B(origin)}^A \\
0&1
\end{array} \right]\left[ \begin{array}{cc}
P^B \\
1
\end{array} \right] \\ \\
R_{B}^A&=從frameB到frameA的旋轉矩陣 \\
P_{B(origin)}^A&=從frameA看，frameB原點距離frameA原點向量

\end{aligned}$$
*  NOAP矩陣每個元素的意義
	* NOAP 矩陣
	
$$\begin{aligned}
T&=\left[ \begin{array}{cc}
n_{x}&o_{x}&a_{x}&p_{x} \\
n_{y}&o_{y}&a_{y}&p_{y} \\
n_{z}&o_{z}&a_{z}&p_{z} \\
0&0&0&1
\end{array} \right] \\ \\
[n_{x},n_{y},n_{z}]&=代表新座標系x軸要如何用舊座標系表示 \\
[o_{x},o_{y},o_{z}]&=代表新座標系y軸要如何用舊座標系表示 \\
[a_{x},a_{y},a_{z}]&=代表新座標系z軸要如何用舊座標系表示 \\ \\
NOA矩陣仍是&正交矩陣!!!

\end{aligned}
$$ 
* NOAP矩陣幾何意義
	* Mapping:向量(或點)不動，旋轉座標系，結果是觀察在新座標系原本向量的位置
	![[Mapping.png]]
	* operator:座標系不動，旋轉跟移動向量(或點)
	![[Operator.png]]
*  矩陣連續運算意義與NOAP反矩陣推導
	假設我們在C frame上有個向量我們想從B frame推到A frame上看，我們可以拆解成兩個NOAP矩陣相乘跟一個向量(矩陣跟向量連乘時，順序不重要)，將結果展開
	
$$\begin{aligned}
p^A&=T_{B}^AP^B=T^A_{B}(T_{C}^BP^C)=T^A_{B}T_{C}^BP^C \\
&=\left[ \begin{array}{cc}
R_{B}^A & P_{B(origin)}^A \\
0&1
\end{array} \right]\left[ \begin{array}{cc}
R_{C}^B & P_{C(origin)}^B \\
0&1
\end{array} \right]\left[ \begin{array}{cc}
P^C  \\
1
\end{array} \right] \\
&=\left[ \begin{array}{cc}
R_{B}^AR_{C}^B & P_{B(origin)}^A+R_{B}^AP_{C(origin)}^B \\
0&1
\end{array} \right]\left[ \begin{array}{cc}
P^C  \\
1
\end{array} \right] \\ \\
R&=R_{B}^AR_{C}^B=在連乘時旋轉矩陣結果就是旋轉矩陣連乘 \\
P&=P_{B(origin)}^A+R_{B}^AP_{C(origin)}^B,P_{B(origin)}^A代表從frameA看frameB原點，而P_{C(origin)}^B代表\\從&frameB看frameC原點，而要乘R_{B}^A的原因是你相加要在同一個座標系才有意義，\\而&P_{C(origin)}^B是在B座標系，要轉到A座標系才能相加
\end{aligned}
$$

![[Transformation.png]]
* 根據連乘性值來推導反矩陣，將frame B到frame A變換再從frame A變換到frame B等於沒有變化，結果是一個`4*4`的單位矩陣
$$\begin{aligned}
T_{B}^AT_{A}^B&=T_{B}^A(T_{B}^A)^{-1}=I^4 \\
T^B_{A}&=(T_{B}^A)^{-1}
\end{aligned}$$
* 展開上式可得

$$\begin{aligned}
I^4&=\left[ \begin{array}{cc}
R_{B}^AR_{A}^B & P_{B(origin)}^A+R_{B}^AP_{A(origin)}^B \\
0&1
\end{array} \right] = \left[ \begin{array}{cc}
I^3 & 0 \\
0&1
\end{array} \right]\\
R_{A}^B&=(R_{B}^A)^{-1}=(R^A_{B})^T \\ \\
P_{A(origin)}^B&=-P_{B(origin)}^A*R_{B}^A

\end{aligned}$$
* 從推導可知道B到A的**NOAP反矩陣**為
$$\begin{aligned}
(T_{B}^A)^{-1}&=T^B_{A}=\left[ \begin{array}{cc}
(R_{B}^A)^T &  -P_{B(origin)}^A*R_{B}^A\\
0&1
\end{array} \right] \\
R&=原本矩陣的旋轉矩陣的轉置 \\
P&=-(原本矩陣的位移向量與原本旋轉矩陣的內積)
\end{aligned}$$
## Euler angle and RPY angle
### Fixed angle
* 定義:對固定的軸(世界軸)做旋轉
![[Fixed_angle.png]]
* RPY angle公式:(繞X軸轉ψ，繞Y軸轉θ，再繞Z轉Φ)
	* 依照著正常的矩陣乘法，先動的放右邊。
$$\begin{aligned}
RPY(\phi,\theta,\psi)=R_{X,Y,Z}&=R_{Z}(\phi)R_{Y}(\theta)R_{X}(\psi)
\end{aligned}$$
* 由NOAP結果回推旋轉角度
	*  當我們給定了NOAP矩陣每個元素數值，要回去求Φ，θ，ψ分別轉了幾度，先展開矩陣
$$\begin{aligned}
RPY_{X,Y,Z}(\phi,\theta,\psi)&=R_{Z}(\phi)R_{Y}(\theta)R_{X}(\psi) \\
&=\left[ \begin{array}{cc}
\cos \phi \cos \theta&\cos \phi \sin \theta \sin \psi-\sin \phi \cos \psi&\cos \phi \sin \theta \cos \psi+\sin \phi \sin \psi \\ 
\sin \phi \cos \theta&\sin \psi \sin \theta \sin \psi+\cos \phi \cos \psi&\sin \phi \sin \theta \cos \psi-\cos \phi \sin \psi  \\
-\sin \theta&\cos \theta \sin \psi&\cos \theta \cos \psi
\end{array} \right] \\
\frac{n_{y}}{n_{x}}&=\tan(\phi) \\
-n_{z}&=\sin \theta, \cos \phi n_{x}+\sin \phi n_{y}=\cos \theta \implies \tan \theta=\frac{-n_{z}}{\cos \phi n_{x}+\sin \phi n_{y}} \\
-\sin \phi n_{x}+\cos \phi n_{y}&=\cos \psi, -\sin \phi a_{y}+\cos \phi a_{x}=\sin \psi \\
\implies \tan \psi&=\frac{-\sin \phi a_{y}+\cos \phi a_{x}}{-\sin \phi n_{x}+\cos \phi n_{y}}
\end{aligned}$$
	*  根據上述公式我們可以求得Φ，θ，ψ(用tan算是避免在角度很小時sin跟cos會有誤差)
$$\begin{aligned}
\phi&=\tan^{-1} \frac{n_{y}}{n_{x}} \\
\theta&=\tan^{-1} \frac{-n_{z}}{\cos \phi n_{x}+\sin \phi n_{y}} \\
\psi&=\tan^{-1} \frac{-\sin \phi a_{y}+\cos \phi a_{x}}{-\sin \phi n_{x}+\cos \phi n_{y}}
\end{aligned}$$
### Euler angle
* 定義:每次旋轉都是照著**自身的座標軸轉**，而非固定的世界座標軸
	* 常見的有ZYZ euler angle, ZYX euler angle等(只要不要連續轉相同的軸即可)
![[Euler_angle.png]]
* Euler angle公式:(繞Z軸轉Φ，繞Y軸轉θ，再繞Z軸轉ψ)
$$\begin{aligned}
R_{Z',Y',Z'}(\phi,\theta,\psi)&=R_{Z}(\phi)R_{Y}(\theta)R_{Z}(\psi)
\end{aligned}$$
	* 正常來說矩陣乘法應該是照說序從右到左但繞自身軸轉反而是先轉的軸是在左邊，可以推導此性質，假設我們已經沿Z軸轉了Φ，現在要沿轉過的Y軸轉θ，但我們現在只有沒轉過前Y的旋轉矩陣，因此我們用以下方法
	* 先將Z軸轉回去->對Y軸轉θ->在將Z軸轉回來
$$\begin{aligned}
R_{Z'}&=R_{Z} \\
R_{Y'}(\theta)&=R_{Z'}(\phi)R_{Y}(\theta)R_{Z'}^{-1}(\phi) \\ 
因此R_{Y'}(\theta)R_{Z'}(\phi)&=R_{Z}(\phi)R_{Y}(\theta),由此可證繞自身軸轉時先轉的要放在左邊
\end{aligned}$$
* 由NOAP結果回推旋轉角度
	* 當我們給定了NOAP矩陣每個元素數值，要回去求Φ，θ，ψ分別轉了幾度，先展開矩陣
$$\begin{aligned}
Euler_{Z',Y',Z'}(\phi,\theta,\psi)&=R_{Z}(\phi)R_{Y}(\theta)R_{Z}(\psi) \\
&=\left[ \begin{array}{cc}
\cos \phi \cos \theta \cos \psi-\sin \phi \sin \psi & -\cos \phi \cos \theta \sin \psi-\sin \phi \cos \psi & \cos \phi \sin \theta  \\
\sin \phi \cos \theta \cos \psi+\cos \phi \sin \psi & -\sin \phi \cos \theta \sin \psi+\cos \phi \cos \psi & \sin \phi \sin \theta \\
-\sin \theta \cos \psi & \sin \theta \sin \psi & \cos \theta
\end{array} \right] \\
\frac{a_{y}}{a_{x}}&=\tan(\phi) \\
a_{z}&=\cos \theta, \cos \phi a_{x}+\sin \phi a_{y}=\sin \theta \implies \tan \theta=\frac{\cos \phi a_{x}+\sin \phi a_{y}}{a_{z}} \\
-\sin \phi n_{x}+\cos \phi n_{y}&=\sin \psi, -\sin \phi a_{x}+\cos \phi a_{y}=\cos \psi \\
\implies \tan \psi&=\frac{-\sin \phi n_{x}+\cos \phi n_{y}}{-\sin \phi a_{x}+\cos \phi a_{y}}
\end{aligned}$$
	* 根據上述公式我們可以求得Φ，θ，ψ(用tan算是避免在角度很小時sin跟cos會有誤差)
$$\begin{aligned}
\phi&=\tan^{-1}\left( \frac{a_{y}}{a_{x}} \right) \\
\theta&=\tan^{-1}\left( \frac{\cos \phi a_{x}+\sin \phi a_{y}}{a_{z}} \right) \\
\psi&=\tan^{-1}\left( \frac{-\sin \phi n_{x}+\cos \phi n_{y}}{-\sin \phi a_{x}+\cos \phi a_{y}} \right)
\end{aligned}$$

## Pre-multiply and Post-multiply
* 初始條件:Frame A跟Frame B重合
* {B}對{A}的轉軸旋轉，用"Pre-multiply"(Fixed angle)
	* 以operator來想，對向量(或點)，以同一個座標系為基準進行旋轉或移動
	* 例:依序經過T1,T2,T3三次轉換，公式為
$$\begin{aligned}
T_{B}^A&=T_{3}T_{2}T_{1}I,
v'=T_{3}T_{2}T_{1}v
\end{aligned}$$
* {B}對{B}自身的軸做旋轉，用"Pre-multiply"(Euler angle)
	* 以mapping來想，從最後一個逐漸轉回來第一個frame
	* 例:依序經過T1,T2,T3三次轉換，公式為
$$\begin{aligned}
T_{B}^A=IT_{1}T_{2}T_{3},P_{A}=IT_{1}
T_{2}T_{3}P_{B}
\end{aligned}$$

## 繞一般軸旋轉𝜃
* 我們之前的公式都是建立在繞著特殊軸(X,Y,Z軸)成立的，如果我們並非繞特殊軸而是繞一般軸該如何表達跟得出旋轉矩陣呢
* 想法一.假設在vector T繞著K軸(k=axi+ayj+azk)轉等效於在vector X在frame C繞著Z軸轉，T frame跟X frame間的轉換公式為T＝CX，這樣的公式如下
$$\begin{aligned}
R_{k}(\theta)T&=CR_{Z}(\theta)X,(X先繞著原本的Z軸轉，在轉到frameC) \\
&=CR_{Z}(\theta)C^{-1}T \\
R_{k}(\theta)&=CR_{Z}(\theta)C^{-1} \\
&=\left[ \begin{array}{cc}
n_{x}&o_{x}&a_{x}&0\\
n_{y}&o_{y}&a_{y}&0 \\
n_{z}&o_{z}&a_{z}&0 \\
0&0&0&1
\end{array} \right]\left[ \begin{array}{cc}
\cos \theta&-\sin \theta&0&0 \\
\sin \theta&\cos \theta&0&0 \\
0&0&1&0 \\
0&0&0&1
\end{array} \right]\left[ \begin{array}{cc}
n_{x}&n_{x}&n_{x}&0 \\
o_{y}&o_{y}&o_{y}&0\\
a_{z}&a_{z}&a_{z}&0\\
0&0&0&1
\end{array} \right]
\end{aligned}$$
把上式展開便能得到答案
* 利用Rodrigues轉動公式:對一軸是由x,y,z分量組成的新軸k轉θ度(k=kxi+kyj+kzk)
$$\begin{aligned}
R&=I^4\cos \theta+(1-\cos \theta)kk^T+\sin \theta\left[ \begin{array}{cc}
0&-k_{x}&k_{y}&0\\
k_{z}&0&-k_{x}&0 \\
-k_{y}&k_{x}&0&0 \\
0&0&0&1
\end{array} \right],展開來得 \\
&=\left[ \begin{array}{cc}
k_{x}^2vers\theta+\cos \theta&k_{x}k_{y}vers\theta-k_{z}\sin \theta & k_{x}k_{z}vers\theta+k_{y}\sin \theta&0 \\ 
k_{x}k_{y}vers\theta+k_{z}\sin \theta&k_{y}^2vers\theta+\cos \theta&k_{y}k_{z}vers\theta-k_{x}\sin \theta&0 \\
k_{x}k_{z}vers\theta-k_{y}\sin \theta&k_{y}k_{z}vers\theta+k_{x}\sin\theta&k_{z}^2vers\theta+\cos \theta&0 \\
0&0&0&1
\end{array} \right] \\
vers\theta&=1-\cos \theta
\end{aligned}$$
* 如果給定NOAP矩陣要求繞k軸的角度
$$\begin{aligned}
\sqrt{ k_{x}^2+k_{y}^2+k_{z}^2 }&=1\\
n_{x}+o_{y}+a_{z}+1&=2\cos \theta+2 \\
\cos \theta&=\frac{1}{2}(n_{x}+o_{y}+a_{z}+1)\\
\begin{cases} o_{z}-a_{y}&=2k_{x}\sin \theta \\  
a_{x}-n_{z}&=2k_{y}\sin \theta \\  
n_{y}-a_{x}&=2k_{z}\sin \theta \end{cases} \\
\implies(o_{z}-a_{y})^2+(a_{x}-n_{z})^2+(n_{y}-a_{x})^2&=4\sin^2\theta\\
\sin\theta&=\pm\frac{{1}}{2}\sqrt{ (o_{z}-a_{y})^2+(a_{x}-n_{z})^2+(n_{y}-a_{x})^2 },取正
\end{aligned}$$
從上式得
$$\theta=\tan^{-1}\frac{(\sqrt{ (o_{z}-a_{y})^2+(a_{x}-n_{z})^2+(n_{y}-a_{x})^2 })}{(n_{x}+o_{y}+a_{z}+1)}$$
## Specification of Position
表示位置的座標系
* Cylindrical coordinates(X軸移動𝛾，對Z軸旋轉𝛼，對Z軸轉z)
$$cyl(z,\alpha,\gamma)=trans(0,0,z)R_{z}(\alpha)trans(\gamma,0,0)$$
![[Cylindrical.png]]
* Spehrical coordinate(對Z軸移動𝛾，對Y軸轉𝛽，對Z軸轉𝛼)
$$S(\alpha,\beta,\gamma)=R_{Z}(\alpha)R_{Y}(\beta)trans(0,0,\gamma)$$
![[Spherical.png]]
# Reference
[旋轉矩陣](https://zhuanlan.zhihu.com/p/716611385)
[NOAP matrix](https://blog.csdn.net/just_bear/article/details/136020244)
[Rodrigus旋轉公式](https://zhuanlan.zhihu.com/p/451579313)