# Iguvium

This gem extracts tables from PDF files. That's it. I will write more words later.
## Installation
<img src="https://img2.mokum.place/system/images/stage1/000/365/384-83463a9f-9894-4d73-99f4-3fa8795ce66e.jpg" alt="Knorozov" width="250" ALIGN='right'/>

Make sure you have Ghostscript installed.

Add this line to your application's Gemfile:

```ruby
gem 'iguvium'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install iguvium

## Usage

```require 'iguvium'
pages = Iguvium.read 'file.pdf'
pages.count
tables = pages[6].extract_tables!
tables.first.to_a
```


## Development

<img src="https://img2.mokum.place/system/images/stage1/000/365/384-83463a9f-9894-4d73-99f4-3fa8795ce66e.jpg" alt="Knorozov" width="250"/>
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adworse/iguvium.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
