require 'bcrypt'
require 'securerandom'

class Utilisateur < ActiveRecord::Base

	belongs_to :commune
	belongs_to :role
	
	validates :nom, presence: true
	validates :prenom, presence: true
	validates :login, presence: true, uniqueness: true
	validates :email, uniqueness: true
	validates :mdp, length: {in: 4..255}, allow_blank: true
	validates :mdp, presence: true, on: :create

    def initialize hash = nil
        super()
       populate_with_hash hash unless hash.nil?
	end

 	def self.encrypt mdp
 		hash = BCrypt::Password.create(mdp) 
 		hash.gsub!(/^\$2a/, "$2y")
 	end	

 	# convert string into ruby-compatible password object
 	def verify_password
 		# make php passwords compatible with ruby
 		mdp.gsub!(/^\$2y/, "$2a")
 		BCrypt::Password.new(mdp)
 	end

 	def self.generate_token
 		SecureRandom.urlsafe_base64
 	end

 	def remove_token
 		self[:token] = nil
 	end

 	def nom_complet
 		[prenom, nom].reject(&:blank?).map(&:capitalize).join(' ')
 	end

 	def date_embauche format = "%d/%m/%Y"
 		self[:date_embauche].strftime(format) unless self[:date_embauche].blank?
 	end

 	def to_s
 		nom_complet
 	end

 	def is role
 		if role.is_a? Array
 			for r in role
 				return r == self.role.nom
 			end
 		end
 		self.role.nom == role
 	end

 	def is_admin?
 		role.nom == "ROLE_ADMIN"
 	end

 	def is_visiteur?
 		is "ROLE_VISITEUR"
 	end

 	def populate_with_hash hash
 		cp = ""
 		hash.each do |k,v|
 			if k == login
 				self.login = v
			elsif k == 'email'
	 			self.email = v || "#{self.login}@gsb.fr"
	 		elsif k == 'cp'
	 			cp = v
 			elsif k == 'commune'
 				#v = Commune.find_by nom: v, code_postal: cp
 				set_commune v, cp
 			elsif k == 'mdp'
 				v = Utilisateur.encrypt v
 				self.mdp = v
	 		elsif k == 'role'
	 			role = Role.find_by_libelle v
	 			self.role = role
	 		else
		 		public_send("#{k}=",v)
	 		end
 		end
 		self.role_id = 1 unless role_id.present?
 	end

 	def set_commune commune, cp = nil
 		if commune.is_a?(String) && cp.present?
 			commune = Commune.find_by nom: commune, code_postal: cp
 		end
 		return false if !(commune.is_a? Commune)
 		self.commune = commune
 	end

 	def self.unique_values_exist hash
 		Utilisateur.find_by_login(hash['login']) || Utilisateur.find_by_email(hash['email'])
 	end
end