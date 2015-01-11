import
  parseopt2, pegs,
  algorithm, sequtils, strutils, tables

const usageString =
  """Usage: wordcount [OPTIONS] [FILES]

Options:
    -o:NAME             set output file name
    -i --ignore-case    ignore case
    -h --help           print this help menu
"""

proc doWork(inFilenames: seq[string] = nil,
            outFilename: string = nil,
            ignoreCase: bool = false) {.raises: [IOError].} =
  # Open files
  var
    infiles: seq[File] = @[stdin]
    outfile: File = stdout
  if inFilenames != nil and inFilenames.len > 0:
    infiles = inFilenames.mapIt(File, (proc (filename: string): File =
      if not open(result, filename):
        raise newException(IOError, "Failed to open file: " & filename)
    )(it))
  if outFilename != nil and outFilename.len > 0 and not open(outfile, outFilename, fmWrite):
    raise newException(IOError, "Failed to open file: " & outFilename)

  # Parse words
  var counts = initCountTable[string]()
  for infile in infiles:
    for line in infile.lines:
      let input = if ignoreCase: line.tolower() else: line
      let words = try: input.findAll(peg"\w+") except: @[]
      for word in words:
        counts.inc(word)

  # Write counts
  var words = toSeq(counts.keys)
  sort(words, cmp)
  for word in words:
    outfile.writeln(counts[word], '\t', word)

proc main() =
  # Parse arguments
  var inFilenames: seq[string] = @[]
  var outFilename: string = nil
  var ignoreCase = false
  for kind, key, val in getopt():
    case kind
    of cmdArgument:
      inFilenames.add(key)
    of cmdShortOption, cmdLongOption:
      case key
      of "help", "h": echo usageString; return
      of "ignore-case", "i": ignoreCase = true
      of "o": outFilename = val
      else: discard
    of cmdEnd: discard
  doWork(inFilenames, outFilename, ignoreCase)

when isMainModule:
  main()

