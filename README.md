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


## Deploying

This webapp is hosted in Heroku and uploads static assets to Amazon S3. It's using the [AWS SDK for Ruby](http://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/welcome.html) and [Heroku's Platform API gem](https://devcenter.heroku.com/articles/platform-api-reference).


### Requirements

You will need to [download and install the Heroku CLI](https://devcenter.heroku.com/articles/heroku-command-line) for your operating system. Log in to your Heroku account and follow the prompts to create a new SSH public key.

```bash
heroku login
```

Then make sure that you have the Heroku staging and production upstreams for this webapp in your local git repository (if not, run the `scripts/setup.sh` file):

```bash
git push staging master
```


### How to deploy

To staging:

```bash
bundle exec rake deploy:staging
```

To production:

```bash
bundle exec rake deploy:production
```

This will:
* Append a timestamp to `main.css` and `bundle.js` before uploading them to S3, to force browser recaching when the files change.
* upload the main styles file and the bundle JavaScript file to Amazon S3.
* deploy the site to Heroku-staging or Heroku-production

Please check `lib/config_constants.rb` for details on paths, bucket names, etc.


### Generating the right paths in the rendered views

The `href` attribute of the main styles link tag and the `src` attribute of the bundle script tag are calculated taking into account if you are in development, staging or production. The files are uploaded to different buckets so that deploying assets to staging doesn't break production.

* In DEVELOPMENT, they would point to `css/main.css` and `js/bundle.js`.

* In STAGING:
  - bucket in AWS S3: `assets-development.survivalinternational.org`,
  - css path: `donation-system-webapp/css/main-YYY-MM-DD.css`
  - js path: `donation-system-webapp/js/bundle-YYY-MM-DD.js`

* In PRODUCTION:
  - bucket in AWS S3, `assets-production.survivalinternational.org`,
  - css path: `donation-system-webapp/css/main-YYY-MM-DD.css`
  - js path: `donation-system-webapp/js/bundle-YYY-MM-DD.js`

* In order for this to work in Heroku, the timestamped filenames of the files uploaded to Amazon are passed to Heroku by storing them in environment variables in Heroku staging and Heroku production.

The `donation-system-webapp` path is public in both buckets.


## Contributing

Please check out our [Contributing guides](https://github.com/survival/contributing-guides) and our [Code of conduct](https://github.com/survival/contributing-guides/blob/master/code-of-conduct.md)


## License

[![License](https://img.shields.io/badge/mit-license-green.svg?style=flat)](https://opensource.org/licenses/mit)
MIT License
