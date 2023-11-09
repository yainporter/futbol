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

  it "can create a new instance of StatTracker with data" do
    expect(StatTracker.from_csv(@locations)).to be_a StatTracker
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
end
