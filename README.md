# Ip2cityisp
input is ip
output is city ,isp.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ip2cityisp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ip2cityisp

## Usage

require 'rubygems'
require 'bundler/setup'
require 'ip2cityisp'
ip =  ARGV[0]
@db = Ip2cityisp::Database.new('/tmp/ipinfo.data')
r = @db.query('8.8.8.8')
rip = r["area"]+r["isp"]  

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ip2cityisp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
