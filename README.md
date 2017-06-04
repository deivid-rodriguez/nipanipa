# NiPaNiPa [![Build Status][ci-badge]][ci-url]

This is the sample application for NiPaNiPa

[ci-badge]: https://circleci.com/gh/deivid-rodriguez/nipanipa.svg?style=svg
[ci-url]: https://circleci.com/gh/deivid-rodriguez/nipanipa

## System Requirements

* Ruby MRI 2.4. See [here](https://github.com/postmodern/ruby-install), for
  example.
* Postgresql. `sudo apt install postgresql libpq-dev`
* Nodejs. `sudo apt install nodejs`.
* Imagemagick. `sudo apt install imagemagick`.
* Chrome 58.0 or higher, and chromedriver 0.29 or higher.

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
