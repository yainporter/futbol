require 'spec_helper'

RSpec.describe Teams do
  it "exists" do
    expect(teams = Teams.new("Rabbits","20122013")).to be_a Teams
  end

  it "has instance variables" do
    teams = Teams.new("Rabbits","20122013")
    expect(teams.team_name).to eq("Rabbits")
    expect(teams.team_id).to eq("20122013")
  end

  it "has a create games class method" do
    expect(Teams.create_teams).to be_an Array
    Teams.create_teams.each do |team|
      expect(team).to be_a Teams
    end
  end
end