require 'spec_helper'

describe 'GamifyingFormatters::Common' do

  let(:output) { StringIO.new }
  let(:formatter) { TestFormatter.new(output) }

  describe '#load_test_info' do
    it 'loads yml file when present' do
      allow(File).to receive(:exists?).and_return(true)
      expect(File).to receive(:new).with('.past_results.yml', 'r').and_return('--- foo')
      formatter.load_test_info
      expect(formatter.instance_variable_get(:@test_info)).to eq('foo')
    end

    it 'creates new TestInfo when yml file is not present' do
      allow(File).to receive(:exists?).and_return(false)
      formatter.load_test_info
      expect(formatter.instance_variable_get(:@test_info)).to eq(TestInfo.new)
    end
  end

  describe '#wrap_up' do
    let(:test_info) { formatter.instance_variable_get(:@test_info) }

    it 'saves info to .past_results.yml' do
      test_info.instance_variable_set(:@xp, 34)
      test_info.instance_variable_set(:@level, 5)
      test_info.instance_variable_set(:@achievements, ['something'])

      allow(File).to receive(:open)

      formatter.wrap_up(100, 2, 99)
    end
  end

  describe '#show_achievements' do
    let(:test_info) { formatter.instance_variable_get(:@test_info) }

    it 'shows all achievements' do
      test_info.instance_variable_set(:@achievements, ['one', 'two', 'three'])

      expect(output).to receive(:puts)
        .with("\n!!!!!!!!Achievements!!!!!!!!")
      expect(output).to receive(:puts)
        .with("            .__.\n           (|  |)\n            (  )\n            _)(_\n")
      expect(output).to receive(:puts)
        .with('---------------------')
      expect(output).to receive(:puts)
        .with('| one | two | three |')
      expect(output).to receive(:puts)
        .with('---------------------')
      formatter.show_achievements
    end
  end

  describe '#show_xp_bar' do
    let(:test_info) { formatter.instance_variable_get(:@test_info) }

    context 'when level is 1' do
      it 'shows xp bar for empty xp' do
        expect(output).to receive(:puts)
          .with('Level 1: 0/10 [                         ]')

        formatter.show_xp_bar
      end

      it 'shows xp bar for almost full' do
        expect(output).to receive(:puts)
          .with('Level 1: 9/10 [======================   ]')
        test_info.instance_variable_set(:@xp, 9)
        formatter.show_xp_bar
      end

      it 'shows xp bar half full' do
        expect(output).to receive(:puts)
          .with('Level 1: 5/10 [============             ]')
        test_info.instance_variable_set(:@xp, 5)
        formatter.show_xp_bar
      end
    end

    context 'when level is 2' do
      before do
        test_info.instance_variable_set(:@level, 2)
      end

      it 'shows xp bar for empty xp' do
        expect(output).to receive(:puts)
          .with('Level 2: 0/25 [                         ]')

        formatter.show_xp_bar
      end

      it 'shows xp bar for almost full' do
        expect(output).to receive(:puts)
          .with('Level 2: 24/25 [======================== ]')
        test_info.instance_variable_set(:@xp, 24)
        formatter.show_xp_bar
      end

      it 'shows xp bar half full' do
        expect(output).to receive(:puts)
          .with('Level 2: 13/25 [=============            ]')
        test_info.instance_variable_set(:@xp, 13)
        formatter.show_xp_bar
      end
    end

    context 'when level is 3' do
      before do
        test_info.instance_variable_set(:@level, 3)
      end

      it 'shows xp bar for empty xp' do
        expect(output).to receive(:puts)
          .with('Level 3: 0/50 [                         ]')

        formatter.show_xp_bar
      end

      it 'shows xp bar for almost full' do
        expect(output).to receive(:puts)
          .with('Level 3: 49/50 [======================== ]')
        test_info.instance_variable_set(:@xp, 49)
        formatter.show_xp_bar
      end

      it 'shows xp bar half full' do
        expect(output).to receive(:puts)
          .with('Level 3: 25/50 [============             ]')
        test_info.instance_variable_set(:@xp, 25)
        formatter.show_xp_bar
      end
    end

    context 'when level is 4' do
      before do
        test_info.instance_variable_set(:@level, 4)
      end

      it 'shows xp bar for empty xp' do
        expect(output).to receive(:puts)
          .with('Level 4: 0/100 [                         ]')

        formatter.show_xp_bar
      end

      it 'shows xp bar for almost full' do
        expect(output).to receive(:puts)
          .with('Level 4: 99/100 [======================== ]')
        test_info.instance_variable_set(:@xp, 99)
        formatter.show_xp_bar
      end

      it 'shows xp bar half full' do
        expect(output).to receive(:puts)
          .with('Level 4: 50/100 [============             ]')
        test_info.instance_variable_set(:@xp, 50)
        formatter.show_xp_bar
      end
    end

    context 'when level is above 4' do
      before do
        test_info.instance_variable_set(:@level, 5)
      end

      it 'shows xp bar for empty xp' do
        expect(output).to receive(:puts)
          .with('Level 5: 0/1000 [                         ]')

        formatter.show_xp_bar
      end

      it 'shows xp bar for almost full' do
        expect(output).to receive(:puts)
          .with('Level 5: 999/1000 [======================== ]')
        test_info.instance_variable_set(:@xp, 999)
        formatter.show_xp_bar
      end

      it 'shows xp bar half full' do
        expect(output).to receive(:puts)
          .with('Level 5: 500/1000 [============             ]')
        test_info.instance_variable_set(:@xp, 500)
        formatter.show_xp_bar
      end
    end
  end

  describe '#number_of_tests_achievement' do
    it 'returns achievement for adding 1 test' do
      expect(
        formatter.number_of_tests_achievement(1, 2)
      ).to eq("Added 1 test(s)!")
    end

    it 'returns achievement for adding 5 tests' do
      expect(
        formatter.number_of_tests_achievement(1, 6)
      ).to eq("Added 5 test(s)!")
    end

    it 'returns achievement for adding 10 tests' do
      expect(
        formatter.number_of_tests_achievement(1, 11)
      ).to eq("Added 10 test(s)!")
    end

    it 'returns achievement for adding 25 tests' do
      expect(
        formatter.number_of_tests_achievement(1, 26)
      ).to eq("Added 25 test(s)!")
    end

    it 'returns achievement for adding 50 tests' do
      expect(
        formatter.number_of_tests_achievement(1, 51)
      ).to eq("Added 50 test(s)!")
    end

    it 'returns achievement for adding 100 tests' do
      expect(
        formatter.number_of_tests_achievement(1, 101)
      ).to eq("Added 100 test(s)!")
    end

    it 'returns nil if added tests are less than 1' do
      expect(
        formatter.number_of_tests_achievement(1, 0)
      ).to eq(nil)
    end
  end

  describe '#decreased_test_time_achievement' do
    it 'returns achievement for .2 saved seconds' do
      expect(
        formatter.decreased_test_time_achievement(0.3, 0.1)
      ).to eq("Reduced testing time by 0.2 second(s)!")
    end

    it 'returns achievement for .5 saved seconds' do
      expect(
        formatter.decreased_test_time_achievement(0.6, 0.1)
      ).to eq("Reduced testing time by 0.5 second(s)!")
    end

    it 'returns achievement for 1 saved seconds' do
      expect(
        formatter.decreased_test_time_achievement(2, 1)
      ).to eq("Reduced testing time by 1 second(s)!")
    end

    it 'returns achievement for 5 saved seconds' do
      expect(
        formatter.decreased_test_time_achievement(6, 1)
      ).to eq("Reduced testing time by 5 second(s)!")
    end

    it 'returns achievement for 10 saved seconds' do
      expect(
        formatter.decreased_test_time_achievement(11, 1)
      ).to eq("Reduced testing time by 10 second(s)!")
    end

    it 'returns achievement for 25 saved seconds' do
      expect(
        formatter.decreased_test_time_achievement(26, 1)
      ).to eq("Reduced testing time by 25 second(s)!")
    end

    it 'returns achievement for 50 saved seconds' do
      expect(
        formatter.decreased_test_time_achievement(51, 1)
      ).to eq("Reduced testing time by 50 second(s)!")
    end

    it 'returns achievement for 100 saved seconds' do
      expect(
        formatter.decreased_test_time_achievement(101, 1)
      ).to eq("Reduced testing time by 100 second(s)!")
    end

    it 'returns nil if seconds saved are less than .2' do
      expect(
        formatter.decreased_test_time_achievement(0, 1)
      ).to eq(nil)
    end
  end

  describe '#number_of_fixed_tests_achievement' do
    it 'returns achievement for 1 fixed test' do
      expect(
        formatter.number_of_fixed_tests_achievement(2, 1)
      ).to eq("Fixed 1 test(s)!")
    end

    it 'returns achievement for 5 fixed test' do
      expect(
        formatter.number_of_fixed_tests_achievement(6, 1)
      ).to eq("Fixed 5 test(s)!")
    end

    it 'returns achievement for 10 fixed test' do
      expect(
        formatter.number_of_fixed_tests_achievement(11, 1)
      ).to eq("Fixed 10 test(s)!")
    end

    it 'returns achievement for 25 fixed test' do
      expect(
        formatter.number_of_fixed_tests_achievement(26, 1)
      ).to eq("Fixed 25 test(s)!")
    end

    it 'returns achievement for 50 fixed test' do
      expect(
        formatter.number_of_fixed_tests_achievement(51, 1)
      ).to eq("Fixed 50 test(s)!")
    end

    it 'returns achievement for 100 fixed test' do
      expect(
        formatter.number_of_fixed_tests_achievement(101, 1)
      ).to eq("Fixed 100 test(s)!")
    end

    it 'returns nil if fixed tests are less than 1' do
      expect(
        formatter.number_of_fixed_tests_achievement(0, 1)
      ).to eq(nil)
    end
  end

  describe '#get_trophie' do
    it 'returns level 1 trophy when level equals 1' do
      expect(formatter.get_trophie(1)).to eq(
        <<-EOS
            .__.
           (|  |)
            (  )
            _)(_
        EOS
      )
    end

    it 'returns level 2 trophy when level equals 2' do
      expect(formatter.get_trophie(2)).to eq(
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
      )
    end

    it 'returns level 3 trophy when level equals 3' do
      expect(formatter.get_trophie(3)).to eq(
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
      )
    end

    it 'returns level 4 trophy when level equals 4' do
      expect(formatter.get_trophie(4)).to eq(
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
      )
    end

    it 'returns empty string when level is anything else' do
      expect(formatter.get_trophie(10)).to eq('')
    end
  end
end

class TestFormatter
  include GamifyingFormatters::Common

  attr_reader :output

  def initialize(output)
    @test_info = TestInfo.new
    @output = output
  end
end
