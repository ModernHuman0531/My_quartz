2024-11-08 12:50

Status:

Tags: [[Docker]], [[Launch file]]

# Launch file
* 傳遞參數的方法
1. **<arg> :
	1. 類似程式的命令列參數
	2. 可以在啟動launch時從命令列傳進來，或是在launch file中設預設值
	3. 寫在arg裡面的值不能被取用
	4. 範例：
	<arg name="visualization" default="true" />
	啟動時指定：
	roslaunch my_package my_launch.launch visualization:=false

	
   2.<param>:  
	   1.跟arg最大的差別是param可以被取用
	   2. 用rospy.get_param('param_name', default value)




# Reference

[# ROS 学习笔记（七）—— roslaunch 详解](https://blog.csdn.net/zxxxiazai/article/details/108231232)
[# Launch Files](http://www.clearpathrobotics.com/assets/guides/melodic/ros/Launch%20Files.html)