class Division < ApplicationRecord
  has_many :teams
  has_many :tournament_stages
end
