# Virus protein visualization

Visualization of an amino acid property (such as hydrophobicity) on the surface of a protein is very important 
for studying and understanding the functionality of a protein. 
Therefore, the first step for this purpose is to extract the coordinates of the macromolecule atoms, 
calculate and construct the surface using the Vanderval radius, 
and calculate and visualize the properties of amino acid on the surface as a color.

The current stage is to construct the macromolecule surface using the coordinates obtained from the PDB file.
So we go on that way with a set of tasks, and following is the first one.

## Task
Given the coordinates of atoms, extracted from works [1,2], visualize those atoms as a set of points in 3d space.

## Solution
> [Available online](http://tinyurl.com/yx6btopu)

We transformed atom coordinates to 38parrots points format, 
as seen in cinema database is available at http://viewlang.ru/objs/data/38examples/5-proteins/protein-1.cdb/

Then we generetated simple cinema `data.csv` file:

```
spheres,FILE_points_protein,FILE_spheres_protein
off,atoms.csv,
on,,atoms.csv
```
Here we used one trick to achieve various visualization methods. We introduced parameter `spheres` with two values: `on` and `off`.
When spheres are off, atoms.csv are going to points visualization type. 
When spheres are on, atoms.csv are going to spheres visualization type.
Thus user may select visualization method using parameters interface.

We achieved following visualization:

![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-18-59-41.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-18-59-31.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-19-00-15.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-19-00-53.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-19-01-04.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-19-22-39.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-14/2020-03-14-at-23-22-38.png)
![](http://showtime.lact.in/resizer_st/fit/340/340//files/visual/2020-03-12/2020-03-12-at-14-13-10.png)

> The latter 2 pictures tells the story of spheres. We are unable visualize around 763298 atoms using hi-quality spheres,
> because it justs hangs browser (each sphere produces around 750 triangles). So 38parrots have to reduce spheres quality.
> For experimental reason for just see hi-res spheres, we reduced our set to only 5000 atoms. which generated 3.7 million
> of triangles for representing hi-res spheres.

We generated fine [virus gif file](http://showtime.lact.in/files/visual/2020-03-14/2020-03-14-at-19-06-21.gif) for 100mb for this protein.

Actually we even generated great youtube [video when camera goes inside virus protein](https://www.youtube.com/watch?v=_90lAxU-Imc),
but it was before 38parrots age.

To make things work, we developed 2 plugins for 38parrots:

* one for camera rotation around Y axis,
* and another for camera look at center point of visualized objects.

These plugins are avaliable now for all users.

In [next task](2-atomic-connections.md), Majid decided to visualize atoms and their connections.

References:

1. Xu, R., Ekiert, D.C., Krause, J.C., Hai, R., Crowe, J.E., Jr., Wilson, I.A..
Structural Basis of Preexisting Immunity to the 2009 H1N1 Pandemic Influenza Virus. United States: N. p., 2013. Web. DOI: [10.1126/science.1186430](https://doi.org/10.1126/science.1186430)
2. Crystal structure of a 2009 H1N1 influenza virus hemagglutinin. DOI: [10.2210/pdb3lzg/pdb](http://dx.doi.org/10.2210/pdb3lzg/pdb)

---
2020 (c) Majid Forghani, Pavel Vasev, http://www.cv.imm.uran.ru