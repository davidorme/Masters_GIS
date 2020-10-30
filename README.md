# READ ME

This brings together GIS teaching materials from a variety of weeks and incarnations into a single set of open source frameworks that are easy to manage in a git repository.

## Lectures

The lecture slides use the [`reveal-md`](https://github.com/webpro/reveal-md) framework: the slide contents are maintained in simple markdown files using a per-lecture image directory for media. The `reveal-md` framework allows these to be served as HTML slides.

In the `lectures` base directory, there are three shared files:

- `reveal.json`: This is used to set options to the `reveal-js` backend.
- `reveal-md.json`: This is used to set options to `reveal-md` itself. It isn't always obvious where the division lies!
- `lectures.css`: This file is used as a common set of styling changes for the lectures.

Both `json` configuration files are automatically loaded when `reveal-md` is run in the base directory, but the `css` file needs to be explicitly loaded. So, to view one of the lectures in a browser, you need to do the following:

```
cd lectures
reveal-md lecture_1/lecture_1.md --css lectures.css --watch
```

The `--watch` option makes `reveal-md` reload the presentation when the source file is changed, which is useful when writing the presentation. 

There is also an `index.md` file that contains a single slide with links to each lecture:

```
cd lectures
reveal-md index.md --css lectures.css
```

### R markdown

Some of the slides use R markdown to generate figures and examples. This adds a step to the process as the `.rmd` file needs to be run through `knitr` before it can be viewed in `reveal-md`. For example:

```
Rscript -e "knitr::knit('lecture_5.rmd')"
```

### Layout

Markdown is not about layout, so the framework uses HTML and CSS to position elements on the slide. These are setup as HTML tags within the Markdown text and are fairly minimal: vertical columns are created by wrapping columns in `<div class='container'>`. Each column inside that then uses a `<div class='col'>` to wrap the content of the column. There are a few options defined in `lectures.css` to set the relative widths of columns and set text alignment and  padding for text columns.

It is also possible to supply styles for individual slide elements using HTML comments to add CSS styling.

### Exporting lectures

The `reveal-md` framework makes it very simple to export HTML lectures as PDF files. 

```
reveal-md lecture_1/lecture_1.md --css lectures.css --print slides/lecture_1.pdf
```

You can also create a static HTML page:

```
reveal-md lecture_1/lecture_1.md --css lectures.css --static lecture_1/static
```

### Build script

The script  `lectures/build_slides.sh` automatically builds slides from all lectures in the lectures directory. Note that you can't be watching a lecture using `reveal-md` while doing this as the script currently tries to set the server going on the same port.


## Practicals

The practical files are built using JupyterBook. The files themselves are stored as Markdown files using the Myst Markdown extensions provided for JupyterBook. This makes it easy to save the notebooks in the more human readable Markdown format.

There are two stages to deploying the pages:

1. Build the site, generating the `practicals/_build` folder containing the `html` folder

```sh
jupyter-book build practicals/
```

2. Publish the html version of the pages to Github

```sh
ghp-import -n -p -f practicals/_build/html
```


