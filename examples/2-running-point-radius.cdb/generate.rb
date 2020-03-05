#!/usr/bin/ruby

f = File.open("data.csv","w")

f.puts "ax,ay,r,FILE_points_my"

def genartefact( i,a,b,r )
  fn = "files/#{i}.points.csv"
  c = 5
  File.open(fn,"w") do |f|
    f.puts "X,Y,Z,RADIUS"
    f.puts "#{a*c},#{b*c},1,#{r}"
  end
  fn
end

i=0

for r in 1..2
for x in 1..3 do
for y in 1..3 do
  afname = genartefact( i,x,y,r )
  f.puts "#{x},#{y},#{r},#{afname}"
  i=i+1
end
end
end

f.close