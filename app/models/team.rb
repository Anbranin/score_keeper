class Team < ApplicationRecord
  belongs_to :division

  validates :name, uniqueness: { scope: :division }

  has_many :spirit_score_sheets

  has_many :spirit_scores, class_name: 'SpiritScoreSheet', foreign_key: :opponent_id

  def description
    "#{name} - #{division.name}"
  end

  def total_spirit_score
    spirit_scores.map(&:total).compact.sum
  end

  def average_spirit_score
    return 0 if spirit_scores.empty?
    (total_spirit_score.to_d / spirit_scores.count).to_f
  end

  def spirit_finish
    @teams ||= division.teams.sort_by(&:total_average).reverse
    index = @teams.find_index(self)
    index + 1
  end

  def average_of(spirit_field)
    return 0 if spirit_scores.empty?
    scores_per_field = spirit_scores.map(&spirit_field).compact
    scores_per_field.sum.to_d / scores_per_field.size
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
