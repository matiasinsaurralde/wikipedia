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
