import conwaymap
import os, threadpool

const pauseMillis = 20
const defaultCount = 300
const initialMap = [
  "                        1           ",
  "                      1 1           ",
  "            11      11            11",
  "           1   1    11            11",
  "11        1     1   11              ",
  "11        1   1 11    1 1           ",
  "          1     1       1           ",
  "           1   1                    ",
  "            11                      ",
]

proc enterToQuit() =
  discard readLine(stdin)
  quit()

proc main() =
  var map: ConwayMap
  map.init(initialMap)
  # Press ENTER to exit"
  spawn enterToQuit()
  # Start the game
  for i in 1..defaultCount:
    map.print()
    echo "n = ", i, "\t Press ENTER to exit"
    os.sleep(pauseMillis)
    map.next()

when isMainModule:
  main()

