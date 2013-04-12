class TestInfo
  attr_accessor :number_of_tests, :total_time, :number_of_failed_tests, :number_of_achievements

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
