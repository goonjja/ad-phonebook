# Small description:
# This script generates 2 files in output directory.
# 1. phonebook.xml
# 2. phonebook_s.xml
# After this duplicates stylesheets to this folder.
########################
# If OU contains contact with description='fax' then this contact
# will be displayed as one line in department block
# with name=firstname and value = telephoneNumber
# TODO: ordering of departments and job titles

require 'brain'
require 'ftools'

puts "Parsing started...connecting"
hash = make_search
dir = Dir.getwd
begin
  Dir.chdir $config[:output]
rescue
  Dir.mkdir $config[:output]
end
Dir.chdir dir
File.copy 'phonebook.xsl',"#{$config[:output]}" unless File.exist? "#{$config[:output]}/phonebook.xsl"
File.copy 'phonebook_p.xsl',"#{$config[:output]}" unless File.exist? "#{$config[:output]}/phonebook_p.xsl"
File.copy 'style.css',"#{$config[:output]}" unless File.exist? "#{$config[:output]}/style.css"
File.copy 'printstyle.css',"#{$config[:output]}" unless File.exist? "#{$config[:output]}/printstyle.css"

File.delete "#{$config[:output]}/phonebook.xml" if File.exist? "#{$config[:output]}/phonebook.xml"
File.delete "#{$config[:output]}/phonebook_p.xml" if File.exist? "#{$config[:output]}/phonebook_p.xml"
save_xml hash, "#{$config[:output]}/phonebook.xml", "phonebook.xsl"
save_xml hash, "#{$config[:output]}/phonebook_p.xml", "phonebook_p.xsl"
puts 'Parsing finished'