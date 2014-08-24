require 'test_info'
require 'yaml'

module GamifyingFormatters
  module Common

    def load_test_info
      if File.exists?('.past_results.yml')
        @test_info = YAML::load(File.new('.past_results.yml', 'r'))
      else
        @test_info = TestInfo.new
      end
    end

    def wrap_up(num_of_examples, num_of_failed_examples, duration)
      @test_info.number_of_tests = num_of_examples
      @test_info.number_of_failed_tests = num_of_failed_examples
      @test_info.total_time = duration
      File.open('.past_results.yml', 'w') { |file| file.puts @test_info.to_yaml }
    end

    def calculate_achevements(example_count, failure_count, duration)
      achievements = []
      achievements << number_of_tests_achievement(@test_info.number_of_tests, example_count)
      achievements << number_of_fixed_tests_achievement(@test_info.number_of_failed_tests, failure_count)
      achievements << decreased_test_time_achievement(@test_info.total_time, duration)

      achievements.delete_if(&:nil?).each { |achievement| @test_info.addAchievement(achievement) }
    end

    def show_achievements
      output.puts "\n!!!!!!!!Achievements!!!!!!!!"
      output.puts get_trophie(@test_info.level)
      output.puts '-' * (@test_info.achievements.uniq.join(" | ").size + 4)
      output.puts "| #{@test_info.achievements.uniq.join(" | ")} |"
      output.puts '-' * (@test_info.achievements.uniq.join(" | ").size + 4)
    end

    def show_xp_bar
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
      goal = [100, 50, 25, 10, 5, 1].select { |target|
        new_total_tests - old_total_tests >= target
      }.max

      goal ? "Added #{goal} test(s)!" : nil
    end

    def decreased_test_time_achievement(old_total_time, new_total_time)
      goal = [100, 50, 25, 10, 5, 1, 0.5, 0.2].select { |target|
        (old_total_time * 100 - new_total_time * 100).round / 100.0 >= target
      }.max

      goal ? "Reduced testing time by #{goal} second(s)!" : nil
    end

    def number_of_fixed_tests_achievement(old_failed_tests, new_failed_tests)
      goal = [100, 50, 25, 10, 5, 1].select { |target|
        old_failed_tests - new_failed_tests >= target
      }.max

      goal ? "Fixed #{goal} test(s)!" : nil
    end

    def get_trophie(level)
      case level
        when 1
          <<-EOS
            .__.
           (|  |)
            (  )
            _)(_
          EOS
        when 2
          <<-EOS
                {}
               /__\\
             /|    |\\
            (_|    |_)
               \\  /
                )(
              _|__|_
            _|______|_
           |__________|
          EOS
        when 3
          <<-EOS
             ___________
            '._==_==_=_.'
            .-\\:      /-.
           | (|:.     |) |
            '-|:.     |-'
              \\::.    /
               '::. .'
                 ) (
               _.' '._
              `"""""""`"
          EOS
        when 4
          <<-EOS
            .-=========-.
            \\'-=======-'/
            _|   .=.   |_
           ((|  {{1}}  |))
            \\|   /|\\   |/
             \\__ '`' __/
               _`) (`_
             _/_______\\_
            /___________\\
          EOS
        else
          ''
      end
    end

  end
end

