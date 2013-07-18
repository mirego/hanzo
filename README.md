# Hanzo

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

### Deploy a branch or a tag

```bash
> bundle exec hanzo deploy qa

-----> Branch to deploy: |HEAD|
```

## License

`Hanzo` is © 2013 [Mirego](http://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the [`LICENSE.md`](https://github.com/mirego/hanzo/blob/master/LICENSE.md) file.

## About Mirego

Mirego is a team of passionate people who believe that work is a place where you can innovate and have fun.
We proudly built mobile applications for
[iPhone](http://mirego.com/en/iphone-app-development/ "iPhone application development"),
[iPad](http://mirego.com/en/ipad-app-development/ "iPad application development"),
[Android](http://mirego.com/en/android-app-development/ "Android application development"),
[Blackberry](http://mirego.com/en/blackberry-app-development/ "Blackberry application development"),
[Windows Phone](http://mirego.com/en/windows-phone-app-development/ "Windows Phone application development") and
[Windows 8](http://mirego.com/en/windows-8-app-development/ "Windows 8 application development").
