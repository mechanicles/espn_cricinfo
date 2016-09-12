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

  validates :team1, :team2, :first_batting_team, presence: true

  validate :team1_and_team2_should_not_be_same, if: Proc.new { |match|
    match.team1.present? && match.team2.present?
  }

  validate :first_batting_team_should_be_team1_or_team2, if: Proc.new { |match|
    match.team1.present? && match.team2.present? && match.first_batting_team.present?
  }

  validates :out_count_for_team1, :out_count_for_team2, numericality: { less_than_or_equal_to: 10 }
  validate :updating, if: :completed?, on: :update

  before_update :handle_current_state, :set_end_result

  scope :live, -> { where(end_result: nil).order(:created_at) }
  scope :previous, -> { where.not(end_result: nil).order(:created_at) }

  def as_json(options={})
    {
      id: id,
      title: self.to_s,
      first_batting_team: first_batting_team,
      current_batting_team_info: current_batting_team_info,
      first_batting_team_info: first_batting_team_info,
      end_result: end_result
    }
  end

  def to_s
    "#{team1} v #{team2}"
  end

  def first_batting_team_info
    data = {}

    if current_batting_team_info[:name] != team1
      data[:name]       = team1
      data[:total_runs] = total_run_for_team1
      data[:total_out]  = out_count_for_team1
      data[:played]     = (out_count_for_team1 == TOTAL_PLAYER_IN_TEAM)
      data[:status]     = team_status(team1, total_run_for_team1, out_count_for_team1)
    else
      data[:name]       = team2
      data[:total_runs] = total_run_for_team2
      data[:total_out]  = out_count_for_team2
      data[:played]     = (out_count_for_team1 == TOTAL_PLAYER_IN_TEAM)
      data[:status]     = team_status(team2, total_run_for_team2, out_count_for_team2)
    end

    data
  end

  def current_batting_team_info
    # Confusing code :) Need to refactor

    if first_batting_team == team1
      if out_count_for_team1 < TOTAL_PLAYER_IN_TEAM
        { name: team1,
          total_runs: total_run_for_team1,
          total_out: out_count_for_team1,
          status: team_status(team1, total_run_for_team1, out_count_for_team1)
        }
      else
        { name: team2,
          total_runs: total_run_for_team2,
          total_out: out_count_for_team2,
          status: team_status(team2, total_run_for_team2, out_count_for_team2)
        }
      end
    else
      if out_count_for_team2 < TOTAL_PLAYER_IN_TEAM
        { name: team2,
          total_runs: total_run_for_team2,
          total_out: out_count_for_team2,
          status: team_status(team2, total_run_for_team2, out_count_for_team2)
        }
      else
        { name: team1,
          total_runs: total_run_for_team1,
          total_out: out_count_for_team1,
          status: team_status(team1, total_run_for_team1, out_count_for_team1)
        }
      end
    end
  end

  def current_match_status
    team_status(current_batting_team_info[:name],
                current_batting_team_info[:total_runs],
                current_batting_team_info[:total_out])
  end

  def team_status(team, team_total_runs, team_out_count)
    "#{team} #{team_total_runs}-#{team_out_count}"
  end

  def team1_status
    "#{team1} #{total_run_for_team1}-#{out_count_for_team1}"
  end

  def team2_status
    "#{team2} #{total_run_for_team2}-#{out_count_for_team2}"
  end

  def completed?
    end_result.present?
  end

  private

  def team1_and_team2_should_not_be_same
    if team1 == team2
      errors.add(:base, "Team1 and Team2 should not be same")
    end
  end

  def first_batting_team_should_be_team1_or_team2
    if ![team1.try(:downcase), team2.try(:downcase)].include? first_batting_team.try(:downcase)
      errors.add(:first_batting_team, "should be either team1 or team2")
    end
  end

  def updating
    errors.add(:base, "Can't update. Match is completed already!!!.")
  end

  def handle_current_state
    if current_batting_team_info[:name] == team1
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

  def set_end_result
    if out_count_for_team1 == TOTAL_PLAYER_IN_TEAM && out_count_for_team2 == TOTAL_PLAYER_IN_TEAM
      self.end_result = if total_run_for_team1 > total_run_for_team2
                          "#{team1} won"
                        elsif total_run_for_team1 < total_run_for_team2
                          "#{team2} won"
                        else
                          "Tied"
                        end

    end
  end
end
