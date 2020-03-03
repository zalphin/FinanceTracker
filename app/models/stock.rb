class Stock < ApplicationRecord
	has_many :user_stocks
	has_many :users, through: :user_stocks
	before_save { self.ticker = ticker.upcase }
	validates :name, :ticker, presence: true
	
	def self.new_lookup(ticker_symbol)
		ticker_symbol.upcase!
		client = IEX::Api::Client.new(
		  publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
		  secret_token: Rails.application.credentials.iex_client[:sandbox_api_secret],
		  endpoint: 'https://sandbox.iexapis.com/v1'
		)
		begin
			new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol))
		rescue => exception
			return nil
		end
	end
	
	def self.check_db(ticker_symbol)
		ticker_symbol.upcase!
		where(ticker: ticker_symbol).first
	end
end
