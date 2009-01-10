#!/usr/bin/env ruby

# Prints out the positions at which marks must be made on mount board when mounting a photo of
# a given size with a given border width.

class Size
  attr_accessor :width, :height
  
  def initialize(width, height)
    @width, @height = width, height
  end
end

STANDARD_SIZES = {
  "A4" => Size.new(210, 297),
  "4x6" => Size.new(102, 152),
  "5x7" => Size.new(127, 178),
  "8x10" => Size.new(203, 254),
  "8x12" => Size.new(203, 305)
}

def accumulate(array)
  array.inject([]) do |mem, val|
    mem << (mem.last || 0) + val
    mem
  end
end

print "Enter a WxH size in mm such as '142x204' or one of the standard sizes: #{STANDARD_SIZES.keys.join(", ")}: "
size = gets.chomp

if STANDARD_SIZES.keys.include?(size)
  size = STANDARD_SIZES[size]
else
  size = size.split("x")
  size = Size.new(size[0].to_i, size[1].to_i)
end

print "Enter the border width in mm: "
border_width = gets.chomp.to_i

print "By how many mms should each edge of the photo overlap the mount board? "
overlap = gets.chomp.to_i

horizontal = accumulate([0, border_width, size.width  - (2 * overlap), border_width])
vertical   = accumulate([0, border_width, size.height - (2 * overlap), border_width])

puts
puts "Markings need to be made at the following positions:"
puts "Horizontal edges: " + horizontal.join(", ")
puts "Vertical edges:   " + vertical.join(", ")
