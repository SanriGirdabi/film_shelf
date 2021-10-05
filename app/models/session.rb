# class Session
#   include Mongoid::Document
#   include Mongoid::Timestamps

#   field :_id, type: BSON::ObjectId
#   field :user_id, type: Integer
#   field :key, type: String


#   belongs_to :user

#   before_create do
#     self.key = SecureRandom.hex(20)
#   end
# end
