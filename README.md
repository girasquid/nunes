# Nunes

The friendly gem that instruments everything for you, like I would if I could.

## Why "nunes"?

Because I don't work for you, but even that could not stop me from trying to make it as easy as possible for you to instrument ALL THE THINGS.

## Installation

Add this line to your application's Gemfile:

    gem 'nunes'

Or install it yourself as:

    $ gem install nunes

## Usage

nunes works out of the box with statsd and instrument_agent. All you need to do is subscribe using an instance of statsd or instrumental's agent and you are good to go.

### With Statsd

```ruby
require 'nunes'

statsd = Statsd.new(...)
Nunes.subscribe(statsd)
```

### With Instrumental

```ruby
require 'nunes'
I = Instrument::Agent.new(...)
Nunes.subscribe(I)
```

## What Can I Do For You?

If you are using nunes with rails, out of the box, I'll subscribe to Actve Support's notifications for:

* `process_action.action_controller`
* `render_template.action_view`
* `render_partial.action_view`
* `deliver.action_mailer`
* `receive.action_mailer`
* `sql.active_record`
* `cache_read.active_support`
* `cache_generate.active_support`
* `cache_fetch_hit.active_support`
* `cache_write.active_support`
* `cache_delete.active_support`
* `cache_exist?.active_support`

Whoa! You would do all that for me? Yep, I would. Because I care. Deeply.

Based on those events, you'll get metrics like this in statsd and instrumental:

#### Counters

* `action_controller.status.200`
* `action_controller.format.html`
* `action_controller.exception.RuntimeError` - where RuntimeError is the class of any exceptions that occur while processing a controller's action.
* `active_support.cache_hit`
* `active_support.cache_miss`

#### Timers

* `action_controller.runtime`
* `action_controller.view_runtime`
* `action_controller.db_runtime`
* `action_controller.posts.index.runtime` - where `posts` is the controller and `index` is the action
* `action_view.app.views.posts.index.html.erb` - where `app.views.posts.index.html.erb` is the path of the view file
* `action_view.app.views.posts._post.html.erb` - I can even do partials! woot woot!
* `action_mailer.deliver.post_mailer` - where `post_mailer` is the name of the mailer
* `action_mailer.receive.post_mailer` - where `post_mailer` is the name of the mailer
* `active_record.sql`
* `active_record.sql.select` - also supported are insert, update, delete, transaction_begin and transaction_commit
* `active_support.cache_read`
* `active_support.cache_generate`
* `active_support.cache_fetch`
* `active_support.cache_fetch_hit`
* `active_support.cache_write`
* `active_support.cache_delete`
* `active_support.cache_exist`

### But wait, there's more!!!

In addition to doing all that work for you out of the box, I also allow you to wrap your own code with instrumentation. I know, I know, sounds too good to be true.

```ruby
class User < ActiveRecord::Base
  extend Nunes::Instrumentable

  # wrap save and instrument the timing of it
  instrument_method_time :save
end
```

This will instrument the timing of the User instance method save. What that means is when you do this:

```ruby
user = User.new(name: 'NUNES!')
user.save
```

An event named `instrument_method_time.nunes` will be generated, which in turn is subscribed to and sent to whatever you used to send instrumentation to (statsd, instrumental, etc.). The metric name will default to class.method. For the example above, the metric name would be `user.save`. No fear, you can customize this.

```ruby
class User < ActiveRecord::Base
  extend Nunes::Instrumentable

  # wrap save and instrument the timing of it
  instrument_method_time :save, 'crazy_town.save'
end
```

Passing a string as the second argument sets the name of the metric. You can also customize the name using a Hash as the second argument.

```ruby
class User < ActiveRecord::Base
  extend Nunes::Instrumentable

  # wrap save and instrument the timing of it
  instrument_method_time :save, name: 'crazy_town.save'
end
```

In addition to name, you can also pass a payload that will get sent along with the generated event.

```ruby
class User < ActiveRecord::Base
  extend Nunes::Instrumentable

  # wrap save and instrument the timing of it
  instrument_method_time :save, payload: {pay: "loading"}
end
```

If you subscribe to the event on your own, say to log some things, you'll get a key named `:pay` with a value of `"loading"` in the event's payload. Pretty neat, eh?

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
