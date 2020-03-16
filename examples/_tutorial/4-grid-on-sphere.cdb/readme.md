> [Run online](http://tinyurl.com/te3bsoh), then press button according to example's name.

In this example, we desire to visualize a cubical 3d regular grid using points.

The grid for this example is the following - a cube and a spherical sparse space inside it.
In addition, we want to have `Z` parameter to see only part of the grid, limited by z value.

Of course, we just might use "Z-clip" tool available in 38parrots, but that might be not 
so interesting for this example purpose. 

The real purpose is:
* to show a data that look like computational, and 
* to stress-test a GPU to understand how much points it could render with WebGL, which 38parrots is based on.