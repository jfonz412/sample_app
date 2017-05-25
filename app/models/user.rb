class User < ApplicationRecord
	validates(:name, presence: true, length:{ maximum: 50 }) # parentheses not necessary
	validates :email, presence: true, length:{ maximum: 245 }
end
