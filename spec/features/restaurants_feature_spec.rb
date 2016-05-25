require 'rails_helper'

feature 'restaurants' do

  context 'when a user logged in' do
    before(:each) do
      visit('/')
      click_link('Sign up')
      fill_in('Email', with: 'test@example.com')
      fill_in('Password', with: 'testtest')
      fill_in('Password confirmation', with: 'testtest')
      click_button('Sign up')
    end

    context 'no restaurants have been added' do
      scenario 'should display a prompt to add a restaurant' do
        visit '/restaurants'
        expect(page).to have_content 'No restaurants yet'
        expect(page).to have_link 'Add a restaurant'
      end
    end

    context 'restaurants have been added' do
      before do
        Restaurant.create(name: 'KFC', description: 'The greatest chicken EVER.')
      end

      scenario 'display restaurants' do
        visit '/restaurants'
        expect(page).to have_content('KFC')
        expect(page).not_to have_content('No restaurants yet')
      end
    end

    context 'creating restaurants' do
      scenario 'prompts user to fill out a form, then displays the new restaurant' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'KFC'
        fill_in 'Description', with: 'The greatest chicken EVER.'
        click_button 'Create Restaurant'
        expect(page).to have_content 'KFC'
        expect(current_path).to eq '/restaurants'
      end

      context 'an invalid restaurant' do
        it 'does not let you submit a name that is too short' do
          visit '/restaurants'
          click_link 'Add a restaurant'
          fill_in 'Name', with: 'kf'
          click_button 'Create Restaurant'
          expect(page).not_to have_css 'h2', text: 'kf'
          expect(page).to have_content 'error'
        end
      end
    end

    context 'viewing restaurants' do

      let!(:kfc){ Restaurant.create(name:'KFC', description: 'The greatest chicken EVER.') }

      scenario 'lets a user view a restaurant' do
       visit '/restaurants'
       click_link 'KFC'
       expect(page).to have_content 'KFC'
       expect(page).to have_content 'The greatest chicken EVER.'
       expect(current_path).to eq "/restaurants/#{kfc.id}"
      end

    end

    context 'editing restaurants' do

    before { Restaurant.create name: 'KFC', description: 'Deep fried goodness' }

      scenario 'let a user edit a restaurant' do
       visit '/restaurants'
       click_link 'Edit KFC'
       fill_in 'Name', with: 'Kentucky Fried Chicken'
       fill_in 'Description', with: 'Deep fried goodness'
       click_button 'Update Restaurant'
       expect(page).to have_content 'Kentucky Fried Chicken'
       expect(page).to have_content 'Deep fried goodness'
       expect(current_path).to eq '/restaurants'
      end

    end

    context 'deleting restaurants' do

      before { Restaurant.create name: 'KFC', description: 'Deep fried goodness' }

      scenario 'removes a restaurant when a user clicks a delete link' do
        visit '/restaurants'
        click_link 'Delete KFC'
        expect(page).not_to have_content 'KFC'
        expect(current_path).to eq '/restaurants'
        expect(page).to have_content 'Restaurant deleted successfully'
      end
    end
  end

  context 'when not logged in' do
    let!(:kfc){ Restaurant.create(name:'KFC', description: 'The greatest chicken EVER.') }
    let!(:mcd){ Restaurant.create(name:'Mcdonalds', description: 'disgusting') }

    scenario 'visitor should not be able to create a restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      expect(current_path).to eq '/users/sign_in'
    end

    scenario 'visitor should be able to see the list of restaurants' do
      visit '/restaurants'
      expect(page).to have_content 'KFC'
      expect(page).to have_content 'Mcdonalds'
    end

    scenario 'visitor should be able to see individual restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(page).to have_content 'The greatest chicken EVER.'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end

  end

end
