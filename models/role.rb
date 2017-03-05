class Role < ActiveRecord::Base

	has_many :utilisateurs

 	def to_s
 		libelle
 	end
end