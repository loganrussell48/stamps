# stamps

A small CLI tool for generating and averaging timestamps

## Usage: 
`stamps <command> [arguments]`

Global options:
`-h`, `--help`    Print this usage information.

Available commands:

  `average`    - Calculates the average time (hour/minute) of the list of times in the provided comma-separated-values (csv) file
  
  `generate`   - Generates timestamps

Run `stamps help <command>` for more information about a command.

## Examples:
#### To generate 100,000 timestamps from 7 minutes after midnight until 9:50pm

`stamps generate -s "2010-12-31 00:07:00.000" -e "2010-12-31 21:50:00.000" -q 100000`

The output will, by default, go to a file named _times.csv_. You can specify an output location using parameters. Run `stamps help generate` for more info.

**Note**: _the year-month-day is arbitrary for the purposes of this application, but it must be a valid date for parsing into DateTime objects_

#### To calculate the average of a collection of timestamps

`stamps average`

The input will, by default, be _times.csv_. You can specify an input file using parameters, but it must be a `.csv` file.

The output will, by default, be to stdout. You can specify an output file using parameters. Run `stamps help average` for more information.

## How it's calculated

The average is calculated by converting every time to the corresponding angle on a 24hr analog clock. You can find a visualization [here][1]

The mean cosine and mean sine are used to calculate the vector mean. The vector mean is used to calculate the resultant mean.
The argument of the resultant mean is then the sample mean, and is used to convert back into a Duration object that has `hours`, `minutes`, `seconds`, & `milliseconds` properties designating the average time of day.

[1]:https://www.desmos.com/calculator/m5prwbt5wz
