# encoding: utf-8

class String

	def capitalize_every_word()

		new_string = []

		self.split(' ').each do |word|

			chars = word.split(//)

			chars[0].upcase

			new_string << chars.join()

		end

		new_string.join(' ')

	end

	def capitalize_every_word!()

		self.replace( self.capitalize_every_word() )

	end

end


module Wikipedia
	module API
		def self.build_url( params )
			u = "http://#{language().to_s}.wikipedia.org/w/api.php?"

			params.each do |p, v|
				u += "#{p.to_s}=#{v.to_s}"
				u += "&" if p != params.keys.last
			end

			u
		end
		def self.get(u)
			open( u ).read()
		end
		def self.language()
			@language || :en
		end
		def self.language=(lng)
			@language = lng
		end

		def self.extract_data( c, f )
			document, data = REXML::Document.new( c ), {}
			# p c
			case f
				when :xml

					he, text, texts = HTMLEntities.new(), document.elements['api/parse'].first.to_s, []

					raw_html = he.decode( he.decode( text ) ).gsub("\n", "").gsub("\t", "")

					data.merge!( { :raw_html => raw_html, :raw_xml => c } )

					if defined?(Hpricot)
						paragraphs = Hpricot( raw_html ).search('p')
					else
						paragraphs = Nokogiri::HTML( raw_html ).css('p')
					end

					paragraphs.each do |ph|
						texts << escape( ph.inner_text )
					end

					data.store( :texts, texts )

					sections, langlinks, external_links, categories = {}, {}, [], []

					document.elements['api/parse/langlinks'].each do |ll|
						langlinks.store( ll.attributes['lang'].to_sym, ll.attributes['url'] )
					end

					document.elements['api/parse/externallinks'].each do |el|
						external_links << el.get_text()
					end

					document.elements['api/parse/categories'].each do |cat|
						categories << cat.get_text()
					end

					document.elements['api/parse/sections'].each do |sec|
						section = {}
						sec.attributes.each do |k, v|
							section.store( k.to_sym, v )
						end
						sections.store( section[:line], section )
					end

					data.merge!( {	:langlinks => langlinks,
							:external_links => external_links,
							:sections => sections,
							:categories => categories })
			end

			return data
					
		end

		def self.escape(s)
			{ Regexp.new("\\[(.*)\\]") => '' }.each { |str, replace_with| s.gsub!( str, replace_with ) }
			s
		end

		def self.method_missing(m, *args, &block)

			if !args[0][:format]
				args[0].store( :format, :xml )
			end

			if args[0][:page]
				args[0][:page] = Wikipedia::escape( args[0][:page] )
			end

			u = build_url( args[0] )
			response = get( u )
			#response = File.read('apple.xml')

			extract_data( response, args[0][:format] ).merge( :name => args[0][:page] )

		end
	end

	def self.escape(s)
		s.capitalize_every_word!
		CGI.escape( s )
	end

end

#Wikipedia::API::language = :es

#Wikipedia::API.parse :page => 'Skynet', :format => :xml
