puts "X,Y,Z,X2,Y2,Z2,RADIUS"
i = 0
while i < 360 do
  a = 2* i * Math::PI / 360.0
  r = 10
  x = r*Math.cos(a)
  y = r*Math.sin(a)
  cr = i/360.0
  cg = 1.0-cr
  puts "#{x},#{y},0, 0,0,#{i/18.0}, 2"
  i=i+5
end