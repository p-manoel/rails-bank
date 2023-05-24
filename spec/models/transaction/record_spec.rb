# spec/models/account_spec.rb

require 'spec_helper'

RSpec.describe ::Transaction::Record, type: :model do
  describe 'associations' do
    it { should belong_to(:account) }
  end

  describe 'validations' do
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:fee) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should validate_inclusion_of(:type).in_array(%w(deposit withdraw transfer)) }
  end
end