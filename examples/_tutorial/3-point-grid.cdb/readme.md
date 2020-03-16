> [Run online](http://tinyurl.com/te3bsoh), then press button according to example's name.

In this example, we desire to visualize a grid of points in range (1..`ax`, 1..`ay`).
Also we desire to control visual points radius by `r` parameter.

To solve this case, we generate separate csv files, one file for each (`ax`,`ay`,`r`) combination.
Each file contains appropriate number of points coordinates and radius value to form the grid.

Then we refer to that files from `data.csv` file, among with parameter values.


