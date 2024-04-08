# frozen_string_literal: true

require 'test_helper'

class CreateCategoryTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = User.create(username: 'Bob', email_address: 'bob@bob.com',
                              password: 'password', admin: true)
    #  sign_in_as is defined in test_helper
    sign_in_as(@admin_user)
  end

  test 'get new category form and create category' do
    get '/categories/new'
    assert_response :success
    assert_difference 'Category.count', 1 do
      post categories_path, params: { category: { name: 'Sports' } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match 'Sports', response.body
  end

  test 'get new category form and reject non-unique category' do
    get '/categories/new'
    assert_response :success
    post categories_path, params: { category: { name: 'Sports' } }
    assert_no_difference 'Category.count' do
      get '/categories/new'
      assert_response :success
      post categories_path, params: { category: { name: 'Sports' } }
    end
  end

  test 'get new category form and reject category too short' do
    assert_no_difference 'Category.count' do
      get '/categories/new'
      assert_response :success
      post categories_path, params: { category: { name: '12' } }
    end
  end

  test 'get new category form and reject category too long' do
    assert_no_difference 'Category.count' do
      get '/categories/new'
      assert_response :success
      post categories_path, params: { category: { name: '012345678901234567890' } }
    end
  end
end
