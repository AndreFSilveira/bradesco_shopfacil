require 'socket'
require 'rest-client'

require_relative 'buyer_address'

module BradescoShopfacil

  module Buyer

    include BuyerAddress

    attr_accessor :buyer_name, :buyer_document, :buyer_http_user_agent, :buyer_ip

    def data_service_buyer
      buyer = {
          "nome" => buyer_name,
          "documento" => buyer_document,
          "endereco" => data_service_buyer_address,
          "ip" => nil,
          "user_agent" => get_http_user_agent
      }
      buyer
    end

    private

    def get_http_user_agent
      !buyer_http_user_agent.nil? ? buyer_http_user_agent : RestClient::Platform.default_user_agent
    end

  end

end
