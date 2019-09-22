module TournamentsHelper
  def get_enemy(stage:, team_id:)
    team = TeamMatch.where(
      stage: stage,
      enemy_team_id: team_id
    ).first.team

    team.tournament_stages.where(
      title: "quarterfinals"
    ).first
  end
end
