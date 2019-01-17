require 'base64'
require 'rest-client'

require 'bradesco_shopfacil/version'
require 'bradesco_shopfacil/buyer'
require 'bradesco_shopfacil/buyer_address'
require 'bradesco_shopfacil/bank_slip'
require 'bradesco_shopfacil/bank_slip_instructions'
require 'bradesco_shopfacil/order'

module BradescoShopfacil

  class Shopfacil

    include Order, Buyer, BankSlip

    attr_accessor :media_type, :charset, :sandbox, :token_request_confirmation_payment

    URL_HOMOLOGACAO = 'https://homolog.meiosdepagamentobradesco.com.br'
    URL_PRODUCAO = 'https://meiosdepagamentobradesco.com.br'

    def media_type
      @media_type ||= 'application/json'
    end

    def charset
      @charset ||= 'UTF-8'
    end

    def sandbox
      @sandbox ||= false
    end

    def initialize(merchant_id, security_key)
      @merchant_id = merchant_id
      @security_key = security_key
    end

    def data_service_request

      service_request = {
          "merchant_id" => @merchant_id,
          "meio_pagamento" => "300",
          "pedido" => data_service_order,
          "comprador" => data_service_buyer,
          "boleto" => data_service_bank_slip,
          "token_request_confirmacao_pagamento" => token_request_confirmation_payment
      }
      service_request

      send_data('/apiboleto/transacao', service_request)

    end

    def send_data(params_url, params_data = nil)

      if sandbox
        auth_token = "Basic MTAwMDA2NTQ4Olo3ZFc1M3h5TlJUOXBuZ0xSYTZkajM0VmpjbDc5bDhiNXRibHA5TTcwMnc="
        url_bradesco = URL_HOMOLOGACAO
      else
        auth_token = "Basic MTAwMDA2NTQ4OnhlbHdUX2R2WG1TUm02Q1h6bXJIQ29SOEhRaHM0Y1lrVi1aZmJMLVJia3M="
        url_bradesco = URL_PRODUCAO
      end

      url = "#{url_bradesco}#{params_url}"


      headers = {
          "Accept": media_type,
          "Accept-Charset": charset,
          "Accept-Encoding": media_type,
          content_type: "#{media_type};charset=#{charset}",
          Authorization: "#{auth_token}"
      }
      response = RestClient.post url, params_data.to_json, headers

      JSON.parse response.body

    end

  end

end