# Running point

> [Run online](http://tinyurl.com/te3bsoh), then press button according to example's name.

In this example, we desire to visualize one point which position is determined by `ax` and `ay` parameters.

To solve this case, we generate separate csv files with point coordinates,
one file for each (`ax`,`ay`) combination.

Then we refer to that files from `data.csv` file, among with parameter values.

We use `FILE_points_... ` artefact column name to tell 38parrots to visualize data as points with csv-given coordinates.

More information on `points` artefact type is provided in [doc/3d_artefacts.md](../../../doc/3d_artefacts.md) file.