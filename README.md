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




