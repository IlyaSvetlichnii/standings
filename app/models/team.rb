class Team < ApplicationRecord
  belongs_to :division

  has_many :team_matchs
end
