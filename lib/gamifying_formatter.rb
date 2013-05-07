require "rspec/core/formatters/base_text_formatter"
require 'test_info'
require 'yaml'

class GamifyingFormatter < RSpec::Core::Formatters::BaseTextFormatter
  def initialize(output)
    super(output)
    if File.exists?('.past_results.yml')
      @test_info = YAML::load(File.new('.past_results.yml', 'r'))
    else
      @test_info = TestInfo.new
      @test_info.level = 1
      @test_info.xp = 0
      @test_info.number_of_tests = 0
      @test_info.number_of_failed_tests = 0
      @test_info.total_time = 0.0
    end

    @got_achievement = false
  end

  def close
    super

    @test_info.number_of_tests = example_count
    @test_info.total_time = duration
    @test_info.number_of_failed_tests = failure_count

    File.open('.past_results.yml', 'w') { |file| file.puts @test_info.to_yaml }
  end

  def dump_summary(duration, example_count, failure_count, pending_count)

    super(duration, example_count, failure_count, pending_count)

    number_of_tests_achievement(@test_info.number_of_tests, example_count)

    number_of_fixed_tests_achievement(@test_info.number_of_failed_tests, failure_count)

    decreased_test_time_achievement(@test_info.total_time, duration)

    output_achievements

    output_xp_bar
  end

  def output_achievements
    return unless @got_achievement
    output.puts "\n!!!!!!!!Achievements!!!!!!!!"
    output.puts get_trophie(@test_info.level)
    output.puts '-' * (@test_info.achievements.uniq.join(" | ").size + 4)
    output.puts "| #{@test_info.achievements.uniq.join(" | ")} |"
    output.puts '-' * (@test_info.achievements.uniq.join(" | ").size + 4)
  end

  def output_xp_bar
    case @test_info.level
      when 1
        goal_xp = 10
      when 2
        goal_xp = 25
      when 3
        goal_xp = 50
      when 4
        goal_xp = 100
      else
        goal_xp = 1000
    end

    least_common_multiple = goal_xp.lcm(25)
    numerator = least_common_multiple / goal_xp
    denominator = least_common_multiple / 25

    xp_chars = '=' * ((@test_info.xp * numerator) / denominator).ceil
    xp_filler = ' ' * (25 - xp_chars.size)

    output.puts "Level #{@test_info.level}: #{@test_info.xp}/#{goal_xp} [#{xp_chars}#{xp_filler}]"
  end

  def number_of_tests_achievement(old_total_tests, new_total_tests)
    [100, 50, 25, 10, 5, 1].each do |number|
      if new_total_tests - old_total_tests >= number
        @test_info.achievements.push("Added #{number} test(s)!")
        @test_info.xp += 1
        @got_achievement = true
        check_level_up(@test_info.xp)
        break
      end
    end
  end

  def decreased_test_time_achievement(old_total_time, new_total_time)
    [100, 50, 25, 10, 5, 1, 0.5, 0.2].each do |number|
      if (old_total_time * 100 - new_total_time * 100).round / 100.0 >= number
        @test_info.achievements.push("Reduced testing time by #{number} second(s)!")
        @test_info.xp += 1
        @got_achievement = true
        check_level_up(@test_info.xp)
        break
      end
    end
  end

  def number_of_fixed_tests_achievement(old_failed_tests, new_failed_tests)
    [100, 50, 25, 10, 5, 1].each do |number|
      if old_failed_tests - new_failed_tests >= number
        @test_info.achievements.push("Fixed #{number} test(s)!")
        @test_info.xp += 1
        @got_achievement = true
        check_level_up(@test_info.xp)
        break
      end
    end
  end

  def check_level_up(xp)
    if xp == 11 || xp == 26 || xp == 51 || xp == 101
      @test_info.level += 1
    end
  end

  def get_trophie(level)
    case level
      when 3
        [
          "   ___________",
          "  \'._==_==_=_.\'",
          "  .-\\:      /-.",
          " | (|:.     |) |",
          "  \'-|:.     |-\'",
          "    \\::.    /",
          "     \'::. .\'",
          "       ) (",
          "     _.' '._",
          "    `\"\"\"\"\"\"\"`"
        ].join("\n")
      when 2
        [
          "      {}",
          "     /__\\",
          "   /|    |\\",
          "  (_|    |_)",
          "     \\  /",
          "      )(",
          "    _|__|_",
          "  _|______|_",
          " |__________|"
      ].join("\n")
      when 4
        [
          "  .-=========-.",
          "  \\'-=======-'/",
          "  _|   .=.   |_",
          " ((|  {{1}}  |))",
          "  \\|   /|\\   |/",
          "   \\__ '`' __/",
          "     _`) (`_",
          "   _/_______\\_",
          "  /___________\\"
        ].join("\n")
      when 1
        [
          "  .__.",
          " (|  |)",
          "  (  )",
          "  _)(_"
        ].join("\n")
      else
        ''
    end
  end
end

