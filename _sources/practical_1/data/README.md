# Practical data directory

This folder contains all of the data files used across all of the practicals defined in
this repository. Each of the practicals has an individual `data` folder, but this is
just a symbolic link to this directory. This makes it easier to maintain and distribute
a single `data` archive file that supports all of the practicals, rather than having to
maintain and distribute data folders for each practical that will contain duplicated
files.

Things to note:

* **Some** of the data files are included in the repository - these are small text files
  that are not readily available or are created for the practicals.
* Most of the larger files are deliberately ignored. These are larger binary files that
  can be readily restored from online sources and should not be under version control.
  The `populate_data.R` script can be used to re-download these files if required.
