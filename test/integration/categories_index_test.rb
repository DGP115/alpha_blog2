# frozen_string_literal: true

require 'test_helper'

class CategoriesIndexTest < ActionDispatch::IntegrationTest
  def setup
    @category1 = Category.create(name: 'Sports')
    @category2 = Category.create(name: 'Travel')
  end

  test 'categories index shows catagory names as links' do
    get '/categories'
    assert_select 'a[href=?]', category_path(@category1), text: @category1.name
    assert_select 'a[href=?]', category_path(@category2), text: @category2.name
  end
end
