require_relative 'gamifying_reporter'

module Minitest
  def self.plugin_gamifying_reporter_init(options)
    self.reporter.reporters.push Minitest::GamifyingReporter.new
  end
end
