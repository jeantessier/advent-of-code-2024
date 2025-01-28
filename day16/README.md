# [Day 16](https://adventofcode.com/2024/day/16)

## Puzzle 01

Another path-finding exercise.  I build a list of `Path` objects, starting with
a path starting at `S` and facing East.  Each iteration, I pick out "active"
paths and look right, foward, and left from the path's head.  If the path meets
a dead-end or wraps in on itself, it becomes inactive.  If there are multiple
options, the path clones itself to explore right or left paths.

The first sample took **77** cycles to explore **285** paths.  The second sample
took **98** cycles to explore **122** paths.  I stopped the run against the
input after **101** cycles, when it was exploring **3,288,597** paths (2M of
which were still active).  I was running out of memory and each new cycle was
taking a really long time.

I needed a new approach.

Enter graph theory.  I mapped each corner and intersection as vertices in a
graph, including the start and end locations.  There are edges between vertices
that have an open path between them.  The cost of each edge is its length.

|  Graph  | Vertices | Edges |
|:-------:|:--------:|:-----:|
| sample1 |    33    |  57   |
| sample2 |    36    |  51   |
|  input  |  3,079   | 5,025 |

Each edge represents a turn.  The total cost of a path from `S` to `E` will be
1,000 times the number of edges, plus the sum of costs for these edges (plus one
turn if we head North from `S`).  Because a turn is so costly, the path with the
fewest edges should be the cheapest.

I grew paths from `S`, until at least one reached `E`.  I then pruned all the
false leads.  There were still too many edges to really identify paths, so I
repeated the process in the other direction, starting at `E` and ending at `S`,
and computed the intersection of edges that were in both sets.  I was able to
use recursion on that small subset to identify paths.  Took just under
**2 minutes**.

## Puzzle 02

I had paths from Puzzle 1.  I just need to select all the ones with the lowest
score, compute all the vertices for each, and de-dupe them using Ruby's
`#flatten` and `#uniq` methods.  It worked fine for the samples, but my initial
implementation turned out too low when I used it against the real input.

I suspected that I was probably pruning too aggressively.  Between pruning
from `S`, pruning from `E`, and taking the intersection, I was leaving out some
alternate path that still had the lowest score.

The Advent of Code site told me **466** was too low, and I tried **500** on a
lark to find that was too high.

I printed my result with **466** and found a small alternate path near `S`
with **13** extra tiles.  Adding them gave me the correct answer.

I tried various ways to be more lenient in my pruning, but each time it sent
the program into some infinite loop somewhere in the center.  I threw in the
towel after another 5 hours of fruitless trial and error.
