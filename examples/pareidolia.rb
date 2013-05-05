#!/usr/bin/env ruby
# encoding: utf-8

require 'wikipedia'

# changing default language
Wikipedia::API::language = :es

Wikipedia::article 'Pareidolia'
