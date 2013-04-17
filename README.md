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

## FAQ

Nothing. Nobody's asked me anything about it. 

## Questions I'm going to answer anyway, whether anyone asks them or not

* **Why did you create this?** - I had to check in a lot of little projects to a local Gitlab repo, and I'm lazy
* **Why is it called glub?**   - The *gl* bit stands for GitLab, obviously, and glub is just a short word that starts with that. 

## TODOs

This is very much an early release, that'll be getting added to frequently.

Coming soon:

* More control over project creation


## Licence

This is released under the [Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0.html) licence.
