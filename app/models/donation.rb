# frozen_string_literal: true

#
# A donation to the nipanipa cause
#
class Donation < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :feedback, optional: true

  validates :amount, numericality: { greater_than: 0 }

  def paypal_url(return_url)
    uri = self.class.base_uri
    uri.query = query(return_url)
    uri.to_s
  end

  def self.send_pdt_post(tx)
    http = Net::HTTP.new(base_uri.host, base_uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(base_uri.request_uri)
    post_params = { tx: tx, at: ENV["PAYPAL_PDT_AT"], cmd: "_notify-synch" }
    request.set_form_data(post_params)

    http.request(request)
  end

  def query(return_url)
    values = {
      business: ENV["PAYPAL_ACCOUNT"],
      cmd: "_donations",
      item_name: "Friends of NiPaNiPa",
      amount: amount,
      return: return_url,
      invoice: id
    }

    values.to_query
  end

  def self.base_uri
    URI::HTTP.build(host: ENV["PAYPAL_HOST"],
                    port: ENV["PAYPAL_PORT"],
                    path: "/cgi-bin/websrc")
  end
end
