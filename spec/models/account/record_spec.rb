# spec/models/account_spec.rb

require 'spec_helper'

RSpec.describe ::Account::Record, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:owner_name) }
    it { should validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }  
  end

  describe '.destroy' do
    let(:account) { described_class.create(owner_name: 'John Doe', balance: 100, closed: false) }

    it 'raises an error' do
      expect { account.destroy }.to raise_error(ActiveRecord::RecordNotDestroyed)
    end
  end
end
