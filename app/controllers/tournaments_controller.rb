class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.all
    @teams       = Team.all
  end

  def new
    @tournament = Tournament.new
  end

  def create
    tournament = Tournament.new(tournament_params)

    if tournament.save
      redirect_to root_path
    else
      #TODO если будет время, добавить обработчик ошибок
      # вывести говорящее сообщение
      redirect_to root_path
    end
  end

  def destroy
    tournament = Tournament.find(params[:format])
    tournament.destroy

    redirect_to root_path
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

  private

  def tournament_params
    params.require(:tournament).permit(:title, :description)
  end
end
