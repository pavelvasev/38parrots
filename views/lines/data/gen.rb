puts "X,Y,Z,X1,Y1,Z1,RADIUS,R,G,B,R2,G2,B2"
i = 0
while i < 360 do
  a = 2* i * Math::PI / 360.0
  r = 10
  x = r*Math.cos(a)
  y = r*Math.sin(a)
  cr = i/360.0
  cg = 1.0-cr
  puts "#{x},#{y},0, 0,0,0, #{i/36.0}, #{cr},#{cg},0,#{cr},0,#{cg}"
  i=i+5
end