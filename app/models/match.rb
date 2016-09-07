class Match < ApplicationRecord
  attr_accessor :current_status

  CURRENT_STATUSES = [1,2,3,4,6, "out"]
  TOTAL_PLAYER_IN_TEAM = 10

  CRICKET_TEAMS = [
    "Australia",
    "India",
    "England",
    "Pakistan",
    "New Zealand",
    "South Africa",
    "Sri Lanka",
    "West Indies",
  ]

  validates :team1, :team1, :first_batting_team, presence: true
  validate :first_batting_team_should_be_team1_or_team2
  validate :team1_and_team2_should_not_be_same
  validates :out_count_for_team1, :out_count_for_team2, numericality: { less_than_or_equal_to: 10 }

  before_update :handle_current_state

  def as_json(options={})
    {
      id: id,
      title: self.to_s,
      current_batting_team_score: current_batting_team_score,
      first_batting_team_score: first_batting_team_score,
    }
  end

  def to_s
    "#{team1} v #{team2}"
  end

  def first_batting_team_score
    data = {}

    if current_batting_team_score[:name] != team1
      data[:name]       = team1
      data[:total_runs] = total_run_for_team1
      data[:total_out]  = out_count_for_team1
      data[:played]     = (out_count_for_team1 == TOTAL_PLAYER_IN_TEAM)
    else
      data[:name]       = team2
      data[:total_runs] = total_run_for_team2
      data[:total_out]  = out_count_for_team2
      data[:played]     = (out_count_for_team1 == TOTAL_PLAYER_IN_TEAM)
    end

    data
  end

  def current_batting_team_score
    # Confusing code :) Need to refactor

    if first_batting_team == team1
      if out_count_for_team1 < TOTAL_PLAYER_IN_TEAM
        { name: team1,
          total_runs: total_run_for_team1,
          total_out: out_count_for_team1 }
      else
        { name: team2,
          total_runs: total_run_for_team2,
          total_out: out_count_for_team2 }
      end
    else
      if out_count_for_team2 < TOTAL_PLAYER_IN_TEAM
        { name: team2,
          total_runs: total_run_for_team2,
          total_out: out_count_for_team2 }
      else
        { name: team1,
          total_runs: total_run_for_team1,
          total_out: out_count_for_team1 }
      end
    end
  end

  def current_match_status
    "#{current_batting_team_score[:name]} : #{current_batting_team_score[:total_runs]}-runs/" \
      "#{current_batting_team_score[:total_out]}-out"
  end

  private

  def team1_and_team2_should_not_be_same
    if team1 == team2
      errors.add(:base, "Team1 and Team2 should not be same")
    end
  end

  def first_batting_team_should_be_team1_or_team2
    if ![team1.downcase, team2.downcase].include? first_batting_team.downcase
      errors.add(:first_batting_team, "should be either team1 or team2")
    end
  end

  def handle_current_state
    if current_batting_team_score[:name] == team1
      if current_status == "out"
        self.out_count_for_team1 += 1
      else
        self.total_run_for_team1 += current_status.to_i
      end
    else
      if current_status == "out"
        self.out_count_for_team2 += 1
      else
        self.total_run_for_team2 += current_status.to_i
      end
    end
  end
end
