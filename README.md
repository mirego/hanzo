# Hanzo

[![Gem Version](https://badge.fury.io/rb/hanzo.png)](https://rubygems.org/gems/hanzo)
[![Code Climate](https://codeclimate.com/github/mirego/hanzo.png)](https://codeclimate.com/github/mirego/hanzo)

Hanzo is a Ruby library that allows a team to easily share environment endpoints for Heroku apps.

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'hanzo'
```

## Usage

Create an `.heroku-remotes` file at the root of your app.

```yaml
qa: heroku-app-name-qa
staging: heroku-app-name-staging
production: heroku-app-name-production
```

### Install remotes

```bash
> bundle exec hanzo install

-----> Creating git remotes
       Adding qa
       Adding staging
       Adding production
```

### Install labs

Once all your environments are activated, you might want to enable some
Heroku labs feature for all your environments.

```bash
> be hanzo install labs

-----> Activating Heroku Labs
       Add preboot? yes
       - Enabled for qa
       - Enabled for staging
       - Enabled for production
       Add user-env-compile? yes
       - Enabled for qa
       - Enabled for staging
       - Enabled for production
```

### Deploy a branch or a tag

```bash
> bundle exec hanzo deploy qa

-----> Branch to deploy: |HEAD|
```

## License

`Hanzo` is © 2013 [Mirego](http://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the [`LICENSE.md`](https://github.com/mirego/hanzo/blob/master/LICENSE.md) file.

## About Mirego

Mirego is a team of passionate people who believe that work is a place where you can innovate and have fun. We proudly build mobile applications for [iPhone](http://mirego.com/en/iphone-app-development/ "iPhone application development"), [iPad](http://mirego.com/en/ipad-app-development/ "iPad application development"), [Android](http://mirego.com/en/android-app-development/ "Android application development"), [Blackberry](http://mirego.com/en/blackberry-app-development/ "Blackberry application development"), [Windows Phone](http://mirego.com/en/windows-phone-app-development/ "Windows Phone application development") and [Windows 8](http://mirego.com/en/windows-8-app-development/ "Windows 8 application development") in beautiful Quebec City.

We also love [open-source software](http://open.mirego.com/) and we try to extract as much code as possible from our projects to give back to the community.
