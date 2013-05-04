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

		new_string.join(' ')

	end
	def capitalize_every_word!()

		self.replace( self.capitalize_every_word() )

	end
end

module Wikipedia

	class Article

		attr_reader :name, :texts, :raw_html

		def initialize( name, raw_html )

			@name, @raw_html, @texts = name, raw_html, []

			Hpricot(raw_html).search('p').each do |ph|

				@texts << Wikipedia::escape_text( ph.inner_text )

			end

		end

		def ambiguous?

			@raw_html.include?('(disambiguation)')

		end

		def inspect()

			"#<Article '#{@name}'>"

		end

	end

	URL = "http://%LANG%.wikipedia.org/w/api.php?action=parse&page="

	def self.article( n, options = {} )

		if !options[:lang]

			options.merge!( :lang => :en )

		end

		# raw_data = open( URL.gsub("%LANG%", options[:lang].to_s)+escape(n) ).read()

		raw_data = open( 'apple.html' ).read()

		return Article.new( n, format( raw_data ) )

	end

	# helpers:

	def self.format(s)

		he = HTMLEntities.new()

		# characters = { Regexp.new("\\[(.*)\\]") => '' }

		s = he.decode( he.decode( s ) ).gsub("\n", "").gsub("\t", "") # >:D

		s
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

require_relative 'opensearch'
