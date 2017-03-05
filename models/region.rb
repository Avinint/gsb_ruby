class Region < ActiveRecord::Base

	has_many :departements

	def to_s
 		nom
 	end
end