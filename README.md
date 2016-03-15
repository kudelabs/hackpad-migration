# Hackpad::Migration

A tool for migrate Hackpad from one Hackpad site to other Hackpad site via Hackpad's APIs.

## Installation

    $ gem install hackpad-migration

## Usage

    hackpad-migrate migrate

    Options:
    [--output=OUTPUT]  # file path for the result, default is result.json in current path.

    Do migration with the config in the result, it will create a new config when you execute it at first time.


The migration can execute multiple times as you want, it will store the result in the disk after the migrateion is done for each pad, So the next time to be executed, this tool will update all the pad from source site.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kudelabs/hackpad-migration.
