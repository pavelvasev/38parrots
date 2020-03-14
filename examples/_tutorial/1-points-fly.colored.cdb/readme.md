# Flying points colored

> [Run online](http://tinyurl.com/wvxmje8)

In addition to point coordinates from previous example, we will add colors to that points.

Thus we generate points files NN.csv with following content:
```
X, Y, Z, R, G, B
4.33, 9.25, 6.45, 0.37, 0.92, 0.20
2.98, 3.93, 7.29, 0.61, 0.81, 0.54
2.20, 3.61, 1.80, 0.33, 0.51, 0.89
...
```
The [doc/3d_artefacts.md](../../../doc/3d_artefacts.md) document clarify meaning of columns.

The `data.csv` file remains unchanged. We achieve following visualization:

![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-22-34-39.png[0])

The points looks prettier with colors. But we decide to add more special effects, and change points rendering
using graphical interface of 38parrots:
* sprites are rendered in additive mode,
* without depth test,
* and another sprite.

Now we achieve following image:

![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-22-35-31.png[0])

We generate animation for whole cinema database using 38parrots animation feature:

![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-22-40-28.gif)



