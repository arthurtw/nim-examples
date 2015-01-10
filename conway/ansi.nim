type
  AnsiOp* = enum
    CursorUp = 'A',
    CursorDown = 'B',
    CursorForward = 'C',
    CursorBack = 'D',
    CursorPos = 'H',
    Clear = 'J',
    EraseToEOL = 'K'

proc csi*(op: AnsiOp, x, y: int16 = -1) =
  stdout.write("\x1b[")
  if x >= 0: stdout.write(x)
  if y >= 0: stdout.write(';', y)
  if op == AnsiOp.Clear: stdout.write('2')
  stdout.write(chr(ord(op)))

