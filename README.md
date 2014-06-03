<p align="center">
  <a href="https://github.com/mirego/hanzo">
    <img src="http://i.imgur.com/RZbJy1u.png" alt="Hanzo" />
  </a>
  <br />
  Hanzo is a sharp tool to handle deployments in multiple environments on Heroku.
  <br /><br />
  <a href="https://rubygems.org/gems/hanzo"><img src="https://badge.fury.io/rb/hanzo.png" /></a>
  <a href="https://codeclimate.com/github/mirego/hanzo"><img src="https://codeclimate.com/github/mirego/hanzo.png" /></a>
  <a href="https://travis-ci.org/mirego/hanzo"><img src="https://travis-ci.org/mirego/hanzo.png?branch=master" /></a>
</p>

---

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
> hanzo install

-----> Creating git remotes
       Adding qa
       Adding staging
       Adding production
```

### Deploy a branch or a tag

```bash
> hanzo deploy qa

-----> Branch to deploy: |HEAD|
```

### Install labs

Once all your environments are activated, you might want to enable some
Heroku labs feature for all your environments.

```bash
> bundle exec hanzo install labs

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

## License

`Hanzo` is © 2013 [Mirego](http://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the [`LICENSE.md`](https://github.com/mirego/hanzo/blob/master/LICENSE.md) file.

## About Mirego

[Mirego](http://mirego.com) is a team of passionate people who believe that work is a place where you can innovate and have fun. We're a team of [talented people](http://life.mirego.com) who imagine and build beautiful Web and mobile applications. We come together to share ideas and [change the world](http://mirego.org).

We also [love open-source software](http://open.mirego.com) and we try to give back to the community as much as we can.
