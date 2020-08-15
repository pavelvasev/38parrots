## Treki

Purpose: render a set of points, given in a csv file.
The difference from points is an ability to choose 
a subset of points to show.

A csv file should contain columns:
* N - subset id. Required.
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

User will be able to choose N and thus subset of points to show will be identified.

38parrots column name example: FILE_treki_v6
