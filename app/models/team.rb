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
    total_number_fields = SpiritScoreSheet::NUMBER_FIELDS.size
    total_spirit_score.to_d / total_number_fields
  end
end
