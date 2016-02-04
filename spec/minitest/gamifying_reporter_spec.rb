require 'spec_helper'

describe 'Minitest::GamifyingReporter' do

  before do
    File.delete(results_path) if File.exists?(results_path)
  end

  let(:results_path) { File.join(File.expand_path('..', __FILE__), '.past_results.yml') }

  let(:output) {
    Dir.chdir(File.dirname(__FILE__)) do
      `BUNDLE_GEMFILE=../../Gemfile bundle exec ruby test_example.rb`
    end
  }

  it 'shows achievements' do
    expect(output).to include(
      <<-EOS
!!!!!!!!Achievements!!!!!!!!
            .__.
           (|  |)
            (  )
            _)(_
--------------------
| Added 1 test(s)! |
--------------------
      EOS
    )
  end

  it 'shows xp bar' do
    expect(output).to include(
      <<-EOS
Level 1: 1/10 [==                       ]
      EOS
    )
  end

  it 'writes results' do
    output
    expect(File.exists?(results_path)).to be_truthy
  end
end
