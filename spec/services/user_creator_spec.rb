require 'rails_helper'

RSpec.describe UserCreator do
  let(:user_params) { { name: 'John',
    surname: 'Doe', password: 'Asssss1*',
    password_confirmation: 'Asssss1*',
    email: FFaker::Internet.email } }

  context 'when user params are valid' do
    it 'creates a user' do
      service = described_class.call(user_params: user_params)
      expect(service.user).to be_persisted
      expect(service).to be_success
    end

    it 'creates a bank account' do
      service = described_class.call(user_params: user_params)
      bank_account = service.user.bank_accounts.first
      expect(bank_account).to be_persisted
      expect(bank_account.amount).to eq(1000)
    end
  end

  context 'when user params have invalid values' do
    context 'with missing name' do
      it 'returns an user with errors' do
        user_params[:name] = nil
        service = described_class.call(user_params: user_params)
        expect(service).to be_success
        expect(service.user.errors.full_messages).to include("Name can't be blank")
      end
    end

    context 'with missing surname' do
      it 'returns an error' do
        user_params[:surname] = nil
        service = described_class.call(user_params: user_params)
        expect(service).to be_success
        expect(service.user.errors.full_messages).to include("Surname can't be blank")
      end
    end

    context 'with invalid password' do
      it 'returns an user with errors' do
        user_params[:password] = '123'
        service = described_class.call(user_params: user_params)
        expect(service).to be_success
        expect(service.user.errors.full_messages).to include('Password is too short (minimum is 8 characters)')
      end
    end

    context 'with already existing email' do
      it 'returns an user with errors' do
        FactoryBot.create(:user, email: user_params[:email])
        service = described_class.call(user_params: user_params)
        expect(service).to be_success
        expect(service.user.errors.full_messages).to include('Email has already been taken')
      end
    end
  end
end
