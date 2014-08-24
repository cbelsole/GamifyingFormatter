include GamifyingFormatters::Common

class RSpec1 < Spec::Runner::Formatter::BaseTextFormatter
  def start(example_count)
    super(example_count)
    @test_info = load_test_info
  end

  def close
    super
    wrap_up(example_count, failure_count, duration)
  end

  def dump_summary(duration, example_count, failure_count, pending_count)
    super(duration, example_count, failure_count, pending_count)

    achievements = calculate_achevements(example_count, failure_count, duration)

    show_achievements unless achievements.empty?

    show_xp_bar
  end
end

