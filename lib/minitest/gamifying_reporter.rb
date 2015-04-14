require 'gamifying_formatter/common'

module Minitest
  class GamifyingReporter < StatisticsReporter
    include GamifyingFormatters::Common

    def initialize
      super
      @test_info = load_test_info
    end

    def report
      super

      num_of_failures = failures + errors
      total = count - skips
      achievements = calculate_achevements(total, num_of_failures, total_time)
      show_achievements unless achievements.empty?
      show_xp_bar
      wrap_up(total, num_of_failures, total_time)
    end

    alias_method :output, :io

  end
end
