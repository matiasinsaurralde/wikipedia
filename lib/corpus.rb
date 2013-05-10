require 'pp'

require './math'

class String
	def tokenize()
		tokens = {}

		self.downcase!

		splits = self.split(' ')

		splits.each do |s|
			['.', ',', ':', '!', '?', '(', ')', '-', '\'', '"', '[', ']'].each { |char| s.gsub!(char, ' ') }
			s.strip!
		end

		splits.each do |s|
			if !tokens[s]
				tokens.store( s, 0 )
			end
			tokens[s] += 1
		end

		return tokens.percentages!( splits.size )
	end
end

class Corpus
	def initialize( texts )

		@texts, @idf = {}, {}

		texts.each do |label, text|
			@texts.store(label, text.tokenize)
		end

		compute_idf()

	end

	def compute_idf()
		@texts.each do |label, tokens|
			tokens.each do |token, weight|
				if !@idf[token]
					@idf.store( token, 0 )
				end
				@idf[token]+=1
			end
		end

		@idf.less_frequent!

	end

	def classify(given_text, threshold = 1)
		given_text_tokens = {}

		given_text.tokenize().each do |token, weight|
			if @idf[token]
				if @idf[token] <= threshold
					given_text_tokens.store( token, weight )
				end
			end
		end

		@texts.each do |label, tokens|
			tokens.each do |token, weight|
				if @idf[token]
					if @idf[token] > threshold
						tokens.delete(token)
					end
				end
				if !given_text_tokens[token]
					tokens.delete(token)
				end
			end

			given_text_tokens.each do |token, weight|
				if !tokens[token]
					tokens.store(token, 0.0)
				end
			end

			given_text_tokens.sort_please!
			tokens.sort_please!
			

			dot_p = tokens.dot_product(given_text_tokens)

			magnitude_p = Math::magnitude_product( tokens.magnitude, given_text_tokens.magnitude )

			result = Math::similarity( dot_p, magnitude_p )

			pp "#{label}: #{result}, dotp: #{dot_p}, magnitude_p: #{magnitude_p}"

			p tokens
			puts

		end

		
	end

end

corpus = Corpus.new(	:company => File.read('company.txt'),
			:fruit => File.read('fruit.txt') )

corpus.classify('NEW DELHI: After launching a smaller, cheaper version of the popular iPad last year, Apple is looking to up the ante in smartphones too. The world\'s biggest technology company will launch the much-speculated cheaper iPhone this year, according to a report by ETrade Supply. As per a source of ETrade Supply in Foxconn, which manufacturer iPhones, Apple is gearing up to launch a budget smartphone. Last year, ETrade Supply sources had leaked accurate information about upcoming Apple products, including the front panel of iPhone 5.' )
