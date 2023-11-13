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

  def team_id_name_hash_creation
    #returns a hash with keys of team_id and values of corresponding team names
    team_name_hash = Hash.new(0)
    @teams.each do |team|
      team_name_hash[team.team_id] = team.team_name
    end
    team_name_hash
  end
  
  def games_in_each_season
    #returns a hash with keys of season_id and values as an array of game_ids
    games_in_season_hash = {}
    @games.each do |game|
      if !games_in_season_hash[game.season]
        games_in_season_hash[game.season] = []
        games_in_season_hash[game.season] << game.game_id
      else 
        games_in_season_hash[game.season].push(game.game_id)
      end
    end
    games_in_season_hash
  end
  
  def team_goal_percentage_hash(season)
    #returns a hash with keys of team names (as strings) and values of "goal/shot percentage" for a given season
    games_in_season_hash = games_in_each_season
    team_name_hash = team_id_name_hash_creation
    shots_goals_by_team_name_hash = {}
  
    games_in_season_hash[season].each do |game_id|
      @game_teams.each do |game_team|
        if game_id == game_team.game_id
          name_1 = game_team.team_id
          team_name_hash.each do |id, name|
            if name_1 == id
              name_1 = name
              if !shots_goals_by_team_name_hash[name_1]
                shots_goals_by_team_name_hash[name_1] = {goals: game_team.goals, shots: game_team.shots}
              else
                shots_goals_by_team_name_hash[name_1][:goals] += game_team.goals
                shots_goals_by_team_name_hash[name_1][:shots] += game_team.shots
              end
            end
          end
        end
      end
    end
    shots_goals_by_team_name_hash.each do |name, shots_goals|
      shots_goals_by_team_name_hash[name] = shots_goals[:goals].fdiv(shots_goals[:shots]).round(5)
    end
    shots_goals_by_team_name_hash
  end
  
  def most_accurate_team(season)
    shots_goals_by_team_name_hash = team_goal_percentage_hash(season)
    max_team_and_percentage_array = shots_goals_by_team_name_hash.max_by do |name, percentage|
      percentage
    end
    max_team_and_percentage_array.shift
  end
  
  def least_accurate_team(season)
    shots_goals_by_team_name_hash = team_goal_percentage_hash(season)
    min_team_and_percentage_array = shots_goals_by_team_name_hash.min_by do |name, percentage|
      percentage
    end
    min_team_and_percentage_array.shift
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


