TofuBlox
========

It's a tumbleblogemess. It's a Ramaze app. It scratches an itch for me.

TofuBlox is to a CMS as tofu is to chicken: more fun, and better for you and the chicken.

## Requirements

You can easily retrieve all the requirements to run TofuBlox if you download it by using `git clone`. Inside the top TofuBlox directory, run this command:

    git submodule update --init

If you downloaded TofuBlox as a compressed file or in some other fashion, the easiest way to get its requirements are by installing Ruby gems. You can install the needed gems with these commands:

    gem install ramaze sequel bacon
    gem install crnixon-active_files --source http://gems.github.com

If you want to hack on TofuBlox, you'll want the following gems:

* rcov
* mocha
* reek

They are not included by default, but can be obtained with the command:

    gem install rcov mocha reek

## Setup

Clone the git repository (git://github.com/crnixon/tofublox.git) or download a tarball and expand it. This should be ready to run, but you'll want to customize it. You should pay attention to the files below:

* `config/tofu_config.rb`

You can set the default title for your site here, as well as the password to log into the admin section.

## Blocks

going to admin

creating blocks

## Molds

* `molds/`

This is where you put definitions of _blocks_, serial content posted to your site.

This is pretty simple: it's a YAML file with a template underneath.

The YAML file contains the mold's fields, with types. See `Post.yaml` for details.

### Making your own molds

## Templates

* `templates/`

The templates for your site's output (as well as admin section) are here. They are in XHTML format, with Ruby code written with [Ezamar](http://ramaze.rubyforge.org/rdoc/classes/Ezamar/Template.html).

## Backing up your data

