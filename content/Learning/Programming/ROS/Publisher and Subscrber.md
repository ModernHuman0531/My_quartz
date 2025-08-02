2025-05-07 12:47

Status:

Tags:

# Publisher and Subscrber
* 簡單的publisher寫法
```python
#!/usr/bin/env python
import rospy
from std_msgs.msg imnport string

def talker():
	# 創見發布者(publisher)，發布到名為"chatter"的話題，佇列大小為10(可以儲存10個)
	pub = rospy.Publisher('chatter', String, queue_size=10)
	# 初始化ROS節點
	rospy.init_node('talker', annoymous=True)
	# 設置循環頻率10HZ
	rate = rospy.Rate(10)
	count = 0
	# 當節點沒有被關掉
	while not rospy.is_shutdown():
		# 創建消息
		hello_str = f"hello world {count}"
		# 輸出訊息到terminal，但訊息尚未發布
		rospy.loginfo(hello_str)
		# Publish the message
		pub.publish(hello_str)
		# 按照設定的頻率(10HZ)休眠
		rate.sleep()
		count+=1
if __name__ == '__main__':
	try:
		talker()
	except rospy.ROSInterruptException:
		pass

```
* 簡單的Subscriber寫法
```python
#!/usr/bin/env python
import rospy
from std_msgs.msg import String

def callback(msg):
	"""
	當收到訂閱的話題的消息時，此函數會被調用
	"""
	# Message in call-back function will store the msg you subscribe
	# 處理接收到的消息
	rospy.loginfo("I heard: %s", msg.data)

def linster():
	# 初始化ROS節點
	ros.init_node('listener', anonymous=True)

	# 創建訂閱者，訂閱名為"chatter"的話題
	# 當收到消息時，調用callback函數處理
	# queue.size 指定接收佇列的大小
	rospy.Subscriber("chatter", String, callback, queue_size=10)
	# 保值節點運行，直到被Ctrl+c 中止
	rospy.spin()
if __name__ == '__main__':
	listener()
```

* std_msgs裡都有msgs.data,可以得到資料裡面的數值，但在自定義的msgs裡沒有.data除非自己設定
* 寫完node後要記得將scripts設為可執行
```zsh
chmod +x scripts/publisher.py
```
## 修改Cmake 跟 package.xml
* 1. 添加自定義msgs時要對Cmake跟package.xml進行修改
* Cmakefile
```
find_package(catkin REQUIRED COMPONENTS
  roscpp
  std_msgs
  message_generation
)
...
add_message_files(
  FILES
  MotorPWM_msg.msg
)

generate_messages(
  DEPENDENCIES
  std_msgs
)
...
catkin_package(
  CATKIN_DEPENDS roscpp std_msgs message_runtime
)



```
* package.xml
```
<build_depend>message_generation</build_depend>
<exec_depend>message_runtime</exec_depend>

```
# Reference
[ROS to OpenCV](https://blog.csdn.net/weixin_40863346/article/details/80430251)
[Self-defined msgs](https://ithelp.ithome.com.tw/m/articles/10208459)
