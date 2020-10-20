require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    before do
      @category = Category.new(name: 'life')
      @name = 'Giant Wheel of Cheese'
      @price = 500
      @quantity = 42
      
    end
    it 'should save name, price, quantity, category when provided' do
      @product = Product.new(name: @name, price: @price, quantity: @quantity, category: @category)
      @product.save!
      expect(@product.id).to be_present
    end
    it 'should ensure that a name is provided' do
      @product = Product.new(name: nil, price: @price, quantity: @quantity, category: @category)
      expect { @product.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(@product.errors.full_messages).to eq ['Name can\'t be blank']
    end
    it 'should ensure that a price is provided' do
      @product = Product.new(name: @name, price: nil, quantity: @quantity, category: @category)
      expect { @product.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(@product.errors.full_messages).to eq ["Price cents is not a number", "Price is not a number", "Price can't be blank"]
    end
    it 'should ensure that a quantity is provided' do
      @product = Product.new(name: @name, price: @price, quantity: nil, category: @category)
      expect { @product.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(@product.errors.full_messages).to eq ["Quantity can't be blank"]
    end
    it 'should ensure that a category is provided' do
      @product = Product.new(name: @name, price: @price, quantity: @quantity, category: nil)
      expect { @product.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(@product.errors.full_messages).to eq ["Category can't be blank"]
    end
  end
end
