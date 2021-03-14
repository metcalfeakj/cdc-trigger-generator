# CDC Trigger Generator
Handy script to create table triggers for change data capture events on a specified table.

## Purpose
To generate an SQL query for **AFTER** Insert, Update, Delete triggers that capture the changes and stores it in a JSON format, which then can be used by a message broker such as Redis. And for myself to further strengthen my knowledge of the SQL language - hence written completely in SQL and not a 10x approved language such as Python.

## License
Distributed under the Unlicense license. See `LICENSE` for more information.

## Usage
Instructions are in the generate.sql file. Fill in the parameters and execute the code.
Once executed, any operations performed on the targeted table will be recorded as an event in the JSON format.

## Contact
Alex Metcalfe - metcalfe.akj@gmail.com

## Acknowledgements
* Craig Patterson who wrote an implementation that this was inspired from.
