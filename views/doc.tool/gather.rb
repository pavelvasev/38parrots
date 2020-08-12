#puts "# 3d artefacts"

puts File.readlines( "preface.md" )

Dir[ File.join(ENV["VIEWS_DIR"],"**/readme.md")].sort.each do |fn|
  t = File.readlines( fn )
  puts t
  puts ""
end