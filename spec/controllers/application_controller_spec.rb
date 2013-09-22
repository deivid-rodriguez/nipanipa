# Nothing routes to ApplicationController so just choose one controller
describe StaticPagesController do
  before { @old_locale = I18n.locale }
  after { I18n.locale = @old_locale }

  context 'locale is set as a parameter' do
    before do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'en'
      get :home, locale: :es
    end

    it 'is asssigned from parameter' do
      expect(I18n.locale).to eq(:es)
    end
  end

  context 'locale not set as a parameter' do
    before do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'en'
      get :home
    end

    it 'is assigned from user preference' do
      expect(I18n.locale).to eq(:en)
    end
  end

  context 'locale not set as a parameter nor in HTTP_ACCEPT_LANGUAGE' do
    before do
      request.env.delete('HTTP_ACCEPT_LANGUAGE')
      get :home
    end

    it 'is assigned from default language' do
      expect(I18n.locale).to eq(I18n.default_locale)
    end
  end
end

