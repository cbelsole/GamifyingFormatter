require 'spec_helper'

describe TestInfo do
  let(:test_info) { TestInfo.new }

  describe '#addAchievement' do
    context 'for a valid achievement' do
      it 'adds an achievement to the list when the value is not blank' do
        test_info.addAchievement('some achievement')

        expect(test_info.achievements.size).to eq(1)
        expect(test_info.achievements.at(0)).to eq('some achievement')
      end

      it 'increments the level and resets the xp at 10' do
        test_info.instance_variable_set('@xp', 9)
        test_info.addAchievement('some achievement')

        expect(test_info.level).to eq(2)
        expect(test_info.xp).to eq(0)
      end

      it 'increments the level and resets the xp at 25' do
        test_info.instance_variable_set('@xp', 24)
        test_info.addAchievement('some achievement')

        expect(test_info.level).to eq(2)
        expect(test_info.xp).to eq(0)
      end

      it 'increments the level and resets the xp at 50' do
        test_info.instance_variable_set('@xp', 49)
        test_info.addAchievement('some achievement')

        expect(test_info.level).to eq(2)
        expect(test_info.xp).to eq(0)
      end

      it 'increments the level and resets the xp at 100' do
        test_info.instance_variable_set('@xp', 99)
        test_info.addAchievement('some achievement')

        expect(test_info.level).to eq(2)
        expect(test_info.xp).to eq(0)
      end

      it 'increments the xp and not the level at any other number' do
        test_info.addAchievement('some achievement')

        expect(test_info.level).to eq(1)
        expect(test_info.xp).to eq(1)
      end
    end

    it 'does not add an achievement to the list when it is blank' do
      test_info.addAchievement('')

      expect(test_info.achievements.size).to eq(0)
    end

    it 'returns nil' do
      expect(test_info.addAchievement('something')).to be_nil
    end
  end

end
