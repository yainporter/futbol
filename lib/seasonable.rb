module Seasonable

  def winningest_coach(season)
    game_id_list = []
    game_list = []
    @games.each do |game|
      game_id_list << game.game_id if game.season == season
    end
    @game_teams.each do |game|
      game_list << game if game_id_list.include?(game.game_id)
    end
    coach_win_hash = Hash. new(0)
    games_total_by_coach = Hash.new(0)
    coach_win_percentage = Hash.new(0.0)
    winner = nil
    game_list.each do |game|
      coach_win_hash[game.head_coach] += 1 if game.result == 'WIN'
    end
    game_list.each do |game|
      games_total_by_coach[game.head_coach] += 1 if game.result != nil
    end
    games_total_by_coach.each do |coach, games|
      coach_win_hash.each do |c, w|
        coach_win_percentage[c] = w.fdiv(games).round(2) if coach == c
      end
    end
    coach_win_hash.select do |coach, wins|
      winner = coach if coach_win_hash[coach] == coach_win_hash.values.max
    end
    winner #get working with all seasons
  end

  def worst_coach(season)
    game_id_list = []
    game_list = []
    @games.each do |game|
      game_id_list << game.game_id if game.season == season
    end
    @game_teams.each do |game|
      game_list << game if game_id_list.include?(game.game_id)
    end
    coach_win_hash = Hash. new(0)
    games_total_by_coach = Hash.new(0)
    coach_win_percentage = Hash.new(0.0)
    loser = nil
    game_list.each do |game|
      coach_win_hash[game.head_coach] += 1 if game.result == 'LOSS'
    end
    game_list.each do |game|
      games_total_by_coach[game.head_coach] += 1 if game.result != nil
    end
    games_total_by_coach.each do |coach, games|
      coach_win_hash.each do |c, g|
        coach_win_percentage[c] = g.fdiv(games).round(2) if coach == c
      end
    end
    coach_win_hash.select do |coach, wins|
      loser = coach if coach_win_hash[coach] == coach_win_hash.values.min
    end
    loser
  end

  def most_tackles(season)
    teams_most_or_least_tackles(season, "max")
  end

  def fewest_tackles(season)
    teams_most_or_least_tackles(season, "min")

  end

  private

  def teams_total_tackles(season)
    team_total_tackles = Hash.new(0)
    @game_teams.each do |game_team|
      @games.each do |game|
        if game.game_id == game_team.game_id && game.season == season
          team_total_tackles[game_team.team_id] += game_team.tackles
        end
      end
    end
    team_total_tackles
  end

  def teams_most_or_least_tackles(season, max_or_min)
    team = nil
    if max_or_min == "max"
      team = teams_total_tackles(season).max_by{|team, tackles| tackles}
    else
      team = teams_total_tackles(season).min_by{|team, tackles| tackles}
    end
    @teams.select{|teams| teams.team_id == team.first}.pop.team_name
  end
end
