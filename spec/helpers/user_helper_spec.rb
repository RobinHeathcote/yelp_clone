require 'rails_helper'


  def sign_up_test(email: 'test@example.com' )
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: email)
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
  end

  def create_restaurant(name: 'KFC')
    visit '/restaurants'
    click_link 'Add a restaurant'
    fill_in 'Name', with: name
    fill_in 'Description', with: 'The greatest chicken EVER.'
    click_button 'Create Restaurant'
  end
