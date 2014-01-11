Template::Plugin::React
=======================

This is a Template Toolkit plugin to render [React](http://facebook.github.io/react/)
components. The current version is `0.002`.

Requirements
------------
Mozilla's [SpiderMonkey](www.mozilla.org/js/spidermonkey/) engine must
be installed. SpiderMonkey 24 was used to build this module; if you use
a different version, your mileage may vary. The `Makefile.PL` script
uses `js-config` to learn about the compilation flags to use, so make
sure that is in your `PATH`.

Usage
-----
This plugin only exposes a single function: `React.render(component, data)`.
`component` must be a string representing the component name, and `data`,
if passed, must be a hash ref representing the data to provide to the
component during rendering.

```
[% USE React %]
[% React.render('Component', data) %]
```
