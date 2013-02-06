class Donation < ActiveRecord::Base
  attr_accessible :user_id, :amount

  belongs_to :user

  def paypal_url(return_url)
    values = {
      business: ENV["PAYPAL_ACCOUNT"],
      cmd: '_donations',
      item_name: 'Friends of NiPaNiPa',
      amount: self.amount,
      return: return_url,
      invoice: id,
    }
    ENV["PAYPAL_URL"] + values.to_query
  end

  def self.send_pdt_post(tx)
    post_params = {
        tx: tx,
        at: ENV["PAYPAL_PDT_AT"],
        cmd: '_notify-synch'
    }
    uri = URI.parse(ENV["PAYPAL_URL"])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data( post_params )
    http.request(request)
  end

end
