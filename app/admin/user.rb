# frozen_string_literal: true

ActiveAdmin.register User do
  actions :all, except: :new

  permit_params :region_id, :locale, :description

  index do
    column(:name) { |user| link_to user.name, user_path(user) }
    column :email
    column :country
    column :region
    column :karma
    column :sign_in_count

    actions
  end

  filter :email
  filter :name

  form do |f|
    f.inputs "Information" do
      f.input :email
      f.input :description
    end

    f.inputs "Location" do
      f.input :country_id,
              collection: Country.options,
              input_html: {
                data: { "regions-url" => country_regions_path(":country_id") }
              },
              include_blank: false

      f.input :region_id,
              as: :select,
              collection: f.object.country.regions,
              include_blank: true
    end

    f.actions
  end
end
