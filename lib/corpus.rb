require 'pp'

require './math'

class Hash
	def common_with( tokens )

		tokens.each do |token, weight|
			if !self[token]
				self[token] = 0.0
			end
		end

		self.each do |token, weight|
			if !tokens[token]
				self.delete(token)
			end
		end

		self
	end
end

class Corpus

	attr_accessor :texts
	attr_reader :tokens

	def initialize()
		@texts, @tokens = [], {}
	end

	def compute_document_freq()
		@texts.each do |text|
			text.tokens.each do |token|
				if !@tokens[token]
					@tokens.store( token, 0 )
				end
				@tokens[token] += 1
			end
		end
		@tokens.less_frequent!.percentages!( @texts.size )
	end

	def classify(input)

		given_text = Text.new( input )

		@texts.each do |text|

			puts text.name

			common_tokens = text.tokens.common_with( given_text.tokens )

			dot_product = common_tokens.dot_product( given_text.tokens )

			magnitude_product = Math::magnitude_product( common_tokens.magnitude, given_text.tokens.magnitude )

			distance = Math::similarity( dot_product, magnitude_product )

			puts "similarity: #{distance}, dotp: #{dot_product}, magnitude_p: #{magnitude_product}"

			
		end


	end

	def <<(text)
		@texts.push(text)
	end

end

class String
	def cleanup!
		self.downcase!
		['.', ',', ':', '!', '?', '(', ')', '-', '\'', '"', '[', ']'].each { |char| self.gsub!(char, ' ') }
		self.strip!
		return self
	end
end

class Text

	attr_reader :name

	def initialize( body, name = '' )
		@body, @name = body.cleanup!, name
		@tokens = tokenize()
	end

	def tokenize()

		tokens, splits = {}, @body.split(' ')

		splits.each do |token|
			token.downcase!
			if !tokens[ token ]
				tokens.store( token, 0 )
			end

			tokens[token] += 1
		end

		tokens.most_frequent.percentages!( splits.size )

	end

	def tokens( filter = nil )
		if filter
		else
			@tokens
		end
	end

	def self.from_plain_text( s, title )
		return Text.new( s, title )
	end
end

corpus = Corpus.new()

Dir['*.txt'].each do |f|
	corpus << Text.from_plain_text( File.read(f), f.gsub('.txt', '') )
end

corpus.compute_document_freq()

corpus.classify('NEW DELHI: After launching a smaller, cheaper version of the popular iPad last year, Apple is looking to up the ante in smartphones too. The world\'s biggest technology company will launch the much-speculated cheaper iPhone this year, according to a report by ETrade Supply. As per a source of ETrade Supply in Foxconn, which manufacturer iPhones, Apple is gearing up to launch a budget smartphone. Last year, ETrade Supply sources had leaked accurate information about upcoming Apple products, including the front panel of iPhone 5.')
