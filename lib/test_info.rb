class TestInfo
  attr_accessor :number_of_tests, :total_time, :number_of_failed_tests
  attr_reader :xp, :level, :achievements

  def initialize
    @achievements = []
    @level = 1
    @xp = 0
    @number_of_tests = 0
    @number_of_failed_tests = 0
    @total_time = 0.0
  end

  def addAchievement(value)
    unless value && value.empty?
      incrimentXpAndLevel
      @achievements << value
    end

    nil
  end

  def ==(o)
    o.class == self.class &&
    o.number_of_tests == number_of_tests &&
    o.total_time == total_time &&
    o.number_of_failed_tests == number_of_failed_tests &&
    o.xp == xp &&
    o.level == level &&
    o.achievements == achievements
  end

private

  def incrimentXpAndLevel
    @xp += 1

    if @xp == 10 || @xp == 25 || @xp == 50 || @xp == 100
      @level += 1
      @xp = 0
    end

    nil
  end
end
