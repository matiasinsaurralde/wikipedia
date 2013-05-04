# encoding: utf-8

require 'rubygems'
require 'bundler/setup'

require 'open-uri'
require 'htmlentities'
require 'hpricot'

module Wikipedia

	URL = "http://%LANG%.wikipedia.org/w/api.php?action=parse&page="

	def self.article( n, lang = :es )

		texts = []

		raw_data = open( URL.gsub("%LANG%", lang.to_s)+n ).read()
		#raw_data = File.read('pareidolia').gsub("\n", "")

		he = HTMLEntities.new()

		# characters = { Regexp.new("\\[(.*)\\]") => '' }

 		raw_data = he.decode( he.decode( raw_data ) ).gsub("\n", "") # >:D

		Hpricot(raw_data).search('p').each do |ph|
			texts << ph.inner_text
		end

		return texts

	end
end
