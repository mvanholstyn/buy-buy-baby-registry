require 'rubygems'
require 'hpricot'
require 'activesupport'
require 'colorized'

table = Hpricot(IO.read(ARGV.shift)).search(".items")
items = table.search("tr").map do |tr|
	[
		tr.search("td:nth-child(8)").text.gsub(/\302|\240|\$/, '').to_f, 
		tr.search("td:nth-child(10) input[@type=text]").first.try(:[], :value).to_f, 
		tr.search("td:nth-child(4) a").text
	]
end

items = items.select do |values|
	values[0] > 0 && values[1]
end

if max_price = ARGV.shift
	items = items.select do |values|
		values[0] < max_price.to_f
	end	
end

sum = items.inject(0) do |s,values|
	puts "#{values[0]} #{values[2]}"; s + (values[0]*values[1])
end

puts "Total #{sum}"