# Capistrano Local Precompile

The slowest part in a rails application is in the assets compiling. So let's throw it out! This gem adds a local build of assets and packs right on your machine and then uploads all the files to the server.

## Usage

Add local-precompile to your Gemfile:

```ruby
group :development do
  gem 'local_precompile', '~> 0.0.1', require: false
end
```

Then add the following line to your `Capfile`:

```ruby
require 'local_precompile/capistrano'
```

Remove the following line from your `Capfile`:

```ruby
require 'capistrano/rails/assets'
```

Here's the full set of configurable options:

```ruby
set :precompile_env             # default: fetch(:rails_env) || 'production'
set :assets_dir                 # default: "public/assets"
set :packs_dir                  # default: "public/packs"
set :rsync_cmd                  # default: "rsync -av --delete"
```

Capistrano supports **dry run** mode. In that case the `rsync` command will not actually be run but only shown in stdout:

```
cap production deploy --dry-run
```

## Acknowledgement

This gem is based on another gem with the same functionality but improved [capistrano-local-precompile][].

[capistrano-local-precompile]: https://github.com/stve/capistrano-local-precompile

In turn that gem is derived from gists by [uhlenbrock][] and [keighl][].

[uhlenbrock]: https://gist.github.com/uhlenbrock/1477596
[keighl]: https://gist.github.com/keighl/4338134

So many thanks to this guys.

## Contributing

Pull requests welcome: fork, make a topic branch, commit (squash when possible) *with tests* and I'll happily consider.

## Copyright

Copyright (c) 2021 Denis Arushanov
