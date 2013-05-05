#!/usr/bin/env ruby
# encoding: utf-8

require 'wikipedia'

apple = Wikipedia::article 'apple'

p apple.ambiguous?

os = Wikipedia::article 'operating system'

p os.ambiguous?
