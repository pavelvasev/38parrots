#!/usr/bin/ruby

f = File.open("data.csv","w")

f.puts "z,FILE_points_my"

def genartefact( i,z )
  fn = "files/#{i}.points.csv"
  c = 1
  a = 100
  b = 100
  r = 1
  
  File.open(fn,"w") do |f|
    f.puts "X,Y,Z"
    
    for zz in 1..z do
    for x in 1..a do
    for y in 1..b do
      rr = Math.sqrt( (x-a/2.0)**2 + (y-b/2.0)**2 + (zz-50)**2 )
      if rr > 0.7 * a/2
        f.puts "#{x*c},#{y*c},#{zz*c}"
      else
      end
    end
    end
    end
  end
  fn
end

i=0

for z in 1..10 do
  rz = z*10
  afname = genartefact( i,rz )
  f.puts "#{rz},#{afname}"
  i=i+1
end

f.close