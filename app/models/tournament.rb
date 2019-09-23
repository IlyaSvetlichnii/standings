class Tournament < ApplicationRecord
  has_many :team_matchs, dependent: :delete_all
  has_many :tournament_stages, dependent: :delete_all
end
