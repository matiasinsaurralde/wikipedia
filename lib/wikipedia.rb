# encoding: utf-8

require 'rubygems'
require 'bundler/setup'

require 'open-uri'
require 'cgi'

require 'htmlentities'
require 'hpricot'

class String
	def capitalize_every_word()
		new_string = []
		self.split(' ').each do |word|
			new_string << word.capitalize
		end
		return new_string.join(' ')
	end
	def capitalize_every_word!()
		self.replace( self.capitalize_every_word() )
	end
end

module Wikipedia

	URL = "http://%LANG%.wikipedia.org/w/api.php?action=parse&page="

	def self.article( n, lang = :en )

		texts = []

		raw_data = open( URL.gsub("%LANG%", lang.to_s)+escape(n) ).read()

		he = HTMLEntities.new()

		# characters = { Regexp.new("\\[(.*)\\]") => '' }

 		raw_data = he.decode( he.decode( raw_data ) ).gsub("\n", "") # >:D

		Hpricot(raw_data).search('p').each do |ph|
			texts << escape_text( ph.inner_text )
		end

		return texts

	end

	def self.escape(s)

		s.capitalize_every_word!

		CGI.escape( s )

	end

	def self.escape_text(s)

		# Hpricot's inner_text() does this already but we don't want the cite-notes stuff: [0], [1], etc.

		{ Regexp.new("\\[(.*)\\]") => '' }.each { |str, replace_with| s.gsub!( str, replace_with ) }

		s

	end
end
