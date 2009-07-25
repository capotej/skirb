TIOCGWINSZ = 0x5413                  # For an Intel processor

def terminal_size
  rows, cols = 25, 80
  buf = [ 0, 0, 0, 0 ].pack("SSSS")
  if STDOUT.ioctl(TIOCGWINSZ, buf) >= 0 then
    rows, cols, row_pixels, col_pixels = buf.unpack("SSSS")[0..1]
  end
  return rows, cols
end

ROWS, COLS = terminal_size

puts ROWS
puts COLS - 3

def draw_frame(&frame)
  cols = COLS - 3
  cnt = 0
  ROWS.times do
    res = frame.call(cnt)
    size = cols - res.size 
    cnt =+ 1
    puts '|' << res.slice(0...cols) << (0...size).map { ' ' }.to_s << '|'
  end
end

FPS = 20

loop do 
  draw_frame { |x| 'x' }
  sleep FPS / 60 / 2
  draw_frame { |x| ' ' }
end


