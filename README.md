# Desuraify

Desura game store scraper

## Installation

Add this line to your application's Gemfile:

    gem 'desuraify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install desuraify

## Usage

  require 'desuraify'

  \# get all information about Dominions 4: Thrones of Ascension 
  \# (http://www.desura.com/games/dominions-4-thrones-of-ascensions)
  ```
  game = Desuraify::Game.new('dominions-4-thrones-of-ascensions')
  game.update
  ```

  \# show current price
  ```
  puts game.price
  => "$34.99"
  ```

  \# game title
  ```
  puts game.title
  => "Dominions 4: Thrones of Ascension"
  ```

  \# game platforms
  ```
  game.platforms.each { |platform| puts platform }
  => "Windows"
  => "Mac"
  => "Linux"
  ```

  \# numerous other attributes are available (some partially or poorly implemented)
  ```
  puts Desuraify::Game::ATTRIBUTES.inspect
  ```

## TODO in no particular order

  1. Maybe nothing, apparently the parent company of Desura filed for bankruptcy yesterday...
  2. Gather Engine data (currently game data is all that is functional)
  3. Gather Member data
  4. Gather Company data
  5. Documentation...
  6. Tests (I know, I'm a horrible person)

## Contributing

  1. Fork it ( https://github.com/[my-github-username]/desuraify/fork )
  2. Create your feature branch (`git checkout -b my-new-feature`)
  3. Commit your changes (`git commit -am 'Add some feature'`)
  4. Push to the branch (`git push origin my-new-feature`)
  5. Create a new Pull Request

## Credits

  This project and much of the code was inspired by Market Bot:
  https://github.com/chadrem/market_bot