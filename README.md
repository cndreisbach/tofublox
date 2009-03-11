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

To run TofuBlox in development mode, run `ruby start.rb`. TofuBlox uses [Rack](http://rack.rubyforge.org/) as its web server interface, so it can be deployed in production in any way any Rack app can. I recommend using [Phusion Passenger](http://www.modrails.com/).

## Blocks

When you start TofuBlox, the home page will be blank and you will not know what to do. Go to http://wherever.you.are.running.this/admin. You will be prompted via HTTP Basic authentication for a username and password. The password is whatever you have set up in `config/tofu_config.rb`. You can type whatever you like for the username. This username will be used as the author when you create new blocks.

_Blocks_ are what most blog systems call "posts" and what most CMSes call "pages." They are called blocks because you can set up many _molds,_ or definitions of blocks. By pouring content into these molds, you can make new blocks.

The admin screens should be pretty self-explanatory, but if they are not, let me know!

## Molds

Molds are kept in text files under the `molds/` directory. They are pretty simple: they're a YAML file with one or two templates underneath, like this:

    ---
    Fields:
    - Title: string
    - Body: text
    ---
    <div class="block post" id="post-#{id}">
      <h2 class="block-title">
        <a href="/view/#{permalink}" rel="bookmark" title="#{f 'Title'}">#{f 'Title'}</a>
      </h2>
    </div>
    ---
    <div class="block post" id="post-#{id}">
      <h2 class="block-title">#{f 'Title'}</h2>
      <div class="block-content">
        #{f 'Body'}
      </div>
    </div>

The filename is the name of the mold, so `Bookmark.yaml` makes a mold named "Bookmark."

The YAML section defines the mold's fields, like so:

    Fields:
    - Title: string
    - Body: text
    
This is a hash with the key "Fields" pointing to an array of hashes. (It's an array so they can stay ordered.) Those one-key hashes contain the field title as their key, and the field type as their value. The current allowed values are "string", "text", and "markdown". "string" fields will not have any formatting applied to them; "text" fields will have very simple formatting applied (line breaks turn to `br` or `p` HTML elements); "markdown" fields will be processed as [Markdown](http://daringfireball.net/projects/markdown/).

The first template underneath is a summary template, and is usually called when the block is shown in aggregate, like on an index page. The second template is the template used when the block is shown alone. If you only have one template, it serves both purposes.

## Templates

Templates in TofuBlox are written using [Ezamar](http://github.com/manveru/ezamar/tree/master), a friendly little templating scheme. If you've used ERb (what's used in Rails), you can use the syntax you're familiar with. It's worth taking a look at Ezamar's own syntax, though: it validates as XHTML, which sounds nice.

Besides the templates in molds, your site has templates in the `templates/` directory. These determine the look of your site, including the admin section. The major templates you want to look at are:

* `layouts/site.xhtml`
* `index/get.xhtml`
* `view/get.xhtml`

`site.xhtml` is used as the main layout throughout the public face of your site. `index/get.xhtml` is used for the front page content, and `view/get.xhtml` is used to look at individual blocks.

## Backing up your data

There is a Rake task to back up your blocks. To use it, run `rake dump`. This will dump out a file called `tofu.yaml` in your top-level directory. To load that file back into your Tofu database, run `rake load`.

You can specify where to read the file from or write the file to by adding `TOFU_YAML=/some-dir/wherever.yaml` to the end of the `rake` commands listed above.

The dump YAML format should stay consistent even as TofuBlox changes, so if you're an early adopter and use this and want to upgrade later, you should be able to dump the data, upgrade, and load it back in.