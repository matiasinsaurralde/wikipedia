#!/usr/bin/env ruby
# encoding: utf-8

require 'wikipedia'

connor = Wikipedia::article 'John Connor'

p connor

p connor.texts.first	# just the first paragraph
