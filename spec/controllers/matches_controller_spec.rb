require "rails_helper"

RSpec.describe MatchesController, type: :controller do
  render_views

  before do
    @match = Match.new(team1: "India", team2: "Australia", first_batting_team: "India",
                       total_run_for_team1: 200, out_count_for_team1: 10, total_run_for_team2: 201,
                       out_count_for_team2: 5)

    @completed_match = Match.create!(team1: "India", team2: "Australia", first_batting_team: "India",
                                     total_run_for_team1: 200, out_count_for_team1: 10,
                                     total_run_for_team2: 201, out_count_for_team2: 5,
                                     end_result: "Australia won")
  end


  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      @match.save!

      get :index, format: :json
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["all_matches"].keys).to eql(["live_matches", "previous_matches"])
    end
  end

  describe "GET #show" do
    it "responds successfully with an HTTP 200 status code" do
      @match.save!

      get :show, params: { id: @match.id }, format: :json
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eql(JSON.parse(@match.to_json))
    end
  end
end
