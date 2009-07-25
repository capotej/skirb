TIOCGWINSZ = 0x5413                  # For an Intel processor

def terminal_size
  rows, cols = 25, 80
  buf = [ 0, 0, 0, 0 ].pack("SSSS")
  if STDOUT.ioctl(TIOCGWINSZ, buf) >= 0 then
    rows, cols, row_pixels, col_pixels = buf.unpack("SSSS")[0..1]
  end
  return rows, cols
end

def pad(n, str = ' ')
  (0...n).map { str }.to_s
end


rows, rcols = terminal_size
ROWS = rows + 1
COLS = rcols - 3

def draw_frame(&frame)
  cnt = 0
  ROWS.times do
    res = frame.call(cnt).to_s
    size = COLS - res.size 
    cnt = cnt + 1
    puts '|' << res.slice(0...COLS) << pad(size) << '|'
  end

end

FPS = 20

def dot(x)
  if @frame > ROWS
    @frame = 0
  else
    cnt = @frame
  end
  if cnt == x
    return '||'
  else
    return ' '
  end
end


@frame = 0
loop do 
  draw_frame { |x| dot(x).to_s.center(COLS) }
  sleep 0.095
  @frame = @frame + 1
end


