#
# Unit tests for Country model
#
RSpec.describe Country do
  let!(:country) { build(:country, code: 'DE') }

  it 'has a code' do
    country.code = nil

    expect(country).not_to be_valid
  end

  it 'has a unique code' do
    create(:country, code: country.code)

    expect(country).not_to be_valid
  end

  it 'has a continent' do
    country.continent = nil

    expect(country).not_to be_valid
  end
end
