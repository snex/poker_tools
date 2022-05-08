# stats

Shows statistics for recorded poker hands. In order to import hand data, you must run the "data:import" rake task

```
RAILS_ENV=production rake data:import file=filename
```

"filename" must be named the date of the session in YYYY-MM-DD, for example: 2019-01-08.txt

The file must contain hands in the following format:

```
human readable notes,
can be as many lines as you like
[[villain cards line]]
[result] [position] [hand] [bet_size] [[table_size]]

this is the second hand
[[villain cards line]]
[result] [position] [hand] [bet_size] [[table_size]]
```

Result must be an integer preceded by a '+' or a '-' sign.

Position must be one of the following: SB, BB, UTG, UTG1, UTG2, MP, LJ, HJ, CO, BU, STRADDLE

Hand must be a Holdem hand in standard notation, e.g.: AA, AKs, QTo

Bet Size is the number of bets YOU put in preflop, or "limp" if you limped. For example, if you raise and another player 3bets and you fold, this will be 2b, since YOU only put in the single raise.

Table Size is optional. If not present, the task will assume 10/9/8 handed. For other table sizes, just put the number in.

To record flop, turn, and river, just start one of your note lines with: "Flop xxx," "Turn x," or "River x,". These do not need to be in any specific format. Everything after the space and before the comma will be listed as the flop/turn/river.

If your note contains the phrase "all in" and your result is a positive number or there is a villain cards line, then this hand will be considered an all in hand.

The villain cards line must contain the phrase "V show (something)" or "V muck." You can place anything else before or after these phrases, for example: "UTG V show AA and win" and it will still be picked up. You can also have multiple villain cards lines.

Example hand file:

```
2019-01-07.txt
-----------------------------------
open utg 20 AA, BB call
Flop A33, check around
Turn A, check, bet 10, call
River 3, check, bet 20, raise all in 500, call
BB V show 43o and lose
+530 utg AA 2b

7 handed, straddle on, BU BB limp, check straddle 72o
Flop AKQr, BB bet 20, fold
-10 straddle 72o limp 7

open BU 20 54s, sb 3b 80, bb 4b 225, fold
-20 bu 54s 2b
```
