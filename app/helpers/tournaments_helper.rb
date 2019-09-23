module TournamentsHelper
  DIVISION_A_ID = 1
  DIVISION_B_ID = 2

  def get_enemy_match(stage:, team_id:, tournament:)
    team = TeamMatch.where(
      stage:         stage,
      enemy_team_id: team_id,
      tournament:    tournament
    ).first
  end

  def get_current_match(stage:, team_id:, tournament:)
    team = TeamMatch.where(
      stage:      stage,
      team_id:    team_id,
      tournament: tournament
    ).first
  end

  # division: [DIVISION_A_ID, DIVISION_B_ID] - костыль, так как всего ДВА дивизиона
  def not_played?(tournament:, stage:, division: [DIVISION_A_ID, DIVISION_B_ID])
    TournamentStage.where(
      tournament_id: tournament.id,
      title: stage,
      division: division
    ).empty?
  end
end
