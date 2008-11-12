TofuBlox
========

It's a tumbleblogemess. It's a Ramaze app. It scratches an itch for me.

TofuBlox is to a CMS as tofu is to chicken: more fun, and better for you and the chicken.

## Requirements

All the requirements to run TofuBlox are bundled with it in the `system/vendor/` directory.

If you want to hack on TofuBlox, you'll want the following gems:

* mocha
* ditz
* reek
* roodi

== Installation and setup

Clone the git repository (git://github.com/crnixon/tofublox.git) or download a tarball and expand it. This should be ready to run, but you'll want to customize it. You should pay attention to the files below:

* `config/tofu_config.rb`

You can set the default title for your site here, as well as the password to log into the admin section.

* `molds/`

This is where you put definitions of _blocks_, serial content posted to your site.

* `templates/`

The templates for your site's output (as well as admin section) are here. They are in XHTML format, with Ruby code written with [Ezamar](http://ramaze.rubyforge.org/rdoc/classes/Ezamar/Template.html).

## Mold definitions

This is pretty simple: it's a YAML file with a template underneath.

The YAML file contains the mold's fields, with types. See `Post.yaml` for details.

