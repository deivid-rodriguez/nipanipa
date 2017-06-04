# NiPaNiPa [![Build Status][ci-badge]][ci-url]

This is the sample application for NiPaNiPa

[ci-badge]: https://circleci.com/gh/deivid-rodriguez/nipanipa.svg?style=svg
[ci-url]: https://circleci.com/gh/deivid-rodriguez/nipanipa

## System Requirements

* _Ruby_ MRI 2.4.
* _Postgresql_ 9.5. `sudo apt install postgresql-9.5 libpq-dev`
* A _Javascript_ runtime. `sudo apt install nodejs`.
* _Imagemagick_. `sudo apt install imagemagick`.
* _Chrome_ 58.0 or higher, and _chromedriver_ 0.29 or higher.

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

## Translations

You can help translating NipaNipa to your language at
[localeapp](https://www.localeapp.com/projects/7834)
