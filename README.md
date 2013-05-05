# wikipedia

tool for extracting plain text from wikipedia articles

## Installing:

a gem is available, so fire up your terminal:

````
$ gem install wikipedia
````

## Usage:

it's easy:

````ruby
irb(main):001:0* require 'wikipedia'
irb(main):002:0>
irb(main):003:0* require 'pp'
irb(main):004:0>
irb(main):008:0* connor = Wikipedia::article 'John Connor'
irb(main):009:0* pp connor.first     # just the first paragraph
"John Connor is a fictional character and the main protagonist of the Terminator franchise.
Created by writer and director James Cameron, the character is first referred to in the 1984 film The Terminator 
and first appears, portrayed by teenage actor Edward Furlong, in its 1991 sequel Terminator 2: Judgment Day.
The character is subsequently portrayed by 23-year-old Nick Stahl in the 2003 film Terminator 3: Rise of the Machines
and by 19-year-old Thomas Dekker in the 2007 television series Terminator: The Sarah Connor Chronicles.
English actor Christian Bale portrays Connor in the film series' fourth installment, Terminator Salvation."
````

There's a simple method for checking term's ambiguity, an array of those other terms will be provided in the future.

A good example is 'apple' which may refer to the company, to the fruit, etc.

````ruby
irb(main):001:0> require 'wikipedia'
irb(main):002:0> apple = Wikipedia::article 'apple'
irb(main):003:0> apple.ambiguous?
=> true
irb(main):004:0>
````

## TODO

* Integrate it with the [Opensearch API] (http://www.mediawiki.org/wiki/API%3aOpensearch).
* Switch to Nokogiri or provide support for both Nokogiri and Hpricot?

## Disclaimer

[Hpricot] (https://github.com/whymirror/hpricot) was used as a tribute to [whytheluckystiff] (http://en.wikipedia.org/wiki/Why_the_lucky_stiff).
