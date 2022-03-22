require 'rails_helper'

RSpec.describe BankAccountFilter, type: :service do
  let(:user) { FactoryBot.create(:user) }

  describe '#call' do
    context 'when params[:search] is present' do
      let(:bank_account_ids) { user.bank_account_ids }
      let(:params) { { search: bank_account_ids.first } }

      it 'returns filtered bank_accounts' do
        bank_accounts = described_class.call(bank_account_ids: user.bank_account_ids, params: params).bank_accounts.pluck(:id)

        expect(bank_accounts.first).to eq(bank_account_ids.first)
      end
    end

    context 'when params[:search] was not found' do
      let(:bank_account_ids) { user.bank_account_ids }
      let(:params) { { search: 'not_found' } }

      it 'returns empty array' do
        bank_accounts = described_class.call(bank_account_ids: user.bank_account_ids, params: params).bank_accounts

        expect(bank_accounts).to be_empty
      end
    end

    context 'when params[:search] is not present' do
      let(:bank_account_ids) { user.bank_account_ids }
      let(:params) { {} }

      it 'returns all user bank_accounts' do
        bank_accounts = described_class.call(bank_account_ids: user.bank_account_ids, params: params).bank_accounts.pluck(:id)

        expect(bank_accounts).to match_array(bank_account_ids)
      end
    end
  end
end
