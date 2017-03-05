require 'bcrypt'
require 'securerandom'

class Utilisateur < ActiveRecord::Base

	belongs_to :commune
	belongs_to :role

    def initialize 
        super
 	end

 	def self.encrypt mdp
 		hash = BCrypt::Password.create(mdp) 
 		hash.gsub!(/^\$2a/, "$2y")
 	end	

 	# convert string into ruby-compatible password object
 	def verify_password
 		# make php passwords compatible with ruby
 		mdp.gsub!(/^\$2y/, "$2a")
 		BCrypt::Password.new (mdp)
 	end

 	def self.generate_token
 		SecureRandom.urlsafe_base64
 	end

 	def remove_token
 		@token = nil
 	end

 	def nom_complet
 		[prenom, nom].reject(&:blank?).map(&:capitalize).join(' ')
 	end

 	def date_embauche format = "%d/%m/%Y"
 		self[:date_embauche].strftime(format)
 	end

 	def to_s
 		nom_complet
 	end

end