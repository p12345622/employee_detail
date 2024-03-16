class Employee < ApplicationRecord
	validates :first_name, :last_name, :email, :phone_numbers, :doj, :salary, presence: true
	
end
