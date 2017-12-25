[![Build Status](https://travis-ci.org/survival/donation-system-webapp.svg?branch=master)](https://travis-ci.org/survival/donation-system-webapp)
[![Coverage Status](https://coveralls.io/repos/github/survival/donation-system-webapp/badge.svg?branch=master)](https://coveralls.io/github/survival/donation-system-webapp?branch=master)
[![Dependency Status](https://gemnasium.com/badges/github.com/survival/donation-system-webapp.svg)](https://gemnasium.com/github.com/survival/donation-system-webapp)
[![Maintainability](https://api.codeclimate.com/v1/badges/16a063ba68872839c5db/maintainability)](https://codeclimate.com/github/survival/donation-system-webapp/maintainability)


# Readme

The web app for Survival's donation system.


## How to use this project


### To initialise the project

Run the one-off setup script (**Beware:** Needs permissions to access the credentials repo):

```
. ./scripts/setup.sh
```

This script will:
* download [the last jasmine release](https://github.com/jasmine/jasmine/releases) for the JS tests in a `temp` directory
* unzip it and copy the `lib` folder inside of the `public/js/` folder
* delete the `temp` directory
* download the credentials
* add the Heroku remotes to your local git repository
* run `npm install` to install the node packages
* run `bundle install` to install gems.
* run `bundle exec rake` to run the tests.

The Jasmine setup script can also be used to update to a newer version of the library.


### To run the app locally

```bash
bundle exec rackup
```

Then visit `localhost:9292` in your browser.


### To run all tests, and rubocop

```bash
. test.sh
```


### To run one test file


```bash
bundle exec rspec path/to/test/file.rb
```


### To run one single test

```bash
bundle exec rspec path/to/test/file.rb:TESTLINENUMBER
```


## Frontend


### To run the JavaScript tests

Run:

```
npm test
```

and then visit:
<http://localhost:9292/js/specrunner.html>


### To work on the syles

Run:

```
npm test
```

and then visit:
<http://localhost:9292>


## Contributing

Please check out our [contribution guides](https://github.com/survival/contributing-guides) and our [code of conduct](https://github.com/survival/contributing-guides/blob/master/code-of-conduct.md)


## License

[![License](https://img.shields.io/badge/mit-license-green.svg?style=flat)](https://opensource.org/licenses/mit)
MIT License
