---
created: 2025-08-03T14:22
updated: 2026-03-09T17:02
title:
---
2026-02-01 15:57

Status:

Tags:
目錄(ctrl+p):
# ROS1 Navigation Robot Simulation
一般來說，global planner 跟 local planner都是直接使用navigation stack(A* 或是 Dijkstra algorithm)來實做，但並不能實現實時避障，因此這次的專案的目的是，global planner 仍維持使用navigation stack而local planner則是利用強化學習演算法(PPO, DQN etc.)來實施實時避障，一旦成功在載具上成功實做，也可以套用到其他種類機器人上。
- [ ] Build docker image for ros1([[Docker]] )
- [ ] Learn URDF and xacro( For build my own car)
- [ ] Show the car in rviz and run in the gazebo
- [ ] Add sensor at car for slam
- [ ] Build map use slam(lots of methods like gmapping, hector mapping, etc.)
- [ ] Navigation part

## 問題
### Gazebo 在docker裡如何安裝
我看有些事寫在dockerfile裡，有些又是用bash來跑指令，而且要用哪個image還不知道，是要先用ubuntu20.04嗎，還是用ros::noetic或是用已經裝好gazebo 版本的image?
# Reference
[B站ros1影片](https://www.bilibili.com/video/BV1Ci4y1L7ZZ?spm_id_from=333.788.videopod.sections&vd_source=884c78e6ffadf9f643cedd800db793be&p=229)
