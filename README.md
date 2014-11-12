# NiPaNiPa [![Build Status][ci-badge]][ci-url]

This is the sample application for NiPaNiPa

[ci-badge]: https://travis-ci.org/deivid-rodriguez/nipanipa.png?branch=master
[ci-url]: https://travis-ci.org/deivid-rodriguez/nipanipa


## Setup Instructions

[Install ansible](http://docs.ansible.com/intro_installation.html) and then run
the default playbook to install its dependencies.

    sudo ansible-playbook -i hosts site.yml

You will need to use some flavour of Linux with the `apt-get` package manager
for this to work.


## Running the test suite

The default `rake` task includes a full test suite and static code analysis
with RuboCop. Just run and hope you broke nothing.

    bundle exec rake
