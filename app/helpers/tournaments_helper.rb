module TournamentsHelper
  def get_enemy_match(stage:, team_id:)
    team = TeamMatch.where(
      stage: stage,
      enemy_team_id: team_id
    ).first
  end

  def get_current_match(stage:, team_id:)
    team = TeamMatch.where(
      stage: stage,
      team_id: team_id
    ).first
  end
end
