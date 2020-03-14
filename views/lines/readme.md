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