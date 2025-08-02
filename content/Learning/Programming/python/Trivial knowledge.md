2025-04-20 16:12

Status:

Tags

# Untitled
## Open file
## Set 
## Heap

## Draw figure functions
* **plt.figure()** : Build the space for the figure, we can assign the size and dpi of the figure
```python
weight, height = 8, 6
plt.figure(figuresize(weight, height), dpi = 100)
```
* **plt.plot():** Draw the line chart
	* 'color' parameter can set color for that line
	* 'linewidth' parameter can set line's width 
```python
x_axis_info,y_axis_info=[1,2,3],[4,5,6]
plt.plot(x_axis_info, y_axis_info, label='Line 1', color='blue',linewidth=2)
```
* **plt.xlabel()/plt.ylabel()/plt.title():** Give the label for x and y axis, and give title to the chart
	* fontsize is the size of the char
```python
plt.xlabel('x-axis's name', fontsize=12)
plt.ylabel('y-axis's name', fontsize=12)
plt.title('Plot's name')
```
* **plt.legend():** Show the label of each line
```python
plt.legend()
```
* **plt.grid():** Show the grid line in the chart
```python
plt.grid(True)
```
* **plt.tight_layout():** Automatically adjust each subplot's distance
```python
plt.tight_layout()
```
* **plt.saveconfig():** Save th plot to the set name
```python
plt.saveconfig("my_plot")
```
* **plt.close():** Close the plot
```python
plt.close()
```
## Boolean mask
# Reference