ActiveAdmin.register User do
  config.filters = false
  actions :all, except: [:new, :destroy]

  permit_params :region_id, :locale

  index do
    column :name
    column :email
    column :country
    column :region
    column :karma

    actions
  end

  form do |f|
    f.inputs 'Information' do
      f.input :email,  input_html: { disabled: true }
      f.input :description, input_html: { disabled: true }
    end

    f.inputs 'Location' do
      f.label 'Country', for: 'user_region'
      f.collection_select :country,
                          Country.all.sort_by(&:name),
                          :id,
                          :name,
                          include_blank: true

      f.label 'Region', for: 'user_country'
      f.grouped_collection_select :region_id,
                                  Country.includes(:regions),
                                  :regions,
                                  :name,
                                  :id,
                                  :name,
                                  include_blank: true
    end

    f.actions
  end
end
