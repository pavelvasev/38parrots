# Visualization of developing reachable set for Dubins car with motion tracks

## Task
In addition to [previous task](2-tracks-for-reachable-set.md) with surface developing during time
and motions tracks of this process, we need to emphasize points on tracks of corresponding time instant T.
That is, when user selects time T of surface, a corresponding points on tracks should be visible.

## Solution

> [Available online](http://tinyurl.com/vefxfns)

We decided to get `data.csv` from previous task and add third artifact to it - a points corresponding to T.

We might just enhance the `treki` visualization type to do the emphasize some points, but for some reason 
we decided to just extract data from tracks file to separate files (each for separate T instant).

Thus in addition to tracks file, we have a lot of files for points in time, which you can see in
http://viewlang.ru/dubins/data/2-symm-1pi-4pi-treki5.cdb/ database.

Example content for points file, say `pts_0.15.points.csv`
```
   N       ,       T       ,       X       ,       Y       ,       Fi      ,       V
       1   ,        0.15   ,     10404.7   ,    2497.946   ,    14137.17   ,           1
       2   ,        0.15   ,     10404.7   ,    -2497.95   ,    -14137.2   ,           1
       3   ,        0.15   ,     10404.7   ,    2497.946   ,    14137.17   ,           1
       4   ,        0.15   ,     10404.7   ,    -2497.95   ,    -14137.2   ,           1
       5   ,        0.15   ,    3437.747   ,           0   ,           0   ,           1
```

So our cinema database now looks like this:
```
T       ,  FILE_vrml_mnoj,FILE_treki_1, FILE_treki_currentT
1,  Symm-20.vrml,Symm-20-80.Treki.csv,pts_1.0.points.csv
1.05,  Symm-21.vrml,Symm-20-80.Treki.csv,pts_1.05.points.csv
1.1,  Symm-22.vrml,Symm-20-80.Treki.csv,pts_1.1.points.csv
```

We use same type `treki` to show current points for instant T - for it's feature to select only required points by N column.

We achieved following visualizations:

![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-18-15-57.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-18-18-45.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-12/2020-03-12-at-11-37-42.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-12/2020-03-12-at-11-37-55.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-12/2020-03-12-at-11-54-17.png)

Also we achieved some animations like this [gif](http://showtime.lact.in/resizer_st/fit/420/420//files/visual/2020-03-12/2020-03-12-at-11-47-04.gif):

![](http://showtime.lact.in/resizer_st/fit/420/420//files/visual/2020-03-12/2020-03-12-at-11-47-04.gif)

The visualization journey on Dubins car continues.

---
The data and images provided on this page are (c) V. S. Patsko and A. A. Fedotov,
N.N. Krasovksii Institute of Mathematics and Mechanics of the Ural's branch of Russian Academy of Sciences,
http://sector3.imm.uran.ru/index_eng.html
If you desire to refer in scientfic paper, please cite:
> Patsko V.S., Fedotov A.A. Reachable set for Dubins car and its application to observation problem with incomplete information.
> // Preprints of the 27th Mediterranean Conference on Control and Automation (med19), Akko, Israel, July 1-4, 2019. P. 483–488.