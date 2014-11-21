ActiveAdmin.register Country do
  permit_params :code, regions_attributes: [:id, :code, :name, :_destroy]

  form do |f|
    f.inputs 'Country Info' do
      f.input :code
    end

    f.has_many :regions, new_record: true do |rf|
      rf.input :code
      rf.input :name
      rf.input :_destroy, as: :boolean, label: 'Remove?'
    end

    f.actions
  end

  index do
    column :name
    column :code

    [:created_at, :updated_at].each do |col|
      column col, sortable: col do |country|
        country.send(col).strftime('%m/%d/%y')
      end
    end

    actions
  end
end
