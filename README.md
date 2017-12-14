[![Build Status](https://travis-ci.org/survival/donation-system-webapp.svg?branch=master)](https://travis-ci.org/survival/donation-system-webapp)
[![Coverage Status](https://coveralls.io/repos/github/survival/donation-system-webapp/badge.svg?branch=master)](https://coveralls.io/github/survival/donation-system-webapp?branch=master)
[![Dependency Status](https://gemnasium.com/badges/github.com/survival/donation-system-webapp.svg)](https://gemnasium.com/github.com/survival/donation-system-webapp)
[![Maintainability](https://api.codeclimate.com/v1/badges/16a063ba68872839c5db/maintainability)](https://codeclimate.com/github/survival/donation-system-webapp/maintainability)


# Readme

The web app for Survival's donation system.


## How to use this project


This project uses the [donation system gem](https://github.com/survival/donation-system). It is recommended to read the instructions in the gem's readme, in particular regarding the credentials needed to run the app.

The production credentials are stored in the server where this webapp is hosted. Both staging and production environments in that server **should have exact copies of the production credentials**. Everything else should also be the same. Production will usually deploy the master branch, while branches in PRs can be deployed to staging to test everything is working before merging the branch into master.


### To initialise the project

Run the one-off setup script (**Beware:** Needs permissions to access the credentials repo):

```
. scripts/setup.sh
```

This script will:
* download [the last jasmine release](https://github.com/jasmine/jasmine/releases) for the JS tests in a `temp` directory
* unzip it and copy the `lib` folder inside of the `public/js/` folder
* delete the `temp` directory
* download the credentials
* run `npm install` to install the node packages
* run `bundle install` to install gems.
* run `bundle exec rake` to run the tests.

The Jasmine setup script can also be used to update to a newer version of the library.


### To run the app locally

```bash
bundle exec rackup
```

Then visit `localhost:9292` in your browser.


### To run all ruby tests, and rubocop

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

The frontend test command will also run the backend tests, to make sure we don't break anything in the backend when working on the frontend. Please keep an eye on the terminal while developing!

We aim to keep the styles and JavaScript below 20k, since there is already some overhead of JavaScript payment libraries to download, plus custom fonts and images. Also, we try to keep accessibility in mind, and think about number of requests and file weight.

You can check the size of the bundles from time to time, typing:

```bash
ls -alh public/css/main.css public/js/bundle.js
-rwxrwxrwx 1 ubuntu ubuntu 9.8K Dec 15 15:39 public/css/main.css
-rwxrwxrwx 1 ubuntu ubuntu 2.1K Dec 15 15:39 public/js/bundle.js
```


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

The styles are responsive and follow the **mobile-first approach**. They are compiled and compressed using Sass. The custom fonts and images are served from Amazon S2.


## Contributing

Please check out our [contribution guides](https://github.com/survival/contributing-guides) and our [code of conduct](https://github.com/survival/contributing-guides/blob/master/code-of-conduct.md)


## License

[![License](https://img.shields.io/badge/mit-license-green.svg?style=flat)](https://opensource.org/licenses/mit)
MIT License
