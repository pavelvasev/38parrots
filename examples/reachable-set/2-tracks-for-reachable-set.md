# Visualization of developing reachable set for Dubins car with motion tracks

## Task
In addition to [previous task](1-reachable-set.md) with surface developing during time, 
now we need to visualize a set of tracks. Each track is a motion on one point during time, 
and it is required to show both all points of all tracks and only some tracks specified by user.

## Solution

> [Avaliable online](http://tinyurl.com/u86tom7)

We have to get `data.csv` from previous task and add second artifact to it - a tracks data.
We decided to develop special type `treki` to show that tracks. We might use points, but
we need to select only some tracks to show. That what is `treki` type do - it analyzes
`N` column of tracks data and generates GUI to select only desired an.

Example of database for the task:
http://viewlang.ru/dubins/data/2-symm-1pi-4pi-treki.cdb/

Example excerpt from `data.csv`:
```
T       ,  FILE_vrml_mnoj,FILE_treki_1
1,  Symm-20.vrml,Symm-20-80.Treki.csv
1.05,  Symm-21.vrml,Symm-20-80.Treki.csv
1.1,  Symm-22.vrml,Symm-20-80.Treki.csv
1.15,  Symm-23.vrml,Symm-20-80.Treki.csv
1.2,  Symm-24.vrml,Symm-20-80.Treki.csv
```

In this database, the `FILE_treki_1` artifact value is same for all time instants,
so we see some duplication of data in `data.csv` file. It looks like reasonable
payment for flexibility of the CinemaScience format.

Example excerpt from tracks data, `Symm-20-80.Treki.csv`:
```
   N       ,       T       ,       X       ,       Y       ,       Fi      ,       V
       1   ,        0.05   ,    21511.28   ,    1692.975   ,    14137.17   ,           1
       1   ,         0.1   ,    21246.44   ,    3365.106   ,    14137.17   ,           1
       1   ,        0.15   ,    20809.39   ,    4995.893   ,    14137.17   ,           1
       2   ,        0.05   ,    21511.28   ,    -1692.97   ,    -14137.2   ,           1
       2   ,         0.1   ,    21246.44   ,    -3365.11   ,    -14137.2   ,           1
```

Visualizations we achieved:

![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-17-36-20.png[0])
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-17-36-28.png[0])
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-17-36-41.png[0])

During development and debug, we observed a lot of some fun pictures:

![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-02/2020-03-02-at-11-55-23.png[0])
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-02/2020-03-02-at-11-55-29.png[0])

![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-02/2020-03-02-at-11-54-45.png[0])
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-02/2020-03-02-at-11-55-45.png[0])
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-02/2020-03-02-at-18-26-58.png[0])
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-02/2020-03-02-at-20-23-11.png[0])
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-02/2020-03-02-at-20-25-35.png[0])

In [next task](3-tracks-for-reachable-set-and-point.md) we will emphasize points on tracks of corresponding time instant T.

---
V.S. Patsko, A.A. Fedotov, http://sector3.imm.uran.ru/index_eng.html
P.A. Vasev, http://www.cv.imm.uran.ru
