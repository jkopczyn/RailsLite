# RailsLite

A micropoject in Ruby metaprogramming to create the basics of Rails and
ActiveRecord from scratch.

## Key Features

  * In ActiveRecord: Searchable and Associatable make it possible to look up
    models in the database by fields and associations.
  * `ControllerBase#render` includes some neat metaprogramming to find and fill
    the view template for any action
  * `Route#run` maps routes to actions and dynamically generates a Controller to
    finish executing

## Running the Code

The specs used to test that the code matched the behavior of the Rails
equivalents; these can be found in `/spec` and should be run with `bundle exec rspec spec/`.

For a live demo, a few servers have been provided in `/bin`. These should be run
from the root directory with `ruby bin/<server-name>.rb`.


