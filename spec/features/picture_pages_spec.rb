# frozen_string_literal: true

#
# Integration tests for Picture pages
#
RSpec.describe "Uploading a new picture" do
  let!(:picture) { build(:picture) }

  before do
    visit root_path
    sign_in picture.user
    click_link t("shared.profile_header.pictures"), match: :first
    click_link t("pictures.index.new_picture")
    fill_in "picture[name]", with: picture.name
  end

  describe "successfully" do
    before do
      attach_file "picture[image]", "spec/fixtures/test_img.png"
      click_button t("helpers.submit.picture.create")
    end

    it "displays thumbnail in page" do
      expect(page).to have_selector "div.picture-thumbnail img"
    end

    it "shows a success flash message" do
      expect(page).to \
        have_flash_message t("pictures.create.success"), "success"
    end
  end

  describe "unsuccessfully" do
    before do
      attach_file "picture[image]", "spec/fixtures/test_img.txt"
      click_button t("helpers.submit.picture.create")
    end

    it "does not display any thumbnail in page" do
      expect(page).not_to have_selector "div.picture-thumbnail img"
    end

    it "show an error flash message" do
      expect(page).to have_flash_message t("pictures.create.error"), "danger"
    end
  end
end

RSpec.describe "Updating a picture" do
  let!(:picture) { create(:picture) }

  before do
    visit root_path
    sign_in picture.user
    click_link t("shared.profile_header.pictures"), match: :first
    click_link t("pictures.pictures.edit")
  end

  describe "successfully" do
    before do
      fill_in "picture[name]", with: "New name for pic"
      click_button t("helpers.submit.picture.update")
    end

    it "displays the new picture in page" do
      expect(page).to \
        have_selector "div.picture-thumbnail", text: "New name for pic"
    end

    it "shows a success flash message" do
      expect(page).to \
        have_flash_message t("pictures.update.success"), "success"
    end
  end

  describe "unsuccessfully" do
    before do
      attach_file "picture[image]", "spec/fixtures/test_img.txt"
      click_button t("helpers.submit.picture.update")
    end

    it "does not show the new picture in page" do
      expect(page).not_to \
        have_selector "div.picture-thumbnail", text: picture.name
    end

    it "shows an error flash message" do
      expect(page).to have_flash_message t("pictures.update.error"), "danger"
    end
  end
end

RSpec.describe "Removing a picture" do
  let!(:picture) { create(:picture) }

  before do
    visit root_path
    sign_in picture.user
    click_link t("shared.profile_header.pictures"), match: :first
    click_link t("pictures.pictures.delete")
  end

  it "does not display the removed picture" do
    expect(page).not_to have_selector "div.picture-thumbnail"
  end

  it "shows a success flash message" do
    expect(page).to have_flash_message t("pictures.destroy.success"), "success"
  end
end
