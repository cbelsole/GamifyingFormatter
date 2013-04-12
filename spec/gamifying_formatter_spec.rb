require 'spec_helper'
require 'stringio'

describe GamifyingFormatter do
  before do
    @output = StringIO.new
    @formatter = GamifyingFormatter.new(@output)
    @formatter.start(2)
    @example = RSpec::Core::ExampleGroup.describe.example
    # sleep(0.1)
  end

  context 'achievements' do
    describe '.number_of_tests_achievement' do
      it 'should set an achievment for adding 1 test' do
        @formatter.number_of_tests_achievement(3, 4)
        expect(@formatter.instance_variable_get(:@achievements).size).to eq(1)
        expect(@formatter.instance_variable_get(:@achievements)[0]).to eq('Added 1 test(s)!')
      end

      it 'should set and achievement for adding 100 tests' do
        @formatter.number_of_tests_achievement(1, 1000)
        expect(@formatter.instance_variable_get(:@achievements).size).to eq(1)
        expect(@formatter.instance_variable_get(:@achievements)[0]).to eq('Added 100 test(s)!')
      end

      it 'should not set an achievement for adding tests' do
        @formatter.number_of_tests_achievement(4, 3)
        expect(@formatter.instance_variable_get(:@achievements).size).to eq(0)
      end
    end

    describe '.decreased_test_time_achievement' do
      it 'should set an achievment for improving tests time by .2 seconds' do
        @formatter.decreased_test_time_achievement(0.3, 0.1)
        expect(@formatter.instance_variable_get(:@achievements).size).to eq(1)
        expect(@formatter.instance_variable_get(:@achievements)[0]).to eq('Reduced testing time by 0.2 second(s)!')
      end

      it 'should set and achievement for improving tests time by 100 seconds' do
        @formatter.decreased_test_time_achievement(1000, 1)
        expect(@formatter.instance_variable_get(:@achievements).size).to eq(1)
        expect(@formatter.instance_variable_get(:@achievements)[0]).to eq('Reduced testing time by 100 second(s)!')
      end

      it 'should not set an achievement for improving test time' do
        @formatter.decreased_test_time_achievement(3, 4)
        expect(@formatter.instance_variable_get(:@achievements).size).to eq(0)
      end
    end

    describe '.number_of_fixed_tests_achievement' do
      it 'should set an achievment for fixing 1 test' do
        @formatter.number_of_fixed_tests_achievement(4, 3)
        expect(@formatter.instance_variable_get(:@achievements).size).to eq(1)
        expect(@formatter.instance_variable_get(:@achievements)[0]).to eq('Fixed 1 test(s)!')
      end

      it 'should set and achievement for fixing 100 tests' do
        @formatter.number_of_fixed_tests_achievement(10000, 1)
        expect(@formatter.instance_variable_get(:@achievements).size).to eq(1)
        expect(@formatter.instance_variable_get(:@achievements)[0]).to eq('Fixed 100 test(s)!')
      end

      it 'should not set an achievement for fixing tests' do
        @formatter.number_of_fixed_tests_achievement(3, 4)
        expect(@formatter.instance_variable_get(:@achievements).size).to eq(0)
      end
    end
  end

  context 'output' do
    describe '.output_achievements' do
      it 'outputs all achievemnts in the list' do
        achievement_array = Array.new(5) { |i| "Achievement #{i}"}
        @formatter.instance_variable_set(:@achievements, achievement_array)

        @output.should_receive(:puts).exactly(5).times

        @formatter.output_achievements
        puts @output.read
      end
    end

    describe '.get_trophies' do
      it 'returns the correct trophie based on the number' do
        expect(@formatter.get_trophie(1)).to eq([
          "  .__.",
          " (|  |)",
          "  (  )",
          "  _)(_"
        ].join("\n"))
      end
    end
  end
end
