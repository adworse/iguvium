# Iguvium
[![Build Status](https://travis-ci.com/adworse/iguvium.svg?token=pKH4s9rC7sLLfFxdq8b6&branch=master)](https://travis-ci.com/adworse/iguvium)

This gem extracts tables from PDF files. That's it. 

There are usually no actual tables in PDFs, only characters with coordinates,
 and some fancy lines. Human eye interprets this as a table. Iguvium behaves quite similarly:
 it looks for table-like graphic structure and tries to place characters into detected cells.
 
 Image recognition is written in Ruby, no OpenCV or other heavy computer vision libraries are used.
 
 Characters extraction is done by [PDF::Reader gem](https://github.com/yob/pdf-reader). Some PDFs are so insane it can't extract meaningful text from them. If so, so does Iguvium.

## Roadmap

Current version extracts regular (with constant number of rows per column and vise versa) tables
with explicit lines formatting, like this:

```
.__________________.
|____|_______|_____|
|____|_______|_____|
|____|_______|_____|
```

The next one will deal with open-edged tables like

```
__|____|_______|_____|
__|____|_______|_____|
__|____|_______|_____|
```

The final one will recognize tables with merged cells.

There are at the moment no plans to design recognition of whitespace-separated tables.
## Installation

Make sure you have Ghostscript installed. 

Linux: `sudo apt-get install ghostscript`

Mac: `brew install ghostscript`

Windows: download installer from the official [download page](https://www.ghostscript.com/download/gsdnld.html).

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

##CLI

Gem installation adds a command-line utility to the system. It's a simple wrapper:

```
iguvium filename.pdf [options]
    -p, --pages     page numbers, comma-separated, no spaces
    -i, --images    use pictures in pdf (usually a bad idea)
    -n, --newlines  keep newlines
```

Given filename it generates CSV files fir the tables detected 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adworse/iguvium.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Name

Just a place (ancient) where some [tables](https://en.wikipedia.org/wiki/Iguvine_Tablets) (incredibly cool ones) were found.