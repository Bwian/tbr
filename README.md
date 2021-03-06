# TBR

The Telstra Billing Reporter gem (tbr) provides functionality to parse monthly billing files produced in accordance with Telstra On Line Billing Service technical specfication version 6.4 and produces detailed and summary billing reports in PDF format. Minor updates to the Telstra specification are unlikely to cause any problems.

## Installation

Add this line to your application's Gemfile:

    gem 'tbr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tbr

## Usage

Create an instance of Tbr::Processor.  Most instance variables can be set using arguments to initialize or by calling smae named methods on the instance.
  
##### initialize(*args)
Accepts a hash of optional elments with the following keys:  

_:output_   - the pathname of the output directory.  Defaults to /tmp.

_:services_ - a two dimensional array, each row containing the elements service number, group, description and cost centre.  Defaults to an empty array meaning services will not be grouped.

_:log_      - logfile pathname.  Defaults to /dev/null.  STDOUT, STDERR or a file pathname are valid arguments.

_:replace_  - boolean flag which determines replacement of pre-existing output files.  Defaults to false.

_:logo_     - logo pathname.  Defaults to the logo.jpg in the tbr gem

_:original_ - original filename.  Used for log messages if uploaded file uses an anonymous temporary filename

#####  import__services(filename)
Accepts the path name of a csv file in which the first four cells in each row equate to those in the array of the _:services_ argument to _initialize()_.  The imported array is stored in the _services_ instance variable.

##### process(filename)
Raises ArgumentError along argument isn't a String.

Raises IOError if the input file doesn't exist.

Log messages are written to track progress and record use of default settings.

A top-level directory is created in the output path named in the format _YYYYDD_, the underlying date being extracted from the Telstra billing file.  A _details_ subdirectory contains separate files for each service.  A _summaries_ subdirectory contains summaries for each service by service group as specified in the _:services_ array argument to _process()_. The top-level directory also contains an overall _Service Totals_ file containing one line per service.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/tbr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
