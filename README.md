Smartime
===============

###### Queue Management System

Smartime is a queue management system that monetize the time of the customer. Customers no longer have to stand in a line or sit in the waiting area and waiting for their turn to be served. The customer can leave the waiting are without having to worry about missing their turn.

![Smartime demo][demo]

[demo]: https://raw.githubusercontent.com/ricardopereira/Smartime/master/Resources/Smartime-low.gif?token=ADYIwfcXPTkd1s207Jd0-YXt8YxWPIIsks5VlWZ3wA%3D%3D

The app uses [SocketIO-Kit](https://github.com/ricardopereira/SocketIO-Kit) and [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa).

Setup
-----

You need [Homebrew](http://brew.sh) and [RubyGems](https://rubygems.org).

Run `bin/setup`

This will:

- Install the gem dependencies
- Install the brew dependencies
- Build the carthage frameworks
- Install the pod dependencies
- Create `Secrets.h`. `ServerHost` is the only one required for the
  application to run.
  
Testing
-----

Run `bin/test`

This will run the tests from the command line, and pipe the result through [XCPretty](https://github.com/supermarin/xcpretty).

Author
------

Ricardo Pereira, [@ricardopereiraw](https://twitter.com/ricardopereiraw)

License
-------

Tropos is Copyright (c) 2015 thoughtbot, inc. It is free software,
and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE.md
