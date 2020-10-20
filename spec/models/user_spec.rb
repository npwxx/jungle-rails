require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'should pass when all fields are provided and password and password_confirmation match' do
      @user = User.new(
        first_name: 'first name', last_name: 'last name', email: 'email@email.com',
        password: 'password', password_confirmation: 'password'
      )
      @user.save!
      expect(@user.id).to be_present
    end
    
    it 'should fail when password and password_confirmation do not match' do
      @user = User.new(
        first_name: 'first name', last_name: 'last name', email: 'email@email.com',
        password: 'password', password_confirmation: 'pass'
      )
      expect { @user.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(@user.errors.full_messages).to eq ['Password confirmation doesn\'t match Password']
    end
    
    it 'should fail if the email is already used' do
      User.create(first_name: 'first', last_name: 'last', email: 'EMAIL@email.com',
        password: 'pass', password_confirmation: 'pass')
      @user = User.new(
        first_name: 'first name', last_name: 'last name', email: 'email@email.com',
        password: 'password', password_confirmation: 'password'
      )
      expect { @user.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(@user.errors.full_messages).to eq ['Email has already been taken']
    end
    
    it 'should fail if email is not provided' do
      @user = User.new(
        first_name: 'first name', last_name: 'last name', email: nil,
        password: 'password', password_confirmation: 'password'
      )
      expect { @user.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(@user.errors.full_messages).to eq ['Email can\'t be blank']
    end
    
    it 'should fail if first_name is not provided' do
      @user = User.new(
        first_name: nil, last_name: 'last name', email: 'email',
        password: 'password', password_confirmation: 'password'
      )
      expect { @user.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(@user.errors.full_messages).to eq ['First name can\'t be blank']
    end
    
    it 'should fail if last_name is not provided' do
      @user = User.new(
        first_name: 'first name', last_name: nil, email: 'email',
        password: 'password', password_confirmation: 'password'
      )
      expect { @user.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(@user.errors.full_messages).to eq ['Last name can\'t be blank']
    end
    it 'should fail if password is less than 4 characters' do
      @user = User.new(
        first_name: 'first_name', last_name: 'last name', email: 'email',
        password: 'pas', password_confirmation: 'pas'
      )
      expect { @user.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(@user.errors.full_messages).to eq ['Password is too short (minimum is 4 characters)']
    end
  end

  describe '.authenticate_with_credentials' do
    before do
      @user = User.create(first_name: 'first name', last_name: 'last name', email: 'email@email.com',
        password: 'password', password_confirmation: 'password')
    end
    it 'should return user if email and password match' do
      user = User.authenticate_with_credentials(email: 'email@email.com', password: 'password')
      expect(user.id).to eq @user.id
    end
    it 'should return nil if email and password do not match' do
      user = User.authenticate_with_credentials(email: 'e@e.com', password: 'password')
      expect(user).to be_nil
    end
    it 'should trim email & return user if email and password match' do
      user = User.authenticate_with_credentials(email: ' email@email.com  ', password: 'password')
      expect(user.id).to eq @user.id
    end
    it 'should allow wrong case and return user if email and password match' do
      user = User.authenticate_with_credentials(email: 'eMail@emAil.com', password: 'password')
      expect(user.id).to eq @user.id
    end
  end
end
