# encoding: utf-8

module Wikipedia

	def self.disambiguate( given_text, ambiguous_article )

		reference, section_articles, other_articles = {}, {}, {}

		# extract toc and term information, load each article.

		puts "given text: #{given_text}"
		puts "ambiguous article: #{ambiguous_article.inspect}"
		puts

		ambiguous_article.sections.to_a[0, ambiguous_article.sections.size-1].each do |section|
			reference.store( section.first, section.last[ :anchor ] )
		end

		content_splits = ambiguous_article.raw_html.split("\"mw-headline\"")
		content = content_splits[1, content_splits.size-2]

		content.each do |mw|

			the_section = reference.keys[ content.index(mw) ]

			section_articles.store( the_section, {} )

			mw = "<span class=\"mw-headline\"#{mw}"

			Hpricot( mw ).search('li').each do |li|

				li.search('a').each do |a|

					href = a.attributes['href']

					if !href.include?('index.php') and !href.include?('(disambiguation)')	# we don't want the disambiguation of the disambiguation!
						section_articles[ the_section ].store( a.inner_text, { :link => href.split('/').last, :phrase => li.inner_text  } )
					end
				end

				#puts
			end
		end

		# get articles
		section_articles.each do |section, articles|
			puts "*** #{section}"
			articles.each do |article_name, data|
				puts "#{article_name}: \"#{data[:phrase]}\""
				a = Wikipedia::article(article_name.dup)
				puts a.texts
				puts
			end
			puts
		end

	end

end
