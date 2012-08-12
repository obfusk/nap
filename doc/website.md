nap is a configurable and extensible set of tools and templates that
makes it easier to manage and deploy web applications.

  * Have new apps running in seconds.
  * Get a quick overview of running apps.
  * Update an app in seconds with a single command.
  * Allow developers to have their apps updated automatically when
    they push their code to the server.

--&gt;
[README][readme]
[The ruby type][t-ruby]
[The clojure type][t-clj]
[My server setup][my-srv]

<br/>

### Adding an app

    $ nap new hello ruby https://github.com/obfusk/nap-hello.git \
      ruby.server=localhost ruby.port=3001
    $ nap bootstrap hello
    $ nap start hello

### Screenshots

![nap new/bootstrap/start][i-new]
![naps][i-naps]

### Screenshot links

[nap new/bootstrap/start][i-new]
[naps][i-naps]

<br/>

Copyright (C) 2012  Felix C. Stegerman  --  2012-08-12  --  v0.0.0

[readme]: https://github.com/obfusk/nap#readme
[t-ruby]: https://github.com/obfusk/nap/blob/master/doc/type-clj
[t-clj]:  https://github.com/obfusk/nap/blob/master/doc/type-ruby
[my-srv]: https://github.com/obfusk/nap/blob/master/doc/my-server

[i-new]:  https://github.com/downloads/obfusk/nap/new_boot_start.png
[i-naps]: https://github.com/downloads/obfusk/nap/naps.png
