# encoding: utf-8

module Wikipedia

	class Text
	end

	def self.disambiguate( given_text, ambiguous_article )

		reference, section_articles = {}, {}

		# extract toc and term information, load each article.

		puts "given text: #{given_text}"
		puts "ambiguous article: #{ambiguous_article.inspect}"

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
						section_articles[ the_section ].store( a.inner_text, { :link => href, :phrase => li.inner_text  } )
						#puts href
					end
				end

				#puts
			end
		end

		pp section_articles

	end

end
