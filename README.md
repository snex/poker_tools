# Poker Tools #

Just some tools I find useful for analyzing poker

## stats.r ##

This is a script that will take your real poker results, build a probability distribution function based on them, then use that function to create a random year's worth of poker sessions. The purpose is to see potential swings, how big they are, how long they are likely to last, etc. It also provides winrate statistics, including weekly and monthly simple moving averages.

### Installation ###

This script requires the [R Programming Language](https://www.r-project.org/), as well as the following packages for it:
* dplyr
* logspline
* plyr
* TTR

Inside the script there is a section headed with "EDIT THESE VALUES ONLY." You should edit these values to tailor them to your specific needs.
* "runs" is the number of random samples to generate based on your data. Each run contains a year's worth of projected data. I find that 10,000 runs gives a pretty good spread of possibilities.
* "times_per_week" is the number of sessions you put in per week.
* "stoploss" if you play with a stoploss, set this to that value. Or set it to NULL if you don't make use of a stoploss.

### Usage ###

You will need a file called 'data.txt' in the same folder where the script is. The file can take one of two formats:

1. A list of session results, one per line. Example:
```CSV
100
200
-50
```

2. A comma-separated list of session results and time stamps, one per line. Example:
```CSV
100,5:05
200,6:45
-50,2:32
```

Then, just run the script from the command line, making sure it is executable if it isn't already.

There will be several blocks of text of output with some generic stats, as well as a PDF file with more detailed stats in graph form.

### Output ###

The text output should be self-expanatory. The PDF output is exlained below.

#### Page 1 ####

This is your probability distribution function. Since poker sessions do not seem to follow any distribution I am familiar with, and every player is different, I decided to use a logspline estimator function. This function is charted on top of a histogram of your actual results, so you can see how closely it estimates your actual play. It should even work for tournaments, sports bets, horse racing, or really anything where you can track daily cashflow.

#### Page 2 ####

This will display the more interesting runs in the randomly generated set. It will contain the best and worst, and the largest swings in both directions by session, week, and month. It will also display your actual results.

#### Page 3 ####

This will display your win rate data. If you used time stamps, it will calculate your win rate hourly, otherwise it will be by session. It includes the session win rate, the average win rate, and the weekly and monthly simple moving averages, to see if your recent results are performing better or worse than normal.

#### Pages 4-7 ####

These pages show the probability of streaks of a specific length occurring. Page 4 is by session, Page 5 by week, Page 6 by month, and Page 7 by year.
