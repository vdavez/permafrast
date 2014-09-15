# Permafrast

A human-centric approach to the Fastcase Public API, originally built by [@vdavez](https://twitter.com/vdavez) with substantial contributions of [@TalkingQuickly](https://twitter.com/TalkingQuickly) and [@adelevie](https://twitter.com/adelevie).

# What is this?

Fastcase recently disclosed that it has a [public API](http://legalgeekery.com/2014/09/10/fastcase-public-links-to-cases-on-haiku-decisis-are-here/) for any member of the public to see a reported judicial opinion without going behind the paywall. This is a breakthrough. 

The API requires a user to set headers and pass a data object. This is good, but I'm lazy and just want to work from the browser's address bar. So, I built a human-centric wrapper around the API.

# Usage

The permafrast API responds to both html and json requests. E.g:

* `/:volume/:reporter/:starting_page` for html
* `/:volume/:reporter/:starting_page.json` for json
* `/:volume/:reporter/:starting_page/redirect` will automatically redirect the user to the reported opinion url

The `html` response gives a clickable link with the full citation for the opinion. The `json` response gives a json object associated with the opinion. 

For both endpoints, you must pass three parameters associated with a reported judicial opinion:

1. The volume of the reporter (an integer)
2. The reporter abbreviation (e.g., `U.S.`)
3. The starting page of the opinion (an integer)

So, `http://permafrast.herokuapp.com/:volume/:reporter/:starting_page`. For example, see <https://permafrast.herokuapp.com/600/F.3d/642>.

# Source Code and Contributions

[![Build Status](https://travis-ci.org/vzvenyach/permafrast.svg?branch=master)](https://travis-ci.org/vzvenyach/permafrast)

The source code for permafrast is available at <https://github.com/vzvenyach/permafrast>. Please feel free to submit PRs or [open issues](https://github.com/vzvenyach/permafrast/issues).

# Development

## Database

In development SQLite is used, use `bundle exec rake db:create && db:migrate` to create it.

## Installation

You can easily run your own instance of Permafrast.

1. Clone the repo.
2. `cp .env.example .env`.
3. Add your Fastcase API key to `.env`. If you don't have one, tweet to [Josh Auriemma](https://twitter.com/legalgeekery).
4. Run `bundle`.
5. Run the server locally with `bundle exec rackup -p 4567`.
6. Run tests with `bundle exec rspec`

# License
MIT
