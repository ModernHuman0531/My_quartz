---
created: 2025-08-03T14:22
updated: 2026-07-28T22:54
title:
---
2026-02-01 15:57

Status:

Tags:
目錄(ctrl+p):
# ROS Navigation Robot Simulation
重點參考文件：(https://github.com/CzJaewan/rl_local_planner)
想法：
在docker裡用ros2來實現，建圖、定位跟導航的載具，此專案的特點在於使用強化學習算法作為local planner實現自動避障，並比較與傳統的local planner算法的優缺點。

目的：之前使用過ros1，這個專案主要是讓我快速熟悉ros2的使用流程與知識，並結合強化學習算法的實做。

## 已決定細節
1. docker裡使用ros2，模擬環境用gazebo，使用Dockerfile, docker-compose.yaml跟Makefie來維護整個環境
2. 自行實做強化學習算法(決定有PPO,SAC)而不是用內建的算法packages
3. 比較傳統local planner算法跟強化學習算法的成果

## 待決定事項
 1. global planner 該用內建的還是要手刻演算法
 2. mapping跟localization應該要用什麼算法
 3. 內建的機器人要用哪種

## 困難點(自認為)
1. 強化學習的state space該如何設計，有聽說過要把前一個動作也考慮進去會使出來的動作比較連貫
2. 該如何設計gazebo world，因為不可能一直用一樣的地圖，這樣會overfitting，應該有固定的地圖但會隨機生成障礙物，這樣對於即時避障比較有幫助
3. 是在筆電上train RL算法，但目前是rtx 4050除非去租線上的gpu不然要想辦法優化訓練過程(例如不要開gui等)

## 預期延伸
1. 使用gazebo內建的機器人 -> 用solidwork化自己的機器人在匯入進去gazebo，用來熟悉.xarco跟.urdf檔案的運作


# Reference
[B站ros1影片](https://www.bilibili.com/video/BV1Ci4y1L7ZZ?spm_id_from=333.788.videopod.sections&vd_source=884c78e6ffadf9f643cedd800db793be&p=229)
[urdf build robot](https://www.bilibili.com/video/BV1PoZrBBEFC/?spm_id_from=333.788.player.switch&vd_source=884c78e6ffadf9f643cedd800db793be&p=27)
