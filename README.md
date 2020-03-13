# 38parrots

Web-based 3d visualization tool using CinemaScience format.

It allows you to easily explain to computer how to visualize your data in 3d, 
interactively control a scene and even generate animation.

![](doc/udav-iz-multfilma-38-popugaev.jpg)

# Run

[Open 38parrots in a web browser](http://tinyurl.com/qkec7no).

# Visualizations

![](http://showtime.lact.in/resizer_st/fit/160/160//files/visual/2020-03-12/2020-03-12-at-11-47-04.gif)
![](http://showtime.lact.in/resizer_st/fit/160/160//files/visual/2020-03-12/2020-03-12-at-14-13-10.png)
![](http://showtime.lact.in/resizer_st/fit/160/160//files/visual/2020-03-12/2020-03-12-at-14-24-20.png)
![](http://showtime.lact.in/resizer_st/fit/160/160//files/visual/2020-03-11/2020-03-11-at-14-25-15.png)
![](http://showtime.lact.in/resizer_st/fit/160/160//files/visual/2020-03-11/2020-03-11-at-10-35-30.png)
![](http://showtime.lact.in/resizer_st/fit/160/160//files/visual/2020-03-05/2020-03-05-at-14-16-05.png)
![](http://showtime.lact.in/resizer_st/fit/160/160//files/visual/2020-03-04/2020-03-04-at-13-43-27.png)
![](http://showtime.lact.in/resizer_st/fit/160/160//files/visual/2020-03-02/2020-03-02-at-20-28-43.png)
![](http://showtime.lact.in/resizer_st/fit/160/160//files/visual/2020-03-02/2020-03-02-at-22-47-20.png)
![](http://showtime.lact.in/resizer_st/fit/160/160//files/visual/2020-03-02/2020-03-02-at-20-29-14.png)

You may find real cases and tutorial examples in [examples](examples) dir.

# How does it work

A data for visualization should be expressed in specified format and then transferred to a web browser, where 38parrots interprets and visualizes it.

The format is textual and allows easily specify objects of 3d scene, parameters, and interconnection between them. User interface is generated automatically. During visualization, user
control parameter values and see changes in a scene.

# Example

38parrots is based on [CinemaScience format](https://cinemasciencewebsite.readthedocs.io/en/latest/) which is brilliantly simple and powerful at the same time.

38parrots adds 3d artifacts to CinemaScience, allowing to create various 3d scenes dependent from parameters.

In short, you describe scene in a special folder (e.g. cinema database). This folder should contain at least 1 fi
le named `data.csv` which describes a scene.

Let's look at example scene file ([examples/0-points-fly.cdb/data.csv](examples/0-points-fly.cdb/data.csv)):
```
T,FILE_points_my1
0,00.csv
1,01.csv
2,02.csv
```
Here we see one parameter named `T` and one 3d artifact named `FILE_points_my`.

In addition, let's our folder contains files NN.csv with content like this:
```
X, Y, Z
4.21, 9.72, 10.61
6.69, 9.43, 3.38
9.85, 3.66, 2.09
...
```

Given with this data on input, 38parrots will load it and give you following visualization with ability to control value of T:

![](http://showtime.lact.in/resizer_st/fit/320/320//files/visual/2020-03-13/2020-03-13-at-12-32-28.png)

* [See example's data](examples/0-point-fly.cdb)
* [Run this example live](http://tinyurl.com/qkec7no)

# Documentation
* [Guide](doc/guide.md)
* [Supported 3d artefacts](doc/3d_artefacts.md)
* [Examples](examples/)

# Документация по-русски
* [Руководство](doc/guide.ru.md)
* [Перечень 3d артефактов](doc/3d_artefacts.ru.md)

# Credits

2020 (c) Pavel Vasev

