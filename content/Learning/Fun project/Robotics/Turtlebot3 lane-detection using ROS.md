---
created: 2026-02-01T15:50
updated: 2026-02-03T01:17
---
2025-05-13 14:08

Status:

Tags:[[Docker Bug Handle]],[[Launch file]],[[Publisher and Subscrber]],[[CV bridge]], [[AMCL]]

# Turtlebot3 lane-detection using ROS
## Todo list

- [x] Build ros docker and makefile to run ROS in rasberry pi ✅ 2026-02-03
- [x] Create node to use video to detect the lane offset and send the message
- [x] Change the lane detect node from using video to the web camera on raspi
- [x] Create the node that subscribe lane_offset, use the topic to determine the pwm of right and left wheels and publish the message.
- [x] Write arduino file to subscribe the pwms msgs, and use encorder to control PID of the motor's pwm.
- [x] Revise the lane_detection node to let camera can identify the upper part of the triangle to let turtlebot know which direction to turn.
- [x] Fix the x11(display image problem) on raspi (very hard)
- [x] Fix catkin_make problem on raspi
- [x] Update the lane-detection algorithm
- [x] Finish readme description for docker in desktop and on raspi4
- [ ] Update the new code in raspi4 to PC
- [ ] Write fuzzy control for the chassis of turtlebot(Can make reference by PID.ino)
- [ ] Write navigate alogrithm to part 2(rplidar, hector_mapping, amcl)
# Reference