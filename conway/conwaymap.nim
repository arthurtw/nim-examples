import ansi
import sequtils, strutils

const mapWidth = 40
const mapHeight = 30

type
  Cell = bool
  ConwayMap* = array[0.. <mapHeight, array[0.. <mapWidth, Cell]]

proc init*(map: var ConwayMap, pattern: openarray[string]) =
  ## Initialise the map.
  let
    ix = min(mapWidth, max(@pattern.mapIt(int, it.len)))
    iy = min(mapHeight, pattern.len)
    dx = int((mapWidth - ix) / 2)
    dy = int((mapHeight - iy) / 2)
  for y in 0.. <iy:
    for x in 0.. <ix:
      if x < pattern[y].len and pattern[y][x] notin Whitespace:
        map[y + dy][x + dx] = true

proc print*(map: ConwayMap) =
  ## Display the map.
  ansi.csi(AnsiOp.Clear)
  ansi.csi(AnsiOp.CursorPos, 1, 1)
  for row in map:
    for cell in row:
      let s = if cell: "()" else: ". "
      stdout.write(s)
    stdout.write("\n")

proc next*(map: var ConwayMap) =
  ## Iterate to next state.
  let oldmap = map
  for i in 0.. <mapHeight:
    for j in 0.. <mapWidth:
      var nlive = 0
      for i2 in max(i-1, 0)..min(i+1, mapHeight-1):
        for j2 in max(j-1, 0)..min(j+1, mapWidth-1):
          if oldmap[i2][j2] and (i2 != i or j2 != j): inc nlive
      if map[i][j]: map[i][j] = nlive >= 2 and nlive <= 3
      else: map[i][j] = nlive == 3

