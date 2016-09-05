require 'test_helper'

class MatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @match = matches(:one)
  end

  test "should get index" do
    get matches_url
    assert_response :success
  end

  test "should get new" do
    get new_match_url
    assert_response :success
  end

  test "should create match" do
    assert_difference('Match.count') do
      post matches_url, params: { match: { out_count_for_team1: @match.out_count_for_team1, out_count_for_team2: @match.out_count_for_team2, team1: @match.team1, team2: @match.team2, total_run_for_team1: @match.total_run_for_team1, total_run_for_team2: @match.total_run_for_team2 } }
    end

    assert_redirected_to match_url(Match.last)
  end

  test "should show match" do
    get match_url(@match)
    assert_response :success
  end

  test "should get edit" do
    get edit_match_url(@match)
    assert_response :success
  end

  test "should update match" do
    patch match_url(@match), params: { match: { out_count_for_team1: @match.out_count_for_team1, out_count_for_team2: @match.out_count_for_team2, team1: @match.team1, team2: @match.team2, total_run_for_team1: @match.total_run_for_team1, total_run_for_team2: @match.total_run_for_team2 } }
    assert_redirected_to match_url(@match)
  end

  test "should destroy match" do
    assert_difference('Match.count', -1) do
      delete match_url(@match)
    end

    assert_redirected_to matches_url
  end
end
