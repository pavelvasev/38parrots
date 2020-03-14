## Spheres

Purpose: render a set of spheres given in a csv file.

Solution.

A csv file should contain columns:
* X,Y,Z - coordinates of sphere's center points. Required.
* R,G,B - spheres colors, e.g. red green blue color components.  Float from 0 to 1 each.
* RADIUS - desired radius of sphere.

Example input:
```
X,Y,Z, R,G,B
0,0,0, 1,1,1
0,1,0  1,0,1
1,0,0  1,1,0
59.20,2.95,82.41,0.50,0.00,1.00
56.87,7.15,81.46,0.50,0.00,1.00
54.45,10.49,84.03,0.50,0.00,1.00
```

38parrots column name example: FILE_spheres_22
