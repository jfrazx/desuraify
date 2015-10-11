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
  ```
  require 'desuraify'
  ```

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

  \# game developers
  ```
  game.developers.each do |developer|
    puts developer[:name]
    puts developer[:company]
    puts developer[:id]
  end

  => "Illwinter Game Design"
  => true
  => "illwinter-game-design"
  ```

  \# numerous other attributes are available
  ```
  puts Desuraify::Game::ATTRIBUTES.inspect
  or
  puts game.attributes
  ```

## TODO

  1. Gather Engine data - June 12, 2015
  2. Gather Member data - July 21, 2015
  4. Gather Company data - June 13, 2015
  5. Documentation...
  6. Tests - July 21, 2015

## Contributing

  1. Fork it ( https://github.com/jfrazx/desuraify/fork )
  2. Create your feature branch (`git checkout -b my-new-feature`)
  3. Commit your changes (`git commit -am 'Add some feature'`)
  4. Push to the branch (`git push origin my-new-feature`)
  5. Create a new Pull Request

## Credits

  This project and much of the code was inspired by Market Bot:
  https://github.com/chadrem/market_bot
