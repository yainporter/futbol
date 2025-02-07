require 'spec_helper'

RSpec.describe StatTracker do
  before(:each) do
    @game_path = './data/games_subset.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams_subset.csv'

    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(@locations)
  end

  it 'exists' do

    expect(@stat_tracker).to be_a StatTracker
  end

  it "can create a new instance of StatTracker with an Array of GameTeams, Games, and Teams" do

    expect(StatTracker.from_csv(@locations)).to be_a StatTracker
    expect(StatTracker.from_csv(@locations).game_teams).to be_a Array
    expect(StatTracker.from_csv(@locations).games).to be_a Array
    expect(StatTracker.from_csv(@locations).teams).to be_a Array

    StatTracker.from_csv(@locations).game_teams.each do |game_team|
      expect(game_team).to be_a GameTeams
    end

    StatTracker.from_csv(@locations).games.each do |game|
      expect(game).to be_a Game
    end

    StatTracker.from_csv(@locations).teams.each do |team|
      expect(team).to be_a Teams
    end
  end

  it "has a highest total points for a game" do

    expect(@stat_tracker.highest_total_score).to eq(5)
  end

  it 'has a lowest total points for a game' do

    expect(@stat_tracker.lowest_total_score).to eq(1)
  end

  it 'has a method to return percentage of home win games' do

    expect(@stat_tracker.percentage_home_wins).to eq(0.6)
  end

  it 'has a method to return percentage of visitor win games' do

    expect(@stat_tracker.percentage_visitor_wins).to eq(0.4)
  end

  it 'has a method to return percentage of tie games' do

    expect(@stat_tracker.percentage_ties).to eq(0.0)
  end

  it 'returns a hash where the keys are seasons and the values are the count of games' do

    expect(@stat_tracker.count_of_games_by_season).to be_a Hash
    expect(@stat_tracker.count_of_games_by_season).to eq({"20122013"=>19})
  end

  it "can find the average goals of all games" do

    expect(@stat_tracker.average_goals_per_game).to eq(3.68)
  end

  it "can return a Hash where seasons are keys and average goals are values" do

    expect(@stat_tracker.average_goals_by_season).to be_a Hash
    expect(@stat_tracker.average_goals_by_season).to eq("20122013" => 3.68)
  end

  it "can count the total number of teams in the data and return an Integer" do

    expect(@stat_tracker.count_of_teams).to be_a Integer
    expect(@stat_tracker.count_of_teams).to eq 32
  end

  it "can find team name by team_id" do

    expect(@stat_tracker.find_team_name("14")).to eq("DC United")
    expect(@stat_tracker.find_team_name("17")).to eq("LA Galaxy")
  end

  it "can return an array of total average number of goals scored across all seasons per team" do

    expected = [["5", 0.5],
                ["16", 1.4286],
                ["3", 1.6],
                ["17", 1.8571],
                ["8", 2.0],
                ["9", 2.3333],
                ["6", 2.6667]]

    expect(@stat_tracker.average_score_by_team).to eq expected
  end

  it "can return team with the highest average number of goals scored per game across all seasons" do

    expect(@stat_tracker.best_offense).to eq("FC Dallas")
  end

  it "can return team with the lowest average number of goals scored per game across all seasons" do

    expect(@stat_tracker.worst_offense).to eq("Sporting Kansas City")
  end

  it "can return a String of the team with the lowest average score per game across all seasons when they are a visitor" do

    expect(@stat_tracker.lowest_scoring_visitor).to be_a String
    expect(@stat_tracker.lowest_scoring_visitor).to eq("Sporting Kansas City")
  end

  it "can return a String of the team with the lowest average score per game across all seasons when they are at home" do

    expect(@stat_tracker.lowest_scoring_home_team).to be_a String
    expect(@stat_tracker.lowest_scoring_home_team).to eq ("Sporting Kansas City")
  end

  it "can return a String of the team with the highest average score per game across all seasons when they are a visitor" do

    expect(@stat_tracker.highest_scoring_visitor).to be_a String
    expect(@stat_tracker.highest_scoring_visitor).to eq("Houston Dynamo")
  end

  it "can return a String of the team with the highest average score per game across all seasons when they are at home" do

    expect(@stat_tracker.highest_scoring_home_team).to be_a String
    expect(@stat_tracker.highest_scoring_home_team).to eq ("FC Dallas")
  end

  it "can return the coach with highest winning percentage for a season" do
    @game_path = './data/games.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams.csv'

    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(@locations)

    expect(@stat_tracker.winningest_coach('20122013')).to be_a String
    expect(@stat_tracker.winningest_coach('20122013')).to eq("Claude Julien").or(eq("Joel Quenneville"))
  end

  it "can return the coach with the worst win percentage for the season" do
    @game_path = './data/games.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams.csv'

    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(@locations)

    expect(@stat_tracker.worst_coach('20122013')).to be_a String
    expect(@stat_tracker.worst_coach('20122013')).to eq("Martin Raymond")
  end

  it 'can return the name of the Team with the most tackles in a season' do

    expect(@stat_tracker.most_tackles("20122013")).to be_a String
    expect(@stat_tracker.most_tackles("20122013")).to eq("FC Dallas")
  end

  it 'can return the name of the Team with the fewest tackles in a season' do

    expect(@stat_tracker.fewest_tackles("20122013")).to be_a String
    expect(@stat_tracker.fewest_tackles("20122013")).to eq("New England Revolution")
  end

  it "has a most_accurate_team method" do

    @game_path = './data/games.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams.csv'

    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(@locations)

    expect(@stat_tracker.team_id_name_hash_creation).to be_a Hash
    expect(@stat_tracker.team_id_name_hash_creation["10"]).to eq("North Carolina Courage")
    expect(@stat_tracker.team_id_name_hash_creation["6"]).to eq("FC Dallas")

    expect(@stat_tracker.games_in_each_season).to be_a Hash
    expect(@stat_tracker.games_in_each_season["20122013"]).to be_an Array
    expect(@stat_tracker.games_in_each_season["20122013"].first).to eq("2012030221")

    expect(@stat_tracker.team_goal_percentage_hash("20122013")).to be_a Hash
    expect(@stat_tracker.team_goal_percentage_hash("20122013")["FC Cincinnati"]).to eq(0.29844)
    expect(@stat_tracker.team_goal_percentage_hash("20142015")).to be_a Hash
    expect(@stat_tracker.team_goal_percentage_hash("20142015")["Houston Dynamo"]).to eq(0.29349)

    expect(@stat_tracker.most_accurate_team("20132014")).to eq("Real Salt Lake")
    expect(@stat_tracker.most_accurate_team("20142015")).to eq("Toronto FC")

    expect(@stat_tracker.least_accurate_team("20132014")).to eq("New York City FC")
    expect(@stat_tracker.least_accurate_team("20142015")).to eq("Columbus Crew SC")

  end

end
