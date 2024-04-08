# frozen_string_literal: true

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  #  Include in this method the setting of objects that will be needed in more than one test
  def setup; end

  test 'category should be valid' do
    @category = Category.new(name: 'Sports')
    assert @category.valid?
  end

  test 'name should be present' do
    @category = Category.new(name: '')
    assert_not @category.valid?
  end

  test 'name should be unique' do
    @category1 = Category.new(name: 'Sports')
    @category1.save
    @category2 = Category.new(name: 'sports')
    assert_not @category2.valid?
  end

  test 'name should not be too long' do
    @category = Category.create(name: '0123456789_0123456789')
    assert_not @category.valid?
  end

  test 'name should not be too short' do
    @category = Category.create(name: '01')
    assert_not @category.valid?
  end
end
