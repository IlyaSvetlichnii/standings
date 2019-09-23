class PlayOffService
  def initialize(tournament:)
    @tournament  = tournament
    @division_a  = Division.where(title: "Division A").first
    @division_b  = Division.where(title: "Division B").first

    _best_team_devision_a
    _best_division_b
  end

  def play_off_builder
    _result_quarterfinals
    _result_semifinals
    _result_finals
  end

  private

  def _best_team_devision_a
    tournament_stages_a = TournamentStage.where(
      division_id: @division_a,
      tournament_id: @tournament
    ).order('total_points DESC').first(4)

    team_ids         = tournament_stages_a.pluck(:team_id)
    @best_devision_a = Team.where(id: team_ids)
  end

  def _best_division_b
    # меняю сортировку по очкам что бы лучшая команда из одного дивизиона
    # сыграла c худшей командой из другого дивизиона
    tournament_stages_b = TournamentStage.where(
      division_id: @division_b,
      tournament_id: @tournament
    ).order('total_points ASC').last(4)

    team_ids         = tournament_stages_b.pluck(:team_id)
    @best_devision_b = Team.where(id: team_ids)
  end

  def _result_quarterfinals
    @best_devision_a.zip(@best_devision_b).each do |division_a_team, division_b_team|
      @tournament.team_matchs.create(
        [
          {
            team: division_a_team,
            enemy_team_id: division_b_team.id,
            points: rand(0..20),
            stage: 'quarterfinals'
          },
          {
            team: division_b_team,
            enemy_team_id: division_a_team.id,
            points: rand(0..20),
            stage: 'quarterfinals'
          }
        ]
      )
    end

    @tournament.team_matchs.where(stage: 'quarterfinals').each do |match|
      _determine_winner(match)
    end
  end

  def _result_semifinals
     winner_team_ids = @tournament.tournament_stages.where(
      title: 'quarterfinals',
      result: 'win'
     ).pluck(:team_id)

    first_group  = winner_team_ids.first(2)
    second_group = winner_team_ids.last(2)

    [first_group, second_group].each do |group|
      first_team_id  = group.first
      second_team_id = group.second

      @tournament.team_matchs.create(
        [
          {
            team_id: first_team_id,
            enemy_team_id: second_team_id,
            points: rand(0..20),
            stage: 'semifinals'
          },
          {
            team_id: second_team_id,
            enemy_team_id: first_team_id,
            points: rand(0..20),
            stage: 'semifinals'
          }
        ]
      )
    end

    @tournament.team_matchs.where(stage: 'semifinals').each do |match|
      _determine_winner(match)
    end
  end

  def _result_finals
    winner_team_ids = @tournament.tournament_stages.where(
      title: 'semifinals',
      result: 'win'
     ).pluck(:team_id)

    first_team_id  = winner_team_ids.first
    second_team_id = winner_team_ids.second

    @tournament.team_matchs.create(
      [
        {
          team_id:       first_team_id,
          enemy_team_id: second_team_id,
          points:        rand(0..20),
          stage:         'final'
        },
        {
          team_id:       second_team_id,
          enemy_team_id: first_team_id,
          points:        rand(0..20),
          stage:         'final'
        }
      ]
    )

    @tournament.team_matchs.where(stage: 'final').each do |match|
      _determine_winner(match)
    end
  end

  def _determine_winner(match)
    return nil if _played?(match)

    current_team_points = match.points

    enemy_match = TeamMatch.where(
      stage:      match.stage,
      team_id:    match.enemy_team_id,
      tournament: @tournament.id
    ).first

    first_result, second_result = _match_result(match.points, enemy_match.points)

    TournamentStage.create(
      [
        {
          tournament_id: match.tournament_id,
          title:         match.stage,
          division_id:   match.team.division.id,
          team_id:       match.team_id,
          total_points:  match.points,
          result: first_result
        },
        {
          tournament_id: enemy_match.tournament_id,
          title:         enemy_match.stage,
          division_id:   enemy_match.team.division.id,
          team_id:       enemy_match.team_id,
          total_points:  enemy_match.points,
          result: second_result
        }
      ]
    )
  end

  def _played?(match)
    TournamentStage.where(
      tournament_id: match.tournament_id,
      title:         match.stage,
      team_id:       match.team_id,
    ).present?
  end

  def _match_result(first_team_point, second_team_point)
    if first_team_point > second_team_point
      return 'win', 'leave'
    else
      return 'leave', 'win'
    end
  end
end