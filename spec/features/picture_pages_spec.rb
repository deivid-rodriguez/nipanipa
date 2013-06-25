#
# Integration tests for Picture pages
#

describe 'Uploading a new picture' do
  let!(:picture) { build(:picture) }

  subject { page }

  before do
    visit root_path
    sign_in picture.user
    click_link t('shared.profile_header.pictures')
    click_link t('pictures.index.new_picture')
    fill_in 'picture[name]', with: picture.name
    attach_file 'picture[image]', 'spec/support/test_image.png'
  end

  context 'as main picture' do
    before do
      check 'picture[avatar]'
      click_button t('helpers.submit.picture.create')
    end

    it { should have_selector 'div.user-picture', 'test_image.png' }
    it { should have_flash_message t('pictures.create.success'), 'success' }
  end

  context 'as secondary picture' do
    before do
      click_button t('helpers.submit.picture.create')
    end

    it { should have_selector 'div.picture-thumbnail', 'test_image.png' }
    it { should have_flash_message t('pictures.create.success'), 'success' }
  end


end
