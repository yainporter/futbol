require 'csv'
require_relative './game'
require_relative './teams'
require_relative './game_teams'

class StatTracker
  attr_reader :game_teams

  def initialize
    @games = @@games
    @teams = @@teams
    @game_teams = @@game_teams
  end

  def self.from_csv(locations)
    @@games = Game.create_games(locations[:games])
    @@teams = Teams.create_teams(locations[:teams])
    @@game_teams = GameTeams.create_game_teams(locations[:game_teams])

    stat_tracker = StatTracker.new
  end

  def highest_total_score
    most_goals = @games.max_by{|game| game.home_goals + game.away_goals}
    most_goals = most_goals.home_goals + most_goals.away_goals
  end

  def lowest_total_score
    fewest_goals = @games.map{|game| game.home_goals + game.away_goals}
    fewest_goals = fewest_goals.min
  end

  def percentage_home_wins
    home_win_count = @game_teams.count do |game|
      game.hoa == "home" && game.result == "WIN"
    end
    home_win_count.fdiv(@game_teams.count / 2).round(2)
  end

  def percentage_visitor_wins
    visitor_win_count = @game_teams.count do |game|
      game.hoa == "away" && game.result == "WIN"
    end
    visitor_win_count.fdiv(@game_teams.count / 2).round(2)
  end

  def percentage_ties
    tie_count = @game_teams.count do |game|
      game.hoa == "away" && game.result == "TIE"
    end
    tie_count.fdiv(@game_teams.count / 2).round(2)
  end

  def count_of_games_by_season
    season_game_count = Hash.new(0)
    @games.each do |game|
      season_game_count[game.season] += 1
    end
    season_game_count
  end

  def average_goals_per_game
    games = @games.sum do |game|
      game.home_goals + game.away_goals
    end
    games.fdiv(@games.count).round(2)
  end

  def average_goals_by_season
    average_goals_hash = Hash.new(0)
    count_of_games_by_season.each do |season, game_count|
      @games.each do |game|
        average_goals_hash[season] += total_goals(game) if game.season == season
      end
    average_goals_hash[season] = average_goals_hash[season].fdiv(game_count).round(2)
    end
  average_goals_hash
  end

  def count_of_teams
    @teams.count
  end

  def lowest_scoring_visitor
    find_team(:away, "min")
  end

  def lowest_scoring_home_team
    find_team(:home, "min")
  end

  def highest_scoring_visitor
    find_team(:away, "max")
  end

  def highest_scoring_home_team
    find_team(:home, "max")
  end

  private

  def total_goals(game)
    game.home_goals + game.away_goals
  end

  def teams_total_scores
    team_total_scores_home = Hash.new(0)
    team_total_scores_away = Hash.new(0)
    @game_teams.each do |game_team|
      if game_team.hoa == "away"
        team_total_scores_away[game_team.team_id] += game_team.goals
      else
        team_total_scores_home[game_team.team_id] += game_team.goals
      end
    end
    team_total_scores = {
      home: team_total_scores_home,
      away: team_total_scores_away
    }
  end

  def teams_total_games
    team_total_games_home = Hash.new(0)
    team_total_games_away = Hash.new(0)
    @game_teams.each do |game_team|
      if game_team.hoa == "away"
        team_total_games_home[game_team.team_id] += 1
      else
        team_total_games_away[game_team.team_id] += 1
      end
    end
    team_total_games = {
      home: team_total_games_home,
      away: team_total_games_away
    }
  end

  def teams_average_score
    teams_average_score_home = Hash.new(0)
    teams_average_score_away = Hash.new(0)
    teams_total_scores.each do |scores_hoa, hoa_scores|
      teams_total_games.each do |games_hoa, hoa_games|
          hoa_scores.each do |scores_team_id, scores|
            hoa_games.each do |games_team_id, games|
              if scores_team_id == games_team_id && scores_hoa == games_hoa && scores_hoa == :home
                teams_average_score_home[scores_team_id] = scores.fdiv(games).round(2)
              elsif scores_team_id == games_team_id && scores_hoa == games_hoa && scores_hoa == :away
                teams_average_score_away[scores_team_id] = scores.fdiv(games).round(2)
              else
                "ERROR"
              end
            end
          end
        end
      end
    teams_average_score = {
      home: teams_average_score_home,
      away: teams_average_score_away
    }
  end

  def find_team(hoa, max_or_min)
    team = nil
    teams_average_score.each do |home_or_away, scores|
      if hoa == :home && max_or_min == "max" && home_or_away == :home
        team = scores.max_by{|team_id, score| score}
      elsif hoa == :home && max_or_min == "min" && home_or_away == :home
        team = scores.min_by{|team_id, score| score}
      elsif hoa == :away && max_or_min == "max" && home_or_away == :away
        team = scores.max_by{|team_id, score| score}
      elsif hoa == :away && max_or_min == "min" && home_or_away == :away
        team = scores.min_by{|team_id, score| score}
      else
        "ERROR"
      end
    end
    team_object_name = @teams.select{|team_object| team_object.team_id == team.first}
    team_object_name.pop.team_name
  end
end
