class DivisionService
  def initialize(division:, tournament:)
    @division   = division
    @tournament = tournament
    @teams      = @division.teams
  end

  def result_builder
    @teams.each do |current_team|
      _match_result(current_team)
    end
    _match_points
  end

  private

  def _match_result(current_team)
    @teams.each do |enemy|
      next if enemy == current_team || @tournament.team_matchs.where(enemy_team_id: enemy, team_id: current_team).present?

      @tournament.team_matchs.create(
        [
          {
            team: current_team,
            enemy_team_id: enemy.id,
            points: rand(0..10),
            stage: 'division'
          },
          {
            team: enemy,
            enemy_team_id: current_team,
            points: rand(0..10),
            stage: 'division'
          }
        ]
      )
    end
  end

  def _match_points
    result = {}
    @teams.each do |team|
      count = 0
      team.team_matchs.each { |match| count += match.points.to_i}

      result[team.id] = count
    end

    total_points = result.sort_by {|_key, value| value}.to_h

    total_points.each do |team_id, points|
      TournamentStage.create(
        tournament_id: @tournament.id,
        title: 'division',
        division_id: @division.id,
        team_id: team_id,
        total_points: points
      )
    end
  end
end