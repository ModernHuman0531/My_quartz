---
created: 2025-08-03T14:22
updated: 2025-12-09T20:09
title:
---
2025-12-06 11:41

Status:

Tags:
目錄:
# Final project

## Model type
我是負責設計機器學習模型的組員，要選定三個基本模型跟一個進階模型，我選的三個基本是logistic regression, random forest, KNN(K-Nearest Neighbors)

優化參數方法：之前遇到的都是用gradient descent，是找到loss function的最小值來優化模型內部的參數，但這些選定的模型都要找超參數的最佳值，不能直接以梯度下降找到超參數的最佳值，因為大部分模型的超參數通常是離散或不連續。
結論是：梯度下降是用來訓練線性模型和神經網路的演算法。

要找到像 `max_depth` 這樣的超參數的最佳組合，我們需要的是一種**搜索策略**（如 Grid Search、Randomized Search）或像 **Optuna** 這樣的**貝氏優化 (Bayesian Optimization)** 方法，這些方法通過迭代試驗和評估來探索離散或非連續的超參數空間。

檔案結構
```
ufo_kaggle_project/
├── src/
│   ├── models/
│   │   ├── model_lr.py          # 包含 build_lr_pipeline 函數
│   │   ├── model_rf.py          # 包含 build_rf_pipeline 函數
│   │   └── model_knn.py         # 包含 build_knn_pipeline 函數
│   ├── tuning_logic.py          # **您的 Optuna 目標函數將放在這裡**
│   └── data_processor.py
└── notebooks/
    └── 02_Tuning_Evaluation.ipynb
```
### Catboost Model


# Reference
[Catboost  turtorial](https://catboost.ai/docs/en/)
[OPTUNA 尋找模型表現最好的超參數](https://ithelp.ithome.com.tw/articles/10354688)
[random forset](https://ithelp.ithome.com.tw/articles/10303882)
[pipline 用法](https://edge.aif.tw/express-scikit-learn-pipeline/)

