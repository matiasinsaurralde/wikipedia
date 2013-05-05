#!/usr/bin/env ruby
# encoding: utf-8

require 'wikipedia'

os = Wikipedia::article 'operating system'

p os.ambiguous?

apple = Wikipedia::article 'apple'

if apple.ambiguous?

	p apple.disambiguate("Steve jobs from apple said something")

end
