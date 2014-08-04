#
# Integration tests for Picture pages
#

RSpec.describe 'Uploading a new picture' do
  let!(:picture) { build(:picture) }

  subject { page }

  before do
    visit root_path
    sign_in picture.user
    click_link t('shared.profile_header.pictures'), match: :first
    click_link t('pictures.index.new_picture')
    fill_in 'picture[name]', with: picture.name
  end

  describe 'successfully' do
    before do
      attach_file 'picture[image]', 'spec/fixtures/test_image.png'
      click_button t('helpers.submit.picture.create')
    end

    it { is_expected.to have_selector 'div.picture-thumbnail', 'test_image.png' }
    it { is_expected.to have_flash_message t('pictures.create.success'), 'success' }
  end

  describe 'unsuccessfully' do
    before do
      attach_file 'picture[image]', 'spec/fixtures/test_image.txt'
      click_button t('helpers.submit.picture.create')
    end

    it { is_expected.not_to have_selector 'div.picture-thumbnail', 'test_image.txt' }
    it { is_expected.to have_flash_message t('pictures.create.error'), 'error' }
  end
end

RSpec.describe 'Updating a picture' do
  let!(:picture) { create(:picture) }

  subject { page }

  before do
    visit root_path
    sign_in picture.user
    click_link t('shared.profile_header.pictures'), match: :first
    click_link t('pictures.pictures.edit')
  end

  describe 'successfully' do
    before do
      fill_in 'picture[name]', with: 'New name for my pic'
      click_button t('helpers.submit.picture.update')
    end

    it { is_expected.to have_selector 'div.picture-thumbnail', 'New name for my pic' }
    it { is_expected.to have_flash_message t('pictures.update.success'), 'success' }
  end

  describe 'unsuccessfully' do
    before do
      attach_file 'picture[image]', 'spec/fixtures/test_image.txt'
      click_button t('helpers.submit.picture.update')
    end

    it { is_expected.not_to have_selector 'div.picture-thumbnail', picture.name }
    it { is_expected.to have_flash_message t('pictures.update.error'), 'error' }
  end
end

RSpec.describe 'Removing a picture' do
  let!(:picture) { create(:picture) }

  subject { page }

  before do
    visit root_path
    sign_in picture.user
    click_link t('shared.profile_header.pictures'), match: :first
    click_link t('pictures.pictures.delete')
  end

  it { is_expected.not_to have_selector 'div.picture-thumbnail' }
  it { is_expected.to have_flash_message t('pictures.destroy.success'), 'success' }
end
