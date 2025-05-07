class Room < ApplicationRecord
  has_many: entries: :destroy
  has_many: messages: :destroy
end
