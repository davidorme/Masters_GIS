---
jupytext:
  formats: md:myst
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.11.5
kernelspec:
  display_name: R
  language: R
  name: ir
---

# Introduction to the practicals

These practicals introduce a core set of GIS concepts and functions in R and then
explore some more common use cases.

All of these practicals are **self-paced**: you can work through them at your own speed
and call out when you need help.

## Three before 'me'

There will be a team of demonstrators to help you when you get stuck but please do
remember that helping yourself is actually a far better way to learn. We do *not* want
you to struggle but before you reach out to a demonstrator:

1. Ask *yourself* what you are trying to do: often stepping back and trying to write out
   an explanation for your problem helps you solve it.

1. Ask the *internet*: Sites like [stackoverflow.com](https://stackoverflow.com) are an
   invaluable resource and you can use *tags* on `stackoverflow` (e.g. `[R]` or `[sf]`)
   to narrow down your search.

1. Ask *each other*: it can be really helpful to get together in a short Team meeting
   and crowd source an answer.

If none of those work then ask us!

## Getting started

* Each practical has its own Posit Cloud assignment. This will contain all of the data
  needed for the practical and will have the required packages pre-installed.

* If you are working on your own computer, you will need to install those packages and
  the data required in the practical. There are quite a lot of required packages - they
  could take a little while to set up. See [here](required_packages.md) for details of
  the packages and data you will need.

* Once you have your project launched or a local working directory set up and are
  running in R then **create a new script file to record and run your code**.

* Work through the handouts at your own pace.

## GIS packages

There are loads of R packages that can load, manipulate and plot GIS data and we will be
using several in these practical. In the last few years, the R spatial data community
has been working on updating most of the core GIS functionality into a few core
packages, notably `sf` and `terra`. We will focus on using these up-to-date central
packages, but there will be some occasions where we need to use older packages, such as
`sp` and `raster`.

## Tasks

```{admonition} Introducing tasks
---
class: tip
---
A lot of these practicals will consist of following provided code to understand how it
works but occasionally there will be **tasks** to test the skills you have been
learning. These will start with a task bar like the one above and then have a
description like this one. There will then always be a button marked 'Click to show': if
you get really stuck, you can click on this to show a solution. Do try and figure it out
for yourself and if you don't understand something, ask a demonstrator to help.
```

```{toggle}
Hey! No peeking
```
