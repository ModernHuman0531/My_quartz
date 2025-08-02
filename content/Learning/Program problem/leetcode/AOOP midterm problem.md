2024-11-15 12:53

Status:

Tags:[[python]], [[Built-in function]]

# AOOP midterm problem
## [3304. Find the K-th Character in String Game I](https://leetcode.com/problems/find-the-k-th-character-in-string-game-i/)
* Step:
	* Input is integer number, and the output is the input number's position in the word's string.
	* Keep adding the word until the length of the word bigger than input integer.
	* Noted: 
		* `ord('alphabet')`: turn the alphabet  into `ASICC code`
		* `chr(ASICC code)`:turn the `ASICC code` into alphabet.
```python
class Solution(object):

def kthCharacter(self, k):
	word = ['a']
	while len(word) <= k:
		extra = []
		for s in word:
			extra.append(chr((ord(s)-ord('a')+1)%26+ord('a')))
		word.extend(extra)
	return word[k-1]
```

## 394.[Decode String](https://leetcode.com/problems/decode-string/)
* Step:
	* Input is string and output is string.
	* The structure is basic like:`54[a3[bc]]`, we should repeat string with k times.
	* We can store the input string into a **stack** respectively until we meet ']', meaning we should begin to pop out the word we need to repeat til we encounter '[ `.
	* After take out the `[ ` , check the string before it, if is number, then it is the time we need to repeat, if  not then, don't move it, just back to s to keep put element in stack.
	* Important function:`isdigit()` and `join()`.
	* ![[檔案_000.png]]
```python
class Solution(object):
    def decodeString(self, s):
        """
        :type s: str
        :rtype: str
        """
        stack = []
        for i in range(len(s)):
            if s[i] != ']':
                stack.append(s[i])
            else:
                substr = ''
                #Form the repeated words
                while stack[-1] != '[':
                    substr = stack.pop() + substr
                #Pop out the '['
                stack.pop()
                # Form the repeat times
                # The thing stack pop out must be num
                times = ''
                while stack and stack[-1].isdigit():
                    times = stack.pop() + times
                stack.append(int(times)*substr)
        return ''.join(stack)
```
## [56. Merge Intervals](https://leetcode.com/problems/merge-intervals/)
* Step:
	* First sort the intervals array by  non-descending.
	* Create an answer array and put the first element of intervals in it.
	* Compare the the the end of the last element in answer to the current start element in intervals array, if last element bigger or equal than start element, then merge to sets, if not just put the whole thing in answer array.

```python
class Solution(object):
	def merge(self, intervals):
		intervals.sort()
		answer = []
		answer.append(intervals[0])
		for start, end in intervals[1:]:
			if answer[-1][1] >= start:
				answeer[-1][1] = max(answer[-1][1], end)
			else:
			answer.append([start, end])
		return answer

```
## [720. Longest Word in Dictionary](https://leetcode.com/problems/longest-word-in-dictionary/)
* Step:
	* First sort the words list, it'll sorted by alphabet and the length, this will help us check the weather the previous word exist or not.
	* We can check the word except for it's last alphabet is exist in the set we create, if exist, we can also add that word into the that set, and we compare this word's length to the longest_word, if longer than it, then replace the longest word by word. 
```python
class Solution(object):
	def longestWord(self, words):
	words.sort()
	answer = set([""])
	longest_word = ""
	for word in words:
		if word[:-1] in answer:
			answer.add(word)
			if len(word) > len(longest_word):
				longest_word = word
	return longest_word
```
## 338.Counting bit
* Offset is the power of the 2.
* The original offset is 1, if the offset * 2 == i, then offset is updated to i

