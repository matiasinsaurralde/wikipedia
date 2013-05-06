# encoding: utf-8

require 'rubygems'
require 'bundler/setup'

require 'rexml/document'
require 'open-uri'
require 'cgi'

require 'htmlentities'
require 'hpricot'

module Wikipedia

	class Article

		attr_reader :name, :data

		def initialize( name, data )

			@name, @data = name, data

		end

		def self.from_api_response(data)

			self.new( data[:name], data )

		end

		def ambiguous?
			@data[ :raw_html ].include?('(disambiguation)')
		end

		def disambiguate( given_text )
			
			Wikipedia::disambiguate( given_text, self )
		end

		def inspect()

			"#<Article '#{@name}'>"

		end

		def method_missing(m, *args, &block)

			@data[ m ]

		end

	end

	def self.article( options  )

		if options.class == String
			options = { :page => options, :action => :parse }
		end

		article = Wikipedia::API.parse options

		return Article.from_api_response( article )

	end

end

require_relative 'api'

require_relative 'ambiguity'

require_relative 'opensearch'
