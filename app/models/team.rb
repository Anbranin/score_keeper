class Team < ApplicationRecord
  belongs_to :division

  validates :name, uniqueness: { scope: :division }

  def description
    "#{team.name} - #{division.name}"
  end
end
