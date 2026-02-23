---
created: 2025-11-05T22:09
updated: 2026-02-01T17:18
---
<2024-11-08 17:28

Status:

Tags:

# Docker Bug Handle
## Build a docker that can run `ROS1`
* 1 
* 2
* 3
* Install `zsh`(Is an UNIX command interpreter (shell) that is used as an interactive login shell and as a shell script command processor), `oh-my-zsh` , `powerlevel10k` , `zsh-autosuggestions` , `zsh-syntax-highlighting`.
* 5.Set `.zshrc` and `.pk10.zsh` (The setting of the terminal type).
	* `COPY dotfiles/.p10k.zsh /root/.p10k.zsh` 
	* `COPY dotfiles/.zshrc /root/.zshrc`
	* If we don't set these 2 lines, then every time we enter the docker, we have to set it again.
* 6.Bind the folder into docker so that we can whenever we change in desktop can simultaneously in container.
	*  Use **bind mount**: a file or directory on the host machine is mounted into a container.
* 
* 8.Add gazebo in `dockerfile`.
* 9. Add `--ulimit nofile=1024:524288` to enhance the compatibility with the computer  

## Build a line detector package
### Use opencv in ROS to send message
* 一定要除了opencv外還要裝cv bridge，因為通訊要用ROS來傳遞offest，但ROS跟opncv儲存影像的方式不同需要通過cv bridge 來轉換
```dockerfile
RUN apt-get update && apt-get install -y \
    ros-noetic-cv-bridge \
    ros-noetic-image-transport \
    ros-noetic-camera-info-manager \
    ros-noetic-vision-opencv \
    ros-noetic-sensor-msgs \
    && rm -rf /var/lib/apt/lists/*
```
## Load USB in docker
* 在linux裡，每個實體裝置都(USB,攝像頭)都會有一個設備節點(Arduino: /dev/ttyUSB0)，而docker預設為了安全，不會讓容器自動存取這些裝置。因此，我們需要告訴docker我們需要這個裝置，用--device語法
```zsh
--device=/dev/ttyUSB0 \ # Load arduino

--device=/dev/video0 \ #Load web camera
```

## Use and upload code to Arduino in docker
* 要在dockerfile裡安裝arduino-cli
	* 用來替代GUI的arduino IDE
	* 可以編譯.ino檔
	* 可以燒錄程式到板子
	Recommanded file structure

```
ros_docker_project/
├── Dockerfile
├── Makefile
├── arduino/
│   └── my_sketch/
│       └── my_sketch.ino
└── catkin_ws/
    └── ... 你的 ROS 工作空間 ...

```
如果我是要在ros裡先用opencv攝像頭來處理影像算出offset並送出offset 作為publisher的message，寫一個subscriber訂閱這個message並定一個offset轉pwm的規則，並publish這個pwm到arduino上用PID來進行馬達控制，請告訴我大概架構應該如何些，跟有要改動到哪些東西
Upated makefile，在樹梅派時要更改
```makefile
DOCKER_IMAGE=ros-noetic-custom
DOCKER_CONTAINER=ros_noetic_container
DOCKERFILE=Dockerfile
SKETCH_NAME=my_sketch

all: build run

build:
	docker build -t $(DOCKER_IMAGE) -f $(DOCKERFILE) .

# 注意掛載的地方要更改，-v是在主機上的地方，但在樹梅派上的位置會改變
run:
	docker run -it --rm \
		--device=/dev/ttyACM0 \
		--device=/dev/video0 \
		--privileged \
		-v $(HOME)/Documents/control_lab/HW06/ros_docker_project/catkin_ws:/catkin_ws \
		-v $(PWD)/arduino:/arduino \
		--name $(DOCKER_CONTAINER) \
		$(DOCKER_IMAGE)

upload:
	docker run -it --rm \
		--device=/dev/ttyACM0 \
		--privileged \
		-v $(PWD)/arduino:/arduino \
		$(DOCKER_IMAGE) \
		arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:mega:cpu=atmega2560 /arduino/$(SKETCH_NAME)

compile:
	docker run -it --rm \
		-v $(PWD)/arduino:/arduino \
		$(DOCKER_IMAGE) \
		arduino-cli compile --fqbn arduino:avr:mega:cpu=atmega2560 /arduino/$(SKETCH_NAME)

clean:
	docker system prune -f
	docker rmi $(DOCKER_IMAGE)

```
## Common Mistake
* 1. 本機沒有權限寫跟存檔案
```vbnet
Failed to save 'lane_detector_node.py': Unable to write file ... (NoPermissions (FileSystemError): Error: EACCES: permission denied)
```

即使你是在 **本地端編輯**，卻無法儲存，是因為該檔案或資料夾的 **擁有者是 Docker 容器內的 root 使用者**，導致你本機使用者（如 `dunkun`）沒有寫入權限。
在你的主機（不是容器內）執行：
```zsh
sudo chown -R $USER:$USER /home/dunkun/Documents/control_lab/HW06/ros_docker_project/catkin_ws

```
這會把 `catkin_ws` 目錄（含內部檔案）設為你自己帳號的擁有權
* 2. Attach 進docker後無法執行catkin_make
* 是因為環境沒有架設好
* attach指令通常是@sudo docker exec -it $(DOCKER_CONTAINER) /bin/zsh``
* 還要在加上讓它進去時自動source好環境，並開啟zsh
```zsh
@sudo docker exec -it $(DOCKER_CONTAINER) /bin/zsh -c "source /catkin_ws/devel/setup.zsh && /bin/zsh"
```
* 3.（`qt.qpa.xcb: could not connect to display`）
* 表示 Qt 平台插件（用于显示图像的 OpenCV `imshow`）无法连接到显示器。
* 希望在有 GUI 的机器上使用 `cv2.imshow`，需要确保安装了所需的 Qt 库。你可以通过以下命令安装：
```zsh
sudo apt-get install libxcb-xinerama0
sudo apt-get install qt5-qmake qtbase5-dev-tools qtbase5-dev

```
4. 安裝 `xhost` 指令。這是用來讓 Docker 容器存取你的 X11 顯示系統的工具
### USB 在docker 裡掛載
* 在docker裡，usb 裝置不會自動可用，必須手動掛載宣告可用
* 1. 列出目前usb裝置資訊
```zsh
lsusb
```
* 可能會輸出
```zsh
Bus 001 Device 004: ID 2341:0042 Arduino SA Mega 2560 R3
Bus 001 Device 006: ID 046d:0825 Logitech, Inc. Webcam C270
```
* 2. 確認/dev/下的對應節點
* Arduino 通常被掛載在：
```zsh
ls /dev/ttyACM*
```
or 
```zsh
ls /dev/ttyUSB*
```
* 通常是``/dev/ttyACM0 ``or ``/dev/ttyUSB0''
* USB camera:
```
ls /dev/video*
```
* 通常是``/dev/video0``
* 3. 用``dmesg``確認是哪個設備對應哪個device
* 插入裝置後馬上查看
```zsh
dmesg | tail -20
```
* 會看到以下訊息
```zsh
[12345.678901] usb 1-1.4: New USB device found, idVendor=2341, idProduct=0042
[12345.678902] cdc_acm 1-1.4:1.0: ttyACM0: USB ACM device
```
* 說明arduino mega是掛載在``/dev/ttyACM0``
* 4. Docker 掛載
```zsh
docker run -it -device=/dev/ttyACM0 --device=/dev/video0 image-name
```

## Docker in raspi4 can use catkin_make
* 在一些使用arm架構的平台例如raspi4 ubuntu20.04, CMake可能會找不到`librt`, 導致變編譯`catkin_make`時出錯
* 這時候就要自訂一段rt.cmake角本來跟環境說CMake librt在哪裡擺放教本位置如下
```markdown
lane_follower/
├── CMakeLists.txt
├── package.xml
├── cmake/
│   └── rt.cmake
   └── other_pkg
```
並在CMakeLists.txt裡加上 : 
```cmake
include($(CMAKE_CURRENT_SOURCE_DIR)/cmake/rt.cmake)
```
用來include這段程式
* rt.cmake裡的內容大致是若是在aarch64環境下我們強制手動給定`librt`路徑，其他平台則用`find_library`來找`librt`
* rt.cmake的內容：
```cmake
get_property(ENABLED_LANGUAGES_LIST GLOBAL PROPERTY ENABLED_LANGUAGES)

list(FIND ENABLED_LANGUAGES_LIST "CXX" _cxx_index)

if(NOT (APPLE OR WIN32 OR MINGW OR ANDROID) AND "${_cxx_index}" GREATER -1)

if(${CMAKE_VERSION} VERSION_LESS 2.8.4)

set(RT_LIBRARY rt CACHE FILEPATH "Hacked find of rt for cmake < 2.8.4")

else()

if(CMAKE_SYSTEM_PROCESSOR STREQUAL "aarch64")

set(RT_LIBRARY "/usr/lib/aarch64-linux-gnu/librt.so" CACHE FILEPATH "RT Library for aarch64")

elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")

find_library(RT_LIBRARY rt)

else()

find_library(RT_LIBRARY rt)

endif()

assert_file_exists(${RT_LIBRARY} "RT Library")

endif()

#message(STATUS "RT_LIBRARY: ${RT_LIBRARY}")

endif()
```

## Dockerfile packages

### Network(Ping, ip, etc. functions)
Need to install the following packages:
* iproute2
* iputils-ping
* net-tools

Makefiles corrections


## ZSH install(terminal)

# Reference
[ Docker 基本指令操作](https://ithelp.ithome.com.tw/articles/10186431)
[docker hub about ros](https://hub.docker.com/_/ros/)
[bash versus zsh](https://www.educba.com/zsh-vs-bash/)
[Command of download zsh plugin](https://blog.csdn.net/qq_43826212/article/details/126336514)
[Bind mounts](https://www.cnblogs.com/ittranslator/p/13352727.html)
