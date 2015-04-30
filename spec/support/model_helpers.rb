module Models
  module FixtureHelpers
    def fixture(file)
      File.new(File.expand_path("../fixtures", File.dirname(__FILE__)) + "/" + file)
    end
  end
end