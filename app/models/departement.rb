class Departement < ActiveRecord::Base
	
	has_many :communes
	belongs_to :region

 	def find_by_code_postal code
 		Departement.find code.slice(0, 2)	
	end

 	def self.options code
 		Departement.pluck :id, :nom
 	end

 	def to_s
 		nom
 	end
end