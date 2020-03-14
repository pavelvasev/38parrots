# Flying points example

> [Run online](http://tinyurl.com/txeex32)

In this example we visualize a set of points, whose cooridinates change during time.

We put point coordinates in files NN.csv, whose content is following:
```
X, Y, Z
3.98, 9.00, 10.52
6.30, 9.02, 2.57
9.46, 3.33, 1.29
1.63, 7.95, 8.27
7.77, 10.29, 7.65
...
```

Then we create `data.csv` file (eg. cinema database) of following content.
```
T,FILE_points_my1
0,00.csv
1,01.csv
2,02.csv
3,03.csv
...
```

Thus we achieve following visualization:

![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-13/2020-03-13-at-12-32-28.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-22-29-47.png)

38parrots generate slider interface for parameter T, and user might change parameter value using that slider,
and see how points change their coordinates:

![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-22-44-22.png[0])
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-22-44-27.png[0])
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-22-44-29.png[0])
