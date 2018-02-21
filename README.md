<p align="center">
  <a href="https://github.com/mirego/hanzo">
    <img src="http://i.imgur.com/RZbJy1u.png" alt="Hanzo" />
  </a>
  <br />
  Hanzo is a sharp tool to handle deployments of multiple environments of the same application on Heroku.
  <br /><br />
  <a href="https://rubygems.org/gems/hanzo"><img src="http://img.shields.io/gem/v/hanzo.svg" /></a>
  <a href='https://gemnasium.com/mirego/hanzo'><img src="http://img.shields.io/gemnasium/mirego/hanzo.svg" /></a>
  <a href="https://travis-ci.org/mirego/hanzo"><img src="http://img.shields.io/travis/mirego/hanzo.svg" /></a>
</p>

---

## Installation

Add this line to your application’s `Gemfile`:

```ruby
gem 'hanzo'
```

## Usage

Create an `.hanzo.yml` file at the root of your app that will contain a map of
remotes, with the remote as the key and the Heroku application name as the value.

You can also specify commands that can be ran on the application after a
successful deploy. Hanzo will prompt to run each of them, they each will be ran
with `heroku run` and the application will be restarted at the end.

```yaml
remotes:
  qa: heroku-app-name-qa
  staging: heroku-app-name-staging
  production: heroku-app-name-production

after_deploy:
  - rake db:migrate

console: rails console
```

### `hanzo install`

#### Remotes

Whenever you add a new remote to your `.hanzo.yml` file, you'll have to install
those remotes locally by running `hanzo install remotes`.

```bash
$ hanzo install remotes
```

```
-----> Creating git remotes
       Adding qa
        git remote rm qa 2>&1 > /dev/null
        git remote add qa git@heroku.com:heroku-app-name-qa.git
       Adding staging
        git remote rm staging 2>&1 > /dev/null
        git remote add staging git@heroku.com:heroku-app-name-staging.git
       Adding production
        git remote rm production 2>&1 > /dev/null
        git remote add production git@heroku.com:heroku-app-name-production.git
```

#### Labs

Once all your remotes are installed, you might want to enable some Heroku labs
feature for all of them.

```bash
$ hanzo install labs
```

```
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

### `hanzo deploy`

You can deploy to a specific remote using `hanzo deploy <remote>` and an
optional reference to deploy. If no reference is specified, Hanzo will prompt
for one (with `HEAD` as the default value).

```bash
$ hanzo deploy qa release/qa
```

```
       git push -f qa release/qa:master

       …

remote: Verifying deploy... done.
To heroku.com:heroku-app-name-qa.git
   550c719..27e3538  release/qa -> master

       Run `rake db:migrate` on qa? y
       heroku run rake db:migrate --remote qa

Running rake db:migrate on heroku-app-name-qa...
15:45:26.380 [info] Already up
       heroku ps:restart --remote qa

Restarting dynos on heroku-app-name-qa...
```

### `hanzo diff`

You can use `hanzo diff <remote>` to compare the current repository state to the code
that is currently deployed in the specified remote.

Warning: This uses Heroku’s git repository references so its output might be
wrong if the application was rollbacked.

```
$ hanzo diff qa
       git remote update qa && git diff qa/master...HEAD
```

```diff
────────────────────────────────────────────────────────────────────────────────────────────
 -- a/lib/my_app/router.ex
 ++ b/lib/my_app/router.ex
────────────────────────────────────────────────────────────────────────────────────────────
@@ -30,6 +30,8 @@ defmodule MyApp.Router do
    plug(:fetch_flash)
+   plug(:protect_from_forgery)
+   plug(:put_secure_browser_headers)
```

### `hanzo config`

#### Compare

You can use `hanzo config compare` to find out which environment variables are
present in some environments but not all of them.

```
$ hanzo config compare
```

```
-----> Fetching environment variables
       heroku config -r qa
       heroku config -r staging
       heroku config -r production

-----> Comparing environment variables
       Missing variables in qa
       - ASSET_HOST
       Missing variables in staging
       - SMTP_PASSWORD
       - SMTP_PORT
       - SMTP_SERVER
       - SMTP_USER
       Missing variables in production
       - SMTP_PASSWORD
       - SMTP_PORT
       - SMTP_SERVER
       - SMTP_USER
```

### `hanzo console`

You can define a `console` command in `.hanzo.yml` to quickly spawn a console
process using `heroku run`.

```bash
$ hanzo console qa
```

```
Running iex -S mix on heroku-app-name-qa... up
> |
```

## License

`Hanzo` is © 2013-2018 [Mirego](http://www.mirego.com) and may be freely
distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the
[`LICENSE.md`](https://github.com/mirego/hanzo/blob/master/LICENSE.md) file.

## About Mirego

[Mirego](https://www.mirego.com) is a team of passionate people who believe that
work is a place where you can innovate and have fun. We're a team of [talented people](https://life.mirego.com)
who imagine and build beautiful Web and mobile applications. We come together to share ideas and [change the world](http://mirego.org).

We also [love open-source software](https://open.mirego.com) and we try to give back to the community as much as we can.
