# Mongoid::Toggleable

[![Build Status](http://img.shields.io/travis/crushlovely/mongoid_toggleable.svg?style=flat)](https://travis-ci.org/crushlovely/mongoid_toggleable)
[![Code Climate](http://img.shields.io/codeclimate/github/crushlovely/mongoid_toggleable.svg?style=flat)](https://codeclimate.com/github/crushlovely/mongoid_toggleable)
[![Code Coverage](http://img.shields.io/codeclimate/coverage/github/crushlovely/mongoid_toggleable.svg?style=flat)](https://codeclimate.com/github/crushlovely/mongoid_toggleable)

TBD.

## Installation

`gem install mongoid_toggleable`

or in your `Gemfile`

``` ruby
gem 'mongoid_toggleable'
```

## Usage

Make sure you require the library.

``` ruby
require 'mongoid_toggleable'
```

This gem follows a similar API to many Mongoid plugins:

``` ruby
class Widget
  include Mongoid::Document
  include Mongoid::Toggleable

  toggleable :visible
  # toggleable :visible, :default => false
end
```

This sets up a boolean field on the model, and also makes the following class and instance methods available:

``` ruby
widget = Widget.new
widget.visible
# => true

# toggle the widget's visibility, but don't persist the change
widget.toggle(:visible)
widget.visible
# => false

# toggle the widget's visibility and persist the change
widget.toggle!(:visible)

widget1 = Widget.create
widget2 = Widget.create(:visible => false)

Widget.find_toggleable(:visible, true)
# => [widget1]

Widget.find_toggleable(:visible, false)
# => [widget2]
```

You can chain `find_toggleable` with other scopes too:

``` ruby
Widget.find_toggleable(:visible, true).where(:created_at.lte => 10.days.ago)
```

## Contributing to mongoid_toggleable

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so we don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so we can cherry-pick around it.

## Copyright

Copyright (c) 2014 PJ Kelly (Crush & Lovely). See LICENSE for further details.
