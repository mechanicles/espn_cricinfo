require 'rails_helper'

RSpec.describe Match, type: :model do
  before do
    @match = Match.new(team1: "India", team2: "Australia", first_batting_team: "India",
                       total_run_for_team1: 200, out_count_for_team1: 10, total_run_for_team2: 201,
                       out_count_for_team2: 5)

    @completed_match = Match.create!(team1: "India", team2: "Australia", first_batting_team: "India",
                                     total_run_for_team1: 200, out_count_for_team1: 10,
                                     total_run_for_team2: 201, out_count_for_team2: 5,
                                     end_result: "Australia won")
  end

  context "validations" do
    it 'should validate required fields' do
      match = Match.new
      match.save
      expect(match.errors[:team1]).to include("can't be blank")
      expect(match.errors[:team2]).to include("can't be blank")
      expect(match.errors[:first_batting_team]).to include("can't be blank")
    end

    it 'validates that team1 and team2 should not be same' do
      match = Match.new(team1: "India", team2: "India")
      match.save
      expect(match.errors[:base]).to include("Team1 and Team2 should not be same")
    end

    it 'should validate that first_batting_team should be team1 or team2' do
      match = Match.new(team1: "India", team2: "India", first_batting_team: "Australia")
      match.save
      expect(match.errors[:first_batting_team]).to include("should be either team1 or team2")
    end

    it 'should validate that first_batting_team should be team1 or team2' do
      match = Match.new(team1: "India", team2: "India", first_batting_team: "Australia")
      match.save
      expect(match.errors[:first_batting_team]).to include("should be either team1 or team2")
    end

    it 'should validate updating if match is already completed' do
      @completed_match.update(total_run_for_team1: 220)
      expect(@completed_match.errors[:base]).to include("Can't update. Match is completed already!!!.")
    end

    it 'should not create a match if team is already playing' do
      new_match = @match.dup
      @match.save!
      new_match.save
      expect(new_match.errors[:base]).to include("Can't create. One of the teams is already playing!!!.")
    end
  end

  context "scope methods" do
    it 'should return live matches' do
      @match.save!
      expect(Match.live).to include(@match)
    end

    it 'should return old/previous matches' do
      expect(Match.previous).to include(@completed_match)
    end
  end

  context "instance methods" do
    it "should return json object if invoke to 'to_json' method on an object" do
      @match.save!
      expect(JSON.parse(@match.to_json).keys).to eql(["id", "title", "first_batting_team",
                                                      "current_batting_team_info",
                                                      "first_batting_team_info",
                                                      "end_result"])
    end

    it "should return formatted string if we invoke 'to_s' on an object" do
      expect(@match.to_s).to eql("India v Australia")
    end

    it "returns required info if we invoke 'first_batting_team_info' method on an object" do
      data = {:name=>"India", :total_runs=>200, :total_out=>10, :played=>true, :status=>"India 200-10"}
      expect(@completed_match.first_batting_team_info).to eql(data)
    end

    it "returns required info if we invoke 'current_batting_team_info' method on an object" do
      @match.save!
      data = {:name=>"Australia", :total_runs=>201, :total_out=>5, :status=>"Australia 201-5"}
      expect(@match.current_batting_team_info).to eql(data)
    end

    it "should return current satus for given match object" do
      @match.save!
      expect(@match.current_match_status).to eql("Australia 201-5")
    end

    it "should return current satus for given match object" do
      @match.save!
      expect(@match.current_match_status).to eql("Australia 201-5")
    end

    it "should return team1 status" do
      @match.save!
      expect(@match.team1_status).to eql("India 200-10")
    end

    it "should return team2 status" do
      @match.save!
      expect(@match.team2_status).to eql("Australia 201-5")
    end

    it "should tell that give match is completed or not" do
      @match.save!
      expect(@match.completed?).to eql(false)

      expect(@completed_match.completed?).to eql(true)
    end
  end
end
