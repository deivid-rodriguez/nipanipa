if Rails.env.development?
  %w( user host volunteer  ).each do |c|
    require_dependency File.join('app', 'models', "#{c}.rb")
  end
end
