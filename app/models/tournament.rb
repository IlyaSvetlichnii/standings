class Tournament < ApplicationRecord
  has_many :team_matchs
  has_many :tournament_stages
end
