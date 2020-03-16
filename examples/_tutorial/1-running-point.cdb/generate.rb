#!/usr/bin/ruby

f = File.open("data.csv","w")

f.puts "ax,ay,FILE_points_my"

def genartefact( i,a,b )
  fn = "files/#{i}.points.csv"
  c = 1
  File.open(fn,"w") do |f|
    f.puts "X,Y,Z"
    f.puts "#{a*c},#{b*c},0"
  end
  fn
end

i=0

for x in 1..5 do
for y in 1..5 do
  sx = x/2.0
  sy = y/2.0
  afname = genartefact( i,sx,sy )
  f.puts "#{sx},#{sy},#{afname}"
  i=i+1
end
end

f.close