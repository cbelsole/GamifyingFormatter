require 'rspec/core/formatters/base_text_formatter'

include GamifyingFormatters::Common

class RSpec3 < RSpec::Core::Formatters::BaseTextFormatter

  RSpec::Core::Formatters.register self, :dump_summary

  def initialize(output)
    super(output)
    @test_info = load_test_info
  end

  def wrap_up(num_of_examples, num_of_failed_examples, duration)
    @test_info.number_of_tests = num_of_examples
    @test_info.number_of_failed_tests = num_of_failed_examples
    @test_info.total_time = duration
    File.open('.past_results.yml', 'w') { |file| file.puts @test_info.to_yaml }
  end

  def dump_summary(summary_notification)
    super(summary_notification)

    achievements = calculate_achevements(
      summary_notification.examples.size,
      summary_notification.failed_examples.size,
      summary_notification.duration
    )

    show_achievements unless achievements.empty?

    show_xp_bar

    wrap_up(
      summary_notification.examples.size,
      summary_notification.failed_examples.size,
      summary_notification.duration
    )
  end
end

