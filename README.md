# NiPaNiPa [![Build Status][ci-badge]][ci-url]

This is the sample application for NiPaNiPa

[ci-badge]: https://circleci.com/gh/deivid-rodriguez/nipanipa.svg?style=svg
[ci-url]: https://circleci.com/gh/deivid-rodriguez/nipanipa

## System setup

### Install system dependencies

* Install ruby MRI 2.4

See [here](https://github.com/postmodern/ruby-install), for example.

* Install postgresql

```shell
sudo apt install postgresql libpq-dev
```

* Install nodejs

```shell
sudo apt install nodejs
```

* Install yarn

```shell
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn
```

* Install imagemagick

```shell
sudo apt install imagemagick
```

* Install chrome 59.0 or higher

```shell
sudo apt install google-chrome-stable
```

* Install chromedriver 0.30 or higher

See [here](https://sites.google.com/a/chromium.org/chromedriver/getting-started).

### Install application dependencies

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
