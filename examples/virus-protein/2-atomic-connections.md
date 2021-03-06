# Atoms with connections

Beside atoms itself, the connections between atoms are important information, giving an ability to understand higher level materias formed.
We have connections information and desire to visually examine it.

## Task
Visualize a set of atoms as points and connections between them as lines.

## Solution
> [Available online](http://tinyurl.com/u8vukmh)

We prepared CinemaScience [database](http://viewlang.ru/objs/data/38examples/5-proteins/protein-2-connections.cdb/) with the data to feed 38parrots.

It's `data.csv` is the following:
```
spheres,FILE_points_atoms,FILE_spheres_atoms,FILE_lines_connections
off,w_spheres.csv,,w_lines.csv
on,,w_spheres.csv,w_lines.csv
```

Thus we keep an ability to visualize atoms both as sprites and spheres, as in previous task. In addition we render lines, which represent
connection between atoms.

We achieved following visualizations:

![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-19-34-41.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-19-34-51.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-19-42-24.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-19-45-16.png)

Also we generated a [gif animation](http://showtime.lact.in/files/visual/2020-03-14/2020-03-14-at-19-40-12.gif) (28 mb).
In this animation, we clip atoms and connections using "Y-serie" plugin.
So we are able to see only subset of atoms and connections.

---
(c) 2020, Majid Forghani, Pavel Vasev, http://www.cv.imm.uran.ru
