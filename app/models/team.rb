class Team < ApplicationRecord
  belongs_to :division

  validates :name, uniqueness: { scope: :division }

  has_many :spirit_score_sheets

  has_many :spirit_scores, class_name: 'SpiritScoreSheet', foreign_key: :opponent_id

  def description
    "#{name} - #{division.name}"
  end

  def total_spirit_score
    SpiritScoreSheet::NUMBER_FIELDS.map do |field|
      spirit_scores.map(&field)
    end.flatten.sum
  end

  def average_spirit_score
    return 0 if spirit_scores.empty?

    (total_spirit_score.to_d / spirit_scores.count).to_f
  end

  def spirit_finish
    return nil if spirit_scores.empty?

    # Cache team averages once and sort
    scored_teams = division.teams.select { |t| t.spirit_scores.any? }
    averages = scored_teams.map { |t| [t, t.total_average.round(3)] }

    sorted = averages.sort_by { |_t, avg| -avg }

    rank = 0
    prev_score = nil
    ranks = {}

    sorted.each do |team, avg|
      rank += 1 if avg != prev_score
      ranks[team.id] = rank
      prev_score = avg
    end

    ranks[id]
  end

  def average_of(spirit_field)
    return 0 if spirit_scores.empty?

    spirit_scores.sum(&spirit_field).to_d / spirit_scores.size
  end

  def sum_of_averages
    averages.sum
  end

  def averages
    SpiritScoreSheet::NUMBER_FIELDS.map do |field|
      average_of(field)
    end
  end

  def total_average
    sum_of_averages / averages.size
  end

  def higher_than_average?(spirit_field)
    # only teams that have spirit score sheets
    relevant_teams = division.teams.joins(:spirit_score_sheets).distinct
    # take everyone's sum of averages
    all_averages = division.teams.map { |team| team.average_of(spirit_field) }
    # take the average of THAT
    average_of_averages = all_averages.sum / all_averages.size
    # is THIS team's average above that?
    average_of(spirit_field) > average_of_averages
  end

  def highest_average?(spirit_field)
    # only teams that have spirit score sheets
    relevant_teams = division.teams.joins(:spirit_score_sheets).distinct
    # take everyone's sum of averages
    all_averages = division.teams.map { |team| team.average_of(spirit_field) }
    # is THIS team's the highest?
    average_of(spirit_field) == all_averages.max
  end
end
