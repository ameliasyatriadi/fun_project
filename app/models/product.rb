class Product < ApplicationRecord
    validates :upc_code, presence: true, uniqueness: true
end
