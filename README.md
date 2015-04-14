# TBR

Telstra Billing Reporter parses monthly billing files produced in accordance with Telstra On Line Billing Service technical specfication version 6.4 and produces detailed and summary billing reports in PDF format. Minor updates to the Telstra specification are unlikely to cause any problems.

## Installation

Add this line to your application's Gemfile:

    gem 'tbr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tbr

## Usage

The API supports two class methods:
### process
The first argument must be supplied and is the path name of the billing file.  Subsequment arguments are optional hash elments with the following keys:

_:output_   - the pathname of the output directory.  Defaults to /tmp

_:services_ - a two dimensional array, each row containing the elements service number, group, description and cost centre.

_:log_      - logfile pathname.  Defaults to STDOUT.

_:replace_  - boolean flag which determines replacement of pre-existing output files.  Defaults to false.

_:logo_     - logo pathname.  Defaults to the logo.jpg in the tbr gem

Raises ArgumentError along with usage message if first argument isn't a String or subsequent arguments aren't Hash elements.

Raises IOError if the input file doesn't exist.

Log messages are written to track progress and record use of default settings.

###  parse__services__file
Accepts one argument - the path name of a csv file in which the first four cells in each row equate to those in the array of the _:services_ argument to _process()_.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/tbr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
