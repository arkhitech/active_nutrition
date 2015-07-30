Rails 4 Compatible active_nutrition gem
## active_nutrition

ActiveNutrition is an ActiveRecord-backed collection of models for storing and retrieving nutritional information from the USDA's Nutrient Database.

## Installation

`gem install active_nutrition`

## Usage

ActiveNutrition is meant to be used within a Rails application, but it should work within any Ruby project that uses ActiveRecord 3.0 or greater.

```ruby
require 'active_nutrition'
```

In a (possibly Rails) gemfile:

```ruby
gem 'active_nutrition', github: 'arkhitech/active_nutrition', branch: 'rails4'
```

### Getting the Data

ActiveNutrition has the ability to fetch the current Nutrient Database files from the USDA's website and load them into your ActiveRecord-supported database.  As long as you've established a connection via ActiveRecord, you should be able to import the nutrient data.

With Rails:

```bundle exec rake active_nutrition:migrate active_nutrition:rebuild```

Without Rails:

```ruby
require 'active_nutrition'

ActiveNutrition.migrate
ActiveNutrition.rebuild
```

_Note_: The full data import could take anywhere from 30 minutes to a few hours depending on how powerful your computer is.
_Note_: You can use `an` instead of `active_nutrition` for all rake tasks, eg. `rake an:rebuild`.

### Searching

ActiveNutrition provides a simple `#search` method that executes a SQL `LIKE` statement and returns an array of `Food` objects:

```ruby
ActiveNutrition.search("olive oil")
```

### Food Objects

Each `Food` object offers these methods

1.  `#nutrition_facts`: Returns an array of `NutritionFact` objects for each kind of nutrient associated with this food.  Examples include the amount of protein, fat, and sodium.  Each `NutritionFact` object knows its unit (eg. miligrams, grams, etc) and amount per 1 gram of the food.
2.  `#weights`: Returns an array of common unit weights for this food (eg. cups, tablespoons, etc) and their gram equivalents.
3.  `#food_group`: Returns an object that specifies the name and code of the food's food group (eg. Breads, Vegetables, etc).

### NutritionFact Objects

Each `NutritionFact` object has these important methods:

1.  `#value`: How much of this nutrient is present in 1 gram of the food.
2.  `#units`: The unit associated with `#value`.
3.  `#description`: A textual description of the nutrient.

```ruby
ActiveNutrition.search("olive oil").first.nutrition_facts
```

Calling `#nutrition_facts` on a `Food` object actually returns an instance of `NutritionFacts`, which provides a handy `#to_hash` convenience method to hash nutrient amounts by description:

```ruby
# { "Protein" => 0.0, "Total lipid (fat)" => 100.0, ... }
ActiveNutrition.search("olive oil").first.nutrition_facts.to_hash
```

The `#to_hash` method is capable of hashing nutrient amounts by any method supported by `NutritionFact` via the `:by` option:

```ruby
# { 203 => 0.0, 204 => 100.0, 205 => 0.0, 207 => 0.0, ... }
ActiveNutrition.search("olive oil").first.nutrition_facts.to_hash(:by => :nutrition_number)
```

### Weight Objects

Each `Weight` object offers these methods:

1.  `#amount`: The amount associated with `#measurement`, eg. 1, 0.5, etc.
2.  `#measurement`: The unit associated with `#amount`, eg. cup, tablespoon, gallon, dash, etc.
3.  `#grams`: Mass in grams.

Calling `#weights` on a `Food` object actually returns an instance of `Weights`, which provides a handy `#to_hash` convenience method to hash weights (grams) by measurement:

```ruby
# { "tablespoon" => 13.5, "cup" => 216.0, "tsp" => 4.5 }
ActiveNutrition.search("olive oil").first.weights.to_hash
```

## Requirements

No external requirements.

## Running Tests

No test suite exists for this gem yet - coming soon!


## Authors

Cameron C. Dutro: http://github.com/camertron

## Links
USDA Nutrition Database: [http://www.ars.usda.gov/Services/docs.htm?docid=8964](http://www.ars.usda.gov/Services/docs.htm?docid=8964)

## License

Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0

## Future Plans

* Ability to update your local database with `rake active_nutrition:update`.
* Test suite.