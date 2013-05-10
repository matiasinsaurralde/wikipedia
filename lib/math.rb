# encoding: utf-8

module Math

	def self.dotp(v1, v2)

		dot_product = []

		v1.values.zip(v2.values).each do |p|

			dot_product << ( p[0]*p[1] )

		end

		dot_product.inject(:+)

	end

	def self.magnitude(v)

		m = []

		v.values.each do |n|

			m << n**2

		end

		return m.inject(:+)

	end

	def self.magnitude_product(m1, m2)
		return Math.sqrt( m1 * m2 )
	end

	def self.similarity(dotp, magnitude_p)
		n = (dotp.to_f / magnitude_p.to_f)*100.0
		return n.round(2)
	end

end

class Hash

def percentages!(total, round = 1); self.each {|k,v| self[k] = (v.to_f / total.to_f * 100.0).round( round ) }; end; def most_frequent; return self.sort_by {|k,v| v }.reverse.to_h; end; def less_frequent; return self.sort_by{|k,v| v}.to_h; end; def less_frequent!; self.replace(self.less_frequent); end

def sort_please!()
	self.replace( sort_by {|k,v| k }.to_h )
end

def magnitude()
	Math::magnitude(self)
end

def dot_product( v2 )
	Math::dotp( self, v2 )
end

end

class Array; def to_h; _ = {}; self.each do |n|; _.store( n[0], n[1] ); end; return _; end; end
