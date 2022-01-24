# Vendable

Vendable - testing project for Seeking Alpha

## Getting started

1. Clone repo and cd into the folder
```
$ git clone https://github.com/Ovsjah/vendable.git
$ cd vendable
```
2. Run `bin/setup` to install dependencies
3. Run `rspec` to run the tests
4. Run `bin/console` for an interactive prompt


## Usage

-- `vending_machine = Vendable::Machine.new` - creates an instance of vending machine
-- `vending_machine.menu` - presents available products with corresponding index (used to select product)
-- `vending_machine.insert_coin('5')` - inserts coin into vending machine updating credits
-- `vending_machine.cancel` - drops inserted coins preventing purchase
-- `vending_machine.select_product(8)` - purchases the selected product returning it with change
