2025-05-13 19:54

Status:

Tags:

# Rosserial
* 為了讓arduino能與ROS通訊的package, rosserial 提供一種方式讓arduino可以發布跟接收rostopic
* 不需要在裡面命名節點，他會給一個內建的稱為arduino_node, 在些launch file時可以用,是由動serial_node.py(下載rosserial 後會有的)
* launch file寫法
```xml
<!--Node to activate the node -->
<node name="arduino_node" pkg="rosserial_python" type="serial_node.py" output="screen">
	<param name="port" value="/dev/ttyACM0" />
	<param name="baud" value="57600" />
</node>

```

## Rosserial setup
* Rosserial 在本機上的arduino跑所需要做的設定(不用在本機上裝ros)
* 1. 要在裝有ros的docker container裡執行
```zsh
rosrun rosserial_arduino make_libraries.py /tmp/ros_lib
```
這會將編譯好的libraries(包括自己設定的msgs等等的)放在docker裡的/tmp/ros_lib
* 2.將該lib複製到本機上/Arduino下的libraries目錄裡(沒有的話自己創)
* 將docker裡的東西複製到本機上的方法是先用``docker ps`` 找到你的docker ip，再用
``docker cp container_id:/tmp/ros_lib ~/Ardiono/libraries/ros_lib``
* 3. 將你arduino裡的preference(即libraries讀取來源)句更改為``~/Arduino``
* 4. 重啟arduino
		
# Reference