module SpiritScoreSheetsHelper
  def spirit_class(team, field)
    return 'highest-average' if team.highest_average?(field)

    team.higher_than_average?(field) ? 'above-average' : 'below-average'
  end
end
