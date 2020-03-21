# Visualization of developing reachable set for Dubins car

Reachable set for Dubins car is a mathematical object that represents area in 3d space (x,y,Fi),
where the Dubins car could reach at a given moment. It is both theoretically interesting
and practically useful for robotics, aeronautics, and many other areas.

[V. S. Patsko scientific group](http://sector3.imm.uran.ru/index_eng.html) in N.N. Krasovksii Institute of Mathematics and Mechanics of the Ural's branch of Russian Academy of Sciences perform research on mathematician areas which include Dubins car model for many years. 

The listed serie of tasks and core visualization techniques were provided by **V. S. Patsko and A. A. Fedotov**
and are dedicated to computations on Dubins car model. Task solution was performed by [Computer visualization lab at N.N. Krasovskii Institute](http://www.cv.imm.uran.ru).

## Task
There is a surface changing during time, given in vrml file 
format for each time instant. Visualize it.

Provide additional tools for better perception:
- surface clipping for all axes.
- series of clipping layers.
- series of coloring layers.
- scaling for all axes.

Moreover, provide "autoscale" command to automatically scale vrml data
to a given size - because various vrml sets computed at various scales.

## Solution
> The visualization described here is [avaliable online](http://tinyurl.com/wjoochu).

To solve the task, we generated cinema database: http://viewlang.ru/dubins/data/1-mnojestva.cdb/

Excerpt from a data.csv:
```
N,FILE_vrml_mnoj
0,Symm-100.vrml
1,Symm-101.vrml
2,Symm-102.vrml
3,Symm-103.vrml
4,Symm-104.vrml
5,Symm-105.vrml
6,Symm-106.vrml
7,Symm-107.vrml
...
```

With 38parrots we achieved following visualizations:

![](http://showtime.lact.in/resizer_st/fit/240/240//files/visual/2020-03-14/2020-03-14-at-16-50-12.png)
![](http://showtime.lact.in/resizer_st/fit/240/240//files/visual/2020-03-14/2020-03-14-at-16-50-16.png)
![](http://showtime.lact.in/resizer_st/fit/240/240//files/visual/2020-03-14/2020-03-14-at-16-50-26.png)
![](http://showtime.lact.in/resizer_st/fit/240/240//files/visual/2020-03-14/2020-03-14-at-16-50-34.png)
![](http://showtime.lact.in/resizer_st/fit/240/240//files/visual/2020-03-14/2020-03-14-at-16-53-20.png)
![](http://showtime.lact.in/resizer_st/fit/240/240//files/visual/2020-03-14/2020-03-14-at-16-53-56.png)

We implemented clipping and other tools as a "plugins", which might be activated by user (the Extras button). 
These tools are now added to core of 38parrots and are available for all users of all tasks. 

The result of applying of these tools is visible on following pictures.

![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-01/2020-03-01-at-19-59-06.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-01-04/2020-01-04-at-17-11-18.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-01-08/2020-01-08-at-12-40-45.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-01-08/2020-01-08-at-12-35-29.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-01-08/2020-01-08-at-00-39-54.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-01-08/2020-01-08-at-00-40-24.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-01-08/2020-01-08-at-12-41-01.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-01-08/2020-01-08-at-12-20-29.png)

Using animation feature, we generated video of development of a reachable set:
https://www.youtube.com/watch?v=A0CKbgIS8k4

We account our solution as successful. 
Then we moved towards [next task](2-tracks-for-reachable-set.md), where we have added visualization of motion tracks of points of interest.

---
The data and images provided on this page are (c) 2020 V. S. Patsko and A. A. Fedotov.
If you desire to refer in scientfic paper, please cite:
> Patsko V.S., Fedotov A.A. Reachable set for Dubins car and its application to observation problem with incomplete information 
> // Preprints of the 27th Mediterranean Conference on Control and Automation (med19), Akko, Israel, July 1-4, 2019. P. 483–488.
