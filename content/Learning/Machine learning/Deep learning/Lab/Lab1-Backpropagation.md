---
created: 2025-08-03T14:22
updated: 2026-03-28T12:21
title:
---
2026-03-23 23:11

Status:

Tags:
目錄(ctrl+p):
# Lab1-Backpropagation
## Implementation details
1. Model
	1. Linear
	2. MLP
2. Activation function
	1. Sigmoid
	2. ReLU
3. Backpropagation 
4. Optimizer
	1. SGD
	2. Adam
### Model construction
All the neuro networks components inherit from an abstract NNModule parent class. This basic class define three essential methods that constitute the foundation of neural network operations:
* foward: Implement the foward pass where inputs are propagated through th e networks to produce outputs. This method defines the computational behavior of each network component during inference. 
![[Lab1_foward.png]]
* backward: Handles the backward pass(gradient backpropagation), where gradiets are computed respect to parameters and inputs. This method enables the network to learn by calculating the gradient needed for update parameters. 
![[Lab1_backward.png]]
* parameters: Provide access to learnable parameters and their correspnding gradients that are necessary during optimization. This method allows the optimizer to efficiently update the network's parameters based on the computed gradients.  
![[Lab1_gd.png]]

每一層的神經網路架構都會包含這三個要素，不論是線性、CNN或是activation function。
```python
class NNModule:
	def foward(self, x):
		NotImplementedError
	def backward(self, grad):
		NotImplementedError
	def parameters(self):
		NotImplementedError
		
```
#### Questions
* 當我在手刻backward函數時，我這層的梯度不是由我這層的公式來決定的嗎，為何還要傳進來一個grad？
	* 簡單來說backward函數的grad是代表『後方所有輸入層對當前層輸出』累積下來的總梯度。
	* 神經網路是一條流水線，輸入從最前面經過一層層的Linear+activation層後到達輸出結果與實際結果比較，從最後面開始回傳Loss。而根據chain rule，若要計算Loss(L)對某一層的輸入的偏微分，公式如下：$$\frac{\partial L}{\partial x}=\frac{\partial L}{\partial y}\frac{\partial y}{\partial x}$$
		* $\frac{\partial L}{\partial y}$：就是傳進來的`grad`。他是下游（靠近輸出端）傳回來的梯度，代表Loss對這一層的變化。
		* $\frac{\partial y}{\partial x}$：是這一層自己負責計算的偏微分，代表這一層輸出對輸入的變化率

#### Linear layer
Linear layer(線性層) is the fundamental blocking of MLP. It performs an affine transformation on the input data with using the weight matrix $W\in R^{m*n}$and bias matrix $B\in R^{m}$  where n and m represent the the number of the input and output features, respecively. Formally the linear transformation is defined as：$$\text{Linear(x)}=xW^T+b$$
When implementing Linear layer, first have to define input_features and output_features, and then build weight and bias's parameters.

Derive the gradient of the linear layer to weight and bias, recall that the definition of linear layer:$$y=xW^T+b$$, where $y\in R^n$ is the output, and $x\in R^m$ is the input, $W\in R^{n*m}$ is the weight matrix, and $b\in R^n$ is the bias vector, in the backpropagation, we need to calculate the derivative with respect to the **x(input), W(weight matrix) and b(bias vector)**:
$$
\begin{aligned}
\frac{\partial L}{\partial W}&=\frac{\partial L}{\partial y}\frac{\partial y}{\partial W}=\left( \frac{\partial L}{\partial y} \right)^Tx\\
\frac{\partial L}{\partial b}&=\frac{\partial L}{\partial y}\frac{\partial y}{\partial b}=\sum_{i}\frac{\partial L}{\partial y_{i}} \\
\frac{\partial L}{\partial x}&=\frac{\partial L}{\partial y}\frac{\partial y}{\partial x}=\left( \frac{\partial L}{\partial y} \right)W
\end{aligned}
$$
Same batch use same weight and bias.
```python
class Linear(NNModule):
	def __init__(self, in_features, out_features, bias=True):
		self.in_features = in_features
		self.out_featires = out_features
		
		# Define weight and bias
		self.weight = Parameter(np.random.randn((out_features, in_features)))
		self.bias = Parameter(np.random.randn(out_features)) if bias else None
	def foward(self, x):
		self.input = x
		if self.bias is not None:
			return np.dot(self.input, self.weight.data.T)+self.bias.data
		return np.dot(self.input, self.weight.data.T)
	def backward(self, grad):
		self.weight.grad += np.dot(grad.T, self.input) # Why not just self.weight.grad = np.dot(grad.T, self.input)
		if bias is not None:
			self.bias.grad = np.sum(grad, axis=0)
		return np.dot(grad, self.weight.data)
	def parameters(self):
		if bias is not None:
			return [self.weight, self.bias]
		return [self.weight]
		
		
```

* Key point: The reason why in the backward function, we don't directly assign the segradient result to the `self.weight.grad` is that it only correct when the neural network is just a single way pass (like linear1 -> linear 2 -> linear3...), but when one neuron have two input, then if we just use  = instead of +=, the gradient we calculate before will loss.
* For example: Do a simple calculation $y=x^2+x$, in the neuro network, it means the input is dicided into two place and add it up
	* path a: $f(x)=x^2$ => grad is $2x$
	* path b:$g(x)=x$=>grad is 1
	When doing the backward :
	* we first calculate path a: `x.grad=2x`
	* then we calculate path b
		* if we use =, then the `x.grad=1`, 2x is covered!!!
		* if use +=, the the `x.grad=2x+1` is right gradient!!!
#### MLP
這次要實做的是MLP with 2 hidden layer，所以結構是：
linear1 -> activation1 -> linear2 -> activation2
* foward：用每層foward函數依照linear1->activation1->linear2->activation2的順序
* backward：用每層的backward函數依照activation2->linear2->activation1->linear1的順序
* parameters：用linear1跟linear2的parameters函數回傳所有MLP裡面的參數，方便optimizer更新參數

### Activation function
使用activation function的目的：在類神經網路如果不用activation fuction，那麼在類神經網路中皆是以上層的輸入的線性組合作為這一層的輸出(也就是矩陣相乘)，那麼輸出與輸入依然脫離不了線性關係，做深層類神經網路遍失意義。

![[Lab1_NNstructure.png]]
* Sigmoid：
The sigmoid function is formally defined as :
$$
\text{Sigmoid(x)}=\frac{1}{1+e^{-x}}
$$
在計算loss function對各個參數的偏微分時(Backward反向傳導)，會用到activation function 的偏微分，因此以下為推導：
$$
\begin{aligned}
\frac{d}{dx}\sigma(x)&=\frac{e^{-x}}{(1+e^{-x})^2} \\
&=\frac{1}{1+e^{-x}}+\frac{e^{-x}}{1+e^{-x}} \\
&=\sigma(x)+(\frac{1+e^{-x}}{1+e^{-x}}-\frac{1}{1+e^{-x}}) \\
&=\sigma(x)(1-\sigma(x))
\end{aligned}
$$
* ReLU:
ReLU function is formally defined as:
$$
\text{ReLU(x)}=max(0, x)
$$
在backpropagation時會用到activation的偏微分，以下為結果：
$$
\frac{d}{dx}\mathrm{Re}LU(x)=
\begin{cases}
1, \text{if x>0}\\ 
0, \text{if x}\leq 0
\end{cases}
$$

### Loss function
在這個程式裡我們採用均方誤差(Mean Square Error)，定義為：
$$
\text{MSE}=\frac{1}{n}\sum_{i=1}^n(y_{i}-\hat{y_{i}})^2
$$
在做backpropagation時會需要對y做偏微分，當我們對某一個具體的預測值$\hat{y_{i}}$求偏微分時，其他的預測值如$\hat{y_{j}}$對該項來說是常數
$$
\begin{aligned}
\frac{\sigma MSE}{\sigma \hat{y_{i}}}&=\frac{\sigma}{\sigma \hat{y_{i}}}\Bigr[\frac{1}{n}(y_{1}-\hat{y_{1}})^2+\dots+(y_{i}-\hat{y_{i}})^2+\dots+(y_{n}+\hat{y_{n}})^2\Bigr] \\
&= \frac{2}{n}(y_{i}-\hat{y_{i}})
\end{aligned}
$$

## Backprogragation
The backpropagation algorithm is implemented through the **backward** method in each modules, which computes gradients for all parameters and **returns the gradient with respect to the input.** These gradients are stored in the grad attribute of each parameter, making them accessible to the optimizer for parameter updates.

The design of the **Parameter** class is central to this implementation. Each parameter object contains two attributes: data, which stores the actual parameters values(e.g. weight, bias), and grad, which stores the computed gradients for each parameter. This seperation facilitates the optimization process by providing a clear interface for updating parameters based on their gradients.

## Optimizer
The optimizer implements the parameter update strategy through the computed gradient. For the implementation, i use the simple Stochastic Gradient Descent(SGD) optimizer, which updates the parameters in the direction of the negative gradient scalsed by the learning rate:
$$
W\leftarrow W-\eta\frac{\partial L}{\partial W}
$$
Optimizer always have to implement two important method:
1. zero_grad():
2. step():
The reason why we need to design another function `zero_grad()` to clean each parameter's gradient 

## Main training loop & Argument setting
Use argparse to input the argument by command line or set the default value for those argument and we can use those arguments in functions.
The arguments that need to be consist in this project are:
* data: linear / XOR data, string type
* epcohes: The number of epoches, int type
* lr: learning rate, flioat type
* num_neurons: hidden_features numbers
* output_path: the output path of the result

## Questions
1. What is the purpose of activation function?
2. What might happen if the learning rate is too large or too small?
3. What is the purpose weights and biases in a neural network?
# Reference
[Backpropagation video](https://www.youtube.com/watch?v=ibJpTrp5mcE)
[Backpropagation introduction](https://tomohiroliu22.medium.com/%E6%A9%9F%E5%99%A8%E5%AD%B8%E7%BF%92-%E5%AD%B8%E7%BF%92%E7%AD%86%E8%A8%98%E7%B3%BB%E5%88%97-99-%E7%A5%9E%E7%B6%93%E7%B6%B2%E7%B5%A1-neural-network-1e7177542995)
[Introduction of linear layer and MLP](https://www.zhihu.com/question/607822173/answer/3085671476)
[Introduction of different optimizer](https://medium.com/%E9%9B%9E%E9%9B%9E%E8%88%87%E5%85%94%E5%85%94%E7%9A%84%E5%B7%A5%E7%A8%8B%E4%B8%96%E7%95%8C/%E6%A9%9F%E5%99%A8%E5%AD%B8%E7%BF%92ml-note-sgd-momentum-adagrad-adam-optimizer-f20568c968db)
[argprase的用法](https://shengyu7697.github.io/python-argparse/)
