# Gitlab command-line client

This is a Gitlab command-line client. It's still very early in development. So far, you can create projects, and that's it.

Dependencies:

* [Thor](http://whatisthor.com)
* [Rest Client](http://rubygems.org/gems/rest-client)

## Installation

gem install glub

## Config

You will need a file called .gitlab in your home directory. It's a YAML file. 

You can get your API key - also known as private token - from your account page on Gitlab

### Config example

api_endpoint:   http://gitlab.mycompany.com/api/v3
api_key     :   Kd834fh3ofoaal

## TODOs

This is very much an early release, that'll be getting added to frequently.

Coming soon:

* More control over project creation


## Licence

This is released under the [Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0.html) licence.
