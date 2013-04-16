require "rspec/core/formatters/base_text_formatter"
require 'test_info'
require 'yaml'

class GamifyingFormatter < RSpec::Core::Formatters::BaseTextFormatter
  def initialize(output)
    super(output)
    @test_info = TestInfo.new
    if File.exists?('.past_results.yml')
      @past_results = YAML::load(File.new('.past_results.yml', 'r'))
    else
      @past_results = TestInfo.new
    end
  end

  def close
    super

    @test_info.number_of_tests = example_count
    @test_info.total_time = duration
    @test_info.number_of_failed_tests = failure_count
    @test_info.achievements = @past_results.achievements + @test_info.achievements
    @test_info.number_of_achievements = @test_info.achievements.size

    File.open('.past_results.yml', 'w') { |file| file.puts @test_info.to_yaml }
  end

  def dump_summary(duration, example_count, failure_count, pending_count)

    super(duration, example_count, failure_count, pending_count)

    unless File.exists?('.past_results.yml')
      return
    end

    number_of_tests_achievement(@past_results.number_of_tests, example_count)

    number_of_fixed_tests_achievement(@past_results.number_of_failed_tests, failure_count)

    decreased_test_time_achievement(@past_results.total_time, duration)

    output_achievements
  end

  def output_achievements
    return if @test_info.achievements.size == 0
    output.puts "\n!!!!!!!!Achievements!!!!!!!!"
    output.puts get_trophie(@past_results.number_of_achievements + @test_info.achievements.size)
    output.puts '-' * (@test_info.achievements.join(" | ").size + 4)
    output.puts "| #{@test_info.achievements.join(" | ")} |"
    output.puts '-' * (@test_info.achievements.join(" | ").size + 4)
  end

  def number_of_tests_achievement(old_total_tests, new_total_tests)
    [100, 50, 25, 10, 5, 1].each do |number|
      if new_total_tests - old_total_tests >= number
        @test_info.achievements.push("Added #{number} test(s)!")
        break
      end
    end
  end

  def decreased_test_time_achievement(old_total_time, new_total_time)
    [100, 50, 25, 10, 5, 1, 0.5, 0.2].each do |number|
      if (old_total_time * 100 - new_total_time * 100).round / 100.0 >= number
        @test_info.achievements.push("Reduced testing time by #{number} second(s)!")
        break
      end
    end
  end

  def number_of_fixed_tests_achievement(old_failed_tests, new_failed_tests)
    [100, 50, 25, 10, 5, 1].each do |number|
      if old_failed_tests - new_failed_tests >= number
        @test_info.achievements.push("Fixed #{number} test(s)!")
        break
      end
    end
  end

  def get_trophie(achievement_count)
    case achievement_count
      when 26..50
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
      when 11..25
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
      when 51..100
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
      when 1..10
        [
          "  .__.",
          " (|  |)",
          "  (  )",
          "  _)(_"
        ].join("\n")
    end
  end
end

