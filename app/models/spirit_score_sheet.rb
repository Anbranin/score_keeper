class SpiritScoreSheet < ApplicationRecord
  belongs_to :team

  belongs_to :opponent, class_name: 'Team', foreign_key: :opponent_id

  NUMBER_FIELDS = %i[rules_knowledge_and_use fouls_and_body_contact
  fair_mindedness positive_attitude_and_self_control communication]

  def total
    scores = NUMBER_FIELDS.map do |field|
      self.send(field)
    end
    return quick_total.to_i if scores.any?(&:blank?)
    scores.sum
  end
end
