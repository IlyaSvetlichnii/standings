class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.all
  end

  def new
    @tournament = Tournament.new
  end

  def create
  end

  def show
    @tournament      = Tournament.find(params[:format])

    # Divisions
    @division_a      = Division.where(title: "Division A").first
    @division_b      = Division.where(title: "Division B").first
    @tournament_stages_a = TournamentStage.where(
      title: 'division',
      division_id: @division_a,
      tournament_id: @tournament
    ).order('total_points DESC').first(8)

    @tournament_stages_b = TournamentStage.where(
      title: 'division',
      division_id: @division_b,
      tournament_id: @tournament
    ).order('total_points DESC').first(8)

    # Play-Off
    @quarterfinals = TournamentStage.where(
      title: 'quarterfinals',
      result: 'win',
      tournament_id: @tournament
    ).first(4)

    @semifinals = TournamentStage.where(
      title: 'semifinals',
      tournament_id: @tournament,
      result: 'win'
    ).first(2)

    @final = TournamentStage.where(
      title: 'final',
      tournament_id: @tournament,
      result: 'win'
    )
  end

  def division_result
    @tournament = Tournament.find(params[:tournament_id])
    @division   = Division.find(params[:division_id])

    DivisionService.new(
      division:   @division,
      tournament: @tournament
    ).result_builder

    redirect_to tournaments_show_path(@tournament.id)
  end

  def play_off_result
    @tournament = Tournament.find(params[:tournament_id])

    PlayOffService.new(
      tournament: @tournament
    ).play_off_builder

    redirect_to tournaments_show_path(@tournament.id)
  end
end
