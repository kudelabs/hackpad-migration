# Hackpad::Migration

A tool for migrate Hackpad from one Hackpad site to other Hackpad site via Hackpad's APIs.

## WARNING

This tool can't make sure all the data can be migrated perfectly, It just use Hackpad API to do this migration, the data that extract from Hackpad is not the origin data from DB, so some data will be lose, please make sure you understand before you use it.

Here is the data that will lose as I know

- Pad modified info from users.
- Checkbox in the pad (fixed by change css name in this migration tool)
- Header 1 in the pad (fixed by change ellement h2 to hackpad style)
- All link tag in the pad
- All users info of comments in the pad

## Installation

    $ gem install hackpad-migration

## Config

    Please copy db.json.sample to db.json and edit it before migreate.

## Usage

### hackpad-migrate migrate

    Options:
    [--db=db_file]  # file path for the result, default is db.json in current path.

    Do migration with the config in the result, it will create a new config when you execute it at first time.


The migration can execute multiple times as you want, it will store the result in the disk after the migrateion is done for each pad, So the next time to be executed, this tool will update all the pad from source site.


### hackpad-migrate make_index

    Options:
    [--db=DB]  # file path for the result, default is db.json in current path.

    Create index for the pads that migrated

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kudelabs/hackpad-migration.
