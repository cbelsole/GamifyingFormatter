# rspec example/example.rb --require gamifying_formatter.rb --format GamifyingFormatter
describe "my group" do
  100.times do
    specify "my example" do
      expect(1).to eq(1)
    end
  end
end
