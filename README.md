# NiPaNiPa [![Build Status][ci-badge]][ci-url]

This is the sample application for NiPaNiPa

[ci-badge]: https://travis-ci.org/deivid-rodriguez/nipanipa.png?branch=master
[ci-url]: https://travis-ci.org/deivid-rodriguez/nipanipa

## System Requirements

* _Ruby_ MRI 2.3.
* _Postgresql_ 9.5. `sudo aptitude install postgresql-9.5 libpq-dev`
* A _Javascript_ runtime. `sudo aptitude install nodejs`.
* _Imagemagick_. `sudo aptitude install imagemagick`.

## System setup

Run

```shell
bin/setup
```

## Running the test suite

The default `rake` task includes a full test suite and static code analysis
with RuboCop and other linters. Just run

```
bin/rake
```
