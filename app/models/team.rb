class Team < ApplicationRecord
  belongs_to :division

  has_many :team_matchs
  has_many :tournament_stages
end
