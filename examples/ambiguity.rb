#!/usr/bin/env ruby
# encoding: utf-8

require 'wikipedia'

require 'pp'

apple = Wikipedia::article 'apple'

p apple.ambiguous?
