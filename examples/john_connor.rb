#!/usr/bin/env ruby
# encoding: utf-8

require 'wikipedia'

require 'pp'

connor = Wikipedia::article 'John Connor'

pp connor.first	# just the first paragraph
