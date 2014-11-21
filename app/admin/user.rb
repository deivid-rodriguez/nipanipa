ActiveAdmin.register User do
  config.filters = false
  actions :all, except: [:new, :destroy]

  permit_params :region_id, :locale

  index do
    column :name
    column :email
    column :country
    column :region

    column :old_region do |user|
      user.state
    end

    column :old_country do |user|
      user.read_attribute(:country)
    end

    column :old_latitude do |user|
      user.latitude
    end

    column :old_longitude do |user|
      user.longitude
    end

    column :karma

    actions
  end

  form do |f|
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

    f.actions
  end
end
