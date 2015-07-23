require_relative '../lib/desuraify'

RSpec.describe Desuraify do
  it 'can not be instantiated' do
    expect {
      Desuraify.new
    }.to raise_error(NoMethodError)
  end
end