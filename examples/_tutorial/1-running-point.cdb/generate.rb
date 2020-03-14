#!/usr/bin/ruby

f = File.open("data.csv","w")

f.puts "ax,ay,FILE_points_my"

def genartefact( i,a,b )
  fn = "files/#{i}.points.csv"
  c = 5
  File.open(fn,"w") do |f|
    f.puts "X,Y,Z"
    f.puts "#{a*c},#{b*c},0"
  end
  fn
end

i=0

for x in 1..5 do
for y in 1..5 do
  afname = genartefact( i,x,y )
  f.puts "#{x},#{y},#{afname}"
  i=i+1
end
end

f.close