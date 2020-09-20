# Guide

## Prepare your data

1. First, please read [specification D](https://github.com/cinemascience/cinema/blob/master/specs/dietrich/01/cinema_specD_v012.pdf) of CinemaScience format.

2. To visualize 3d data, provide following column names for artifact: FILE_**type**_anystring. 

The second word after FILE_ and before second underscore _ means the visualization type of an artifact.

* For example: `FILE_points_my1` means "csv points", FILE_obj_surf means "obj file", so on.
* You may specify more than one 3d artifact in each line of a data.csv file.
* A list of supported types is available in the [3d artefacts](3d_artefacts.md) document.
* Also you might refer to [examples](../examples) for inspiration.

## Run 38parrots and feed it with data

1. [Run 38parrots](http://viewlang.ru/viewlang/code/scene.html?s=https://github.com/pavelvasev/38parrots/blob/master/result.vl) application in a web browser.

2. In top left corner, press button to choose files from local disk or from url.

* If loading from local disk, all cinema-related files (e.g. data.csv and artefact files) should be located at one directory level so you may choose them in browser dialog box.
* If loading from url, you should provide full url to `data.csv` file.

## Note about running a web server
The easiest option of giving data to 38parrots is to use `choose files` dialog.
However in some cases it is more suitable to make a data available via web server, local or remote.

To start web server you have a lot of options, for example using nodejs:
```
npm install -g http-server
http-server --cors
```
The `cors` option is needed because data is loaded via ajax, and currently 38parrots code loads from `viewlang.ru` domain,
which is in any way different than other domains with data. In case you need to load 38parrots code fully locally, you have to serve local copy of [viewlang](https://github.com/pavelvasev/viewlang) 3d framework.

One interesting option is to use `Web Server for Chrome` extension, which activates local web server from Chrome browser.
Even in that case, don't forget to activate `set CORS headers` in advanced options.
