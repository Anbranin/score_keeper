class Team < ApplicationRecord
  belongs_to :division

  validates :name, uniqueness: { scope: :division }

  has_many :spirit_score_sheets

  has_many :spirit_scores, class_name: 'SpiritScoreSheet', foreign_key: :opponent_id

  def description
    "#{name} - #{division.name}"
  end

  def average_spirit_score
    SpiritScoreSheet::NUMBER_FIELDS.map do |field|
      spirit_scores.map(&field)
    end.flatten.sum
  end
end
