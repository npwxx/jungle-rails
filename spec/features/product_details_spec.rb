require 'rails_helper'

RSpec.feature "ProductDetails", type: :feature, js: true do
    # SETUP
  before :each do
    @category = Category.create! name: 'Apparel'
  
    10.times do |n|
      @category.products.create!(
        name:  Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end

  scenario "They see product detail page" do
    # ACT
    visit root_path
    # click_link 'blah'
    # click_link @category.product.name
    # puts page.html
    # within "article" do   click_link("/products/1", :match => :first) end
    find("article a[href='/products/1']", :match => :first).click
    # VERIFY /DEBUG
    expect(page).to have_css 'article.product-detail'
    save_screenshot
  end

end
