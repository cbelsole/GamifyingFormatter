# GamifyingFormatter
![Achievements and Trophies](/achievement.png)

GameifyingFormatter is here to solve your testing woes. With trophies and achievements it makes running tests fun. This project was created so that you could use it as a stand alone test runner or extend it and add achievements to your own test runner.

These are the achievements you can get points for right now:
Fixing failed tests
Improving test speed
Adding tests

You receive the trophies based on the amount of points you get which start out small and get bigger.

Now works on Rspec 1/2/3 and Minitest 5.

Thanks goes to the good folks at [nyan-cat-formatter](https://github.com/mattsears/nyan-cat-formatter) for the inspiration to do this and blazing for the trail for creating formatters.

## Installation

Add this line to your application's Gemfile:

    gem 'gamifying_formatter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gamifying_formatter

If you want to use the Gamifying Formatter as your default formatter just put this option in your .rspec file:

    --format GamifyingFormatter

## Usage

### Rspec

To use the GamifyingFormatter all you need to do is add this option when you are running your spect tests if you did not already edit your .rspec file:

    --format GamifyingFormatter

### Minitest

To use the GameifyingFormatter with Minitest, simply install it via `gem` or `bundle` and you should be all set to go. 

## Example

Run the example using:

    rspec example/example.rb --require gamifying_formatter.rb --format GamifyingFormatter

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

