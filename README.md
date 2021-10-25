# Locum Best Practices
This gem makes your configuring deployment on [locum.ru](http://locum.ru/) faster!
> for Ruby on Rails applications

## Features

* Deployment
  - Capistrano integration
  - Configuration generator
  - Custom tasks
  - Predefined default [settings](lib/capistrano/locum/defaults.rb)
  - Pretty logs with [Airbrussh gem](https://github.com/mattbrictson/airbrussh)
  
* Environment
  - All secret variables in one file [application](lib/generators/locum/templates/deploy/config/application.yml.tt)
  - Variables with [Figaro gem](https://github.com/laserlemon/figaro)
  - Require keys
  
* Web server
  - Unicorn in requirements
  - Config predefined  
  
## Requirements

It is tested and works with:

* MRI >= 2.1
* Rails >= 4.2

Other versions are untested but might work fine.

## Installation

Add this line to your application's Gemfile into `development` group:

    gem 'locum-best-practices'

And then execute:

    $ bundle

## Usage

### Install `gem locum` in your system only. Not include it in your gemfile:

    gem install locum
  
### And execute:

    $ locum init
    
    > You need enter login and password from locum hosting account.

### Add deployment configuration:

    $ rails g locum:deploy

This creates the following files, you can edit them for your choice.

```
├── Capfile
└── config
    ├── initializers
    │   └── figaro.rb
    ├── deploy
    │   ├── production.rb
    │   └── testing.rb
    ├── environments
    │   └── testing.rb
    ├── deploy.rb
    ├── newrelic.yml
    ├── database.yml
    ├── secrets.yml
    └── application.yml
├── .editorconfig  
└── .rubocop.yml
```

## License

This project rocks and uses MIT License (MIT).

Copyright (c) 2016 DarkCreative Studio
