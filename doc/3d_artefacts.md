# 3d artefacts

Artefact type should be specified in CinemaScience column names as a second word after FILE_ prefix.
For example: FILE_points_33, FILE_vrml_surf.

## Points

Purpose: render a set of points given in a csv file.

Solution.

A csv file should contain columns:
* X,Y,Z - coordinates of points. Required.
* R,G,B - red green blue color components. Float number from 0 to 1 each.
* RADIUS - desired radius of points's representation.

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

38parrots column name example: FILE_points_mypts

## Obj

Purpose: render a surfaces from obj file.

Solution.

Obj is loaded, simply parsed, all vertices and triangles are joined into one mesh.
Normals from obj are droppend, and new ones computed.
Obj is visualized same as 2 visual objects - triangles mesh and points.

38parrots artefact column name example: FILE_obj_mysurf2


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

## VRML

Purpose: render a surfaces from vrml file.

Solution.

Vrml is loaded, parsed, all it's shapes are joined, and visualized:
* using one mesh of triangles.
* in addition, points are rendered too.

38parrots artefact column name example: FILE_vrml_mysurf


## Lines

Purpose: render a set of line segments given in a csv file.

Solution.

A csv file should contain columns:
* X,Y,Z,X2,Y2,Z2 - coordinates of start and end point for each line segment. Required.
* R,G,B,R2,G2,B2 - color components for start and end points, floating number in 0..1 range each.
  If provided, all 6 values should be specified.
* RADIUS - desired radius of a line's representation.

Example input:
```
X,Y,Z,X2,Y2,Z2,RADIUS,R,G,B,R2,G2,B2
10.0,0.0,0, 0,0,0, 1.0, 0.0,1.0,0,0.0,0,1.0
20.0,5.0,4, 0,3,0, 1.0, 0.0,1.0,0,0.0,0,1.0
```

## Treki

Purpose: render a set of tracks of points, given in a csv file.
The difference from points is an ability to choose track number.

Solution.

A csv file should contain columns:
* N - number of track. Required.
* X,Y,Z - coordinates of points. Required.

Example input:
```
N, X,Y,Z
1, 0,0,0
1, 0,2,2
1, 0,7,3
2, 1,1,1
2, 2,2,2
2, 3,3,3
```

38parrots column name example: FILE_treki_v6

