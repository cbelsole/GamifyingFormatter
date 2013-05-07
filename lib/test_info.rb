class TestInfo
  attr_accessor :number_of_tests, :total_time, :number_of_failed_tests, :xp, :level

  def initialize
    @achievements = []
  end

  def achievements=(value)
    @achievements = value
  end

  def achievements
    @achievements
  end
end
