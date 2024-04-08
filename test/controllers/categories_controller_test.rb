# frozen_string_literal: true

require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = Category.create(name: 'Bugs')
    @admin_user = User.create(username: 'Bob', email_address: 'bob@bob.com',
                              password: 'password', admin: true)
  end

  test 'should get index' do
    get categories_url
    assert_response :success
  end

  test 'should get to new form' do
    #  sign_in_as is defined in test_helper
    sign_in_as(@admin_user)
    get new_category_url
    assert_response :success
  end

  test 'should not create category if not admin user' do
    assert_no_difference('Category.count') do
      post categories_url, params: { category: { name: 'Travel' } }
    end

    assert_redirected_to categories_url
  end

  test 'should create category if admin user' do
    #  sign_in_as is defined in test_helper
    sign_in_as(@admin_user)
    assert_difference('Category.count', 1) do
      post categories_url, params: { category: { name: 'Travel' } }
    end

    assert_redirected_to categories_url
  end

  # test 'should show category' do
  #   @category = Category.create(name: 'Bugs')
  #   @categories = Category.all
  #   get category_url(@category)
  #   assert_response :success
  # end

  # test 'should get edit' do
  #   get edit_category_url(@category)
  #   assert_response :success
  # end

  # test 'should update category' do
  #   patch category_url(@category), params: { category: {} }
  #   assert_redirected_to category_url(@category)
  # end

  # test 'should destroy category' do
  #   assert_difference('Category.count', -1) do
  #     delete category_url(@category)
  #   end

  #   assert_redirected_to categories_url
  # end
end
