---
created: 2025-08-03T14:22
updated: 2025-10-20T19:53
title:
---
2025-09-02 21:31

Status:

Tags:

# Readme
**這是交大資工系 吳凱強教授 演算法概論的課堂筆記與題目筆記。**
前兩週會先複習資節內容，若是有stl 容器實現就先不仔細探究實現原理(array, stack, queue等)，就只著重在如何使用跟複雜度
## 關於筆記建議
* 可以結合台大競程社網站參考資料與教授筆記結合
* 台大競程社網站參考資料有很多對競程很重要的常識，做完課內筆記可以多看看其他種

## 關於作業建議
* 作業須切換到windows11 os 才能跑網頁！！！除非是用學校網路
* 不要太過比較！！！，自己的進步最重要
* 每題解題思路都要寫筆記
* 簡單題一定要完成，中等題至少要寫一題
* 等解答出來後一定要搞懂思路跟用到的技巧後記下來並自己做一次，不懂的助教時間一定要去詢問
* [Homework OJ website(當期的)](https://114algo.cs.nycu.edu.tw/)
* [Homework OJ website(已過期限的)](https://114algo.cs.nycu.edu.tw/archive/)
* 助教作業詳解:https://www.notion.so/Lab-Solution-Introduction-to-Algorithm-2778f0b8782c800da165e3bdb0590310
## 基本先備知識(大幅提昇編輯速度)
*  萬用標頭檔
	* 在c++中往往要引入很多標頭檔才能使用函數，像是要``<iostream>``才能做輸入輸出，要``<sort>``才能用sort等等
	* ``#include <bits/stdc++.h>`` 幾乎把所以可能會用到的標頭檔都包括進去，不用一個個include 進去但編譯速度會變慢
* 輸入優化
	* c++因為要配合跟兼容c的輸入和輸出因此會使輸入變得很慢
	* 在main function裡加上`ios::sync_with_stdio(false), cin.tie(nullptr);` 來關掉共用，只允許cin 跟 cout
* endl
	* 用`\n`來取代`endl`


# Reference
[台大競程社網站](https://ntucpc.org/)
[別人的筆記](https://hackmd.io/@LukeTseng)
[WiwiHo 的競程筆記](https://cp.wiwiho.me/)
[[Yui Huang 演算法學習筆記](https://yuihuang.com/)](https://yuihuang.com/e-portfolio/)