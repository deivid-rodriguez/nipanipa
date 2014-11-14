ActiveAdmin.register User do
  permit_params :name, :email, :state, :region, :karma

  index do
    column :name
    column :email
    column :state
    column :region
    column :karma

    actions
  end

  form do |f|
    f.input :country
    f.input :region

    f.actions
  end

  filter :country
end
