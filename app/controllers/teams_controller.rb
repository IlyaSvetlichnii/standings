class TeamsController < ApplicationController
  def new
    @team = Team.new
  end

  def create
    team = Team.new(team_params)

    if team.save
      redirect_to root_path
    else
      #TODO если будет время, добавить обработчик ошибок
      # вывести говорящее сообщение
      redirect_to root_path
    end
  end

  private

  def team_params
    params.require(:team).permit(:title, :division_id)
  end
end