| Number in Decimal | Number in binary | Another expression           |
| ----------------- | ---------------- | ---------------------------- |
| 0(`dp[0]`)        | 0000             |                              |
| 1(`dp[1])`        | 0001             | `1+dp[1-offset]`, offset = 1 |
| 2(`dp[2]`)        | 0010             | `1+dp[2-offset]`,offset = 2  |
| 3(`dp[3])`        | 0011             | `1+dp[3-offset]`,offset = 2  |
| 4(`dp[4]`)        | 0100             | `1+dp[4-offset]`,offset = 4  |
| 5(`dp[5]`)        | 0101             | `1+dp[5-offfset]`,offset = 4 |
| 6(`dp[6]`)        | 0110             | `1+dp[6-offset]`, offset = 4 |
| 7(`dp[7]`)        | 0111             | `1+dp[7-offset]`, offset = 4 |
```python
class Solution(object):
	def countbits(self, n):
		dp = [0] * (n+1)#[0] have n+1's
		offset = 1
		for i in range(1, n+1):
			if i == offset * 2:
				offset = i
			dp[i] = 1 + dp[i - offset]
		return dp 
```
## (410.Split Array Largest Sum)[[https://leetcode.com/problems/split-array-largest-sum/description/]]
* Step:
	* Create a helper function that help us count the number of the sub-array that smaller than d.
	* In the helper function, we use `cnt` and `s` to keep track of the array smaller than d, and  sum of the sub-array.
	* If number+s>d. create a new array and s = number, else s = s + number, return `cnt` <= k
	* The binary search is left closed right closed, left = max(num), right = sum(num), if helper(mid) is True, then right = mid - 1, else left = mid+1.Return left.
```python
def spiltArray(self, nums, k):
	def helper(d):
		cnt, s = 1, 0
		for num in nums:
			if num + s > d:
				cnt += 1
				s = num
			else:
				s += num
		return cnt <= k
	left, right = max(nums), sum(nums)
	while left <= right:
		mid = (left+right)//2
		if helper(mid):
			right = mid - 1
		else:
			left = mid + 1
	return left

```

## 132.Palindrome Partitioning 2
```python
class Solution:
    def minCut(self, s: str) -> int:
        n = len(s)
        is_pal = [[True] * n for _ in range(n)]

        for i in range(n - 1, -1, -1):
            for j in range(i + 1, n):
                is_pal[i][j] = (s[i] == s[j]) and is_pal[i + 1][j - 1]

        dp = [n] * n
        for i in range(n):
            if is_pal[0][i]:
                dp[i] = 0
                continue
            for j in range(i):
                if is_pal[j + 1][i]:
                    dp[i] = min(dp[i], dp[j] + 1)

        return dp[n - 1]
```
## 113. Path sum
```python
# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution(object):
    def pathSum(self, root, targetSum):
        """
        :type root: Optional[TreeNode]
        :type targetSum: int
        :rtype: List[List[int]]
        """
        self.ans = []
        self.helper(root, [],targetSum)
        return self.ans
    def helper(self, root, path, targetSum):
        if root is None:
            return
        # Handle the leaf. 
        elif root.right is None and root.left is None:
            # Plus the current val will make the sum = targetsum, then add it and append to answer.
            if(sum(path) + root.val == targetSum):
                self.ans.append(path+[root.val])
            return
            
        else:
            # Don't change the root right here, instead of change value in the parameter we passed in.
            # Instead of path += [root.val] ,do this below
            self.helper(root.left, path+[root.val], targetSum) 
            self.helper(root.right, path+[root.val], targetSum)
```
## 327.Count of range sum
```python
class Solution:
    # Merge sort the array
    # Along the way, record the occurances
    def countWhileMergeSort(self, left, right):
        # Single element edge case
        if left == right:
            return 0
        # Divide and conquer step
        # Note: left and right are inclusive
        mid = (left + right)//2
        count = self.countWhileMergeSort(left, mid) + self.countWhileMergeSort(mid+1,right)
        #print(left, mid, right, count)
        # Merge step
        # j is the index to find where in the right sorted subarray that satisfies the reverse pair conditions
        # t is the index for conducting merge sort
        # t begins at mid+1 because [left,right] are both inclusive
        # in this problem, j should start from the end as the nums are sorted, 
        j = t = mid + 1
        # temp array to carry out merge sort
        cache = [0]*(right-left+1)
        p = 0  # p is pointer to current cache item
        for i in range(left, mid + 1):
            # j is the first index satisfy nums[i] > 2*nums[j]
            while j <= right and 2*self.nums[j] < self.nums[i]:
                j += 1
            #print("i = ", i, "j = ", j)
            # t is for copying to temp array for merge sort
            # In this step, are the sums[t] smaller than sums[i] are put into the temp array before sums[i]
            while t <= right and self.nums[t] < self.nums[i] :
                cache[p] = self.nums[t]
                p += 1
                t += 1
            cache[p] = self.nums[i]
            p += 1
            count += j - (mid+1)
        self.nums[left:t]=cache[:p]
        #print(self.nums, left, right, count)
        return count
    
    def reversePairs(self, nums: List[int]) -> int:
        self.nums = nums
        return self.countWhileMergeSort(0, len(nums)-1)
```
# Reference