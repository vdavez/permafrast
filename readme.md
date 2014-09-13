# Permafrast

A human-centric approach to the Fastcase Public API. 

# What is this?

Fastcase recently disclosed that it has a [public API](http://legalgeekery.com/2014/09/10/fastcase-public-links-to-cases-on-haiku-decisis-are-here/) for any member of the public to see a reported judicial opinion without going behind the paywall. This is a breakthrough. 

The API requires a user to set headers and pass a data object. This is good, but I'm lazy and just want to work from the browser's address bar. So, I built a human-centric wrapper around the API.

# Usage

The permafrast API has two exposed endpoints: `/info` and `/json`. The `info` endpoint gives a clickable link with the full citation for the opinion. The `json` endpoint gives a json object associated with the opinion. 

For both endpoints, you must pass three parameters associated with a reported judicial opinion:

1. The volume of the reporter (an integer)
2. The reporter abbreviation (e.g., `U.S.`)
3. The starting page of the opinion (an integer)

So, `http://permafrast.herokuapp.com/info/:volume/:reporter/:starting_page`. For example, see <http://permafrast.herokuapp.com/info/600/F.3d/642>.

# License
MIT