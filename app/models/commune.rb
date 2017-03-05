class Commune < ActiveRecord::Base

	has_many :utilisateurs
	belongs_to :departement

 	def departement
 		Departement.find_by_code code_postal
 	end

 	def self.options code
 		Commune.pluck :id, :nom
 	end

 	def to_s
 		nom
 	end
end