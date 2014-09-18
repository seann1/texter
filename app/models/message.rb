class Message < ActiveRecord::Base


  validates :body, presence: true

  has_and_belongs_to_many :contacts
  belongs_to :user

  before_create :send_sms

private

  def send_sms
    begin
      response = RestClient::Request.new(
        :method => :post,
        :url => 'https://api.twilio.com/2010-04-01/Accounts/AC4fa11711494f06afa0c158ba71096d13/Messages.json',
        :user => ENV['TWILIO_ACCOUNT_SID'],
        :password => ENV['TWILIO_AUTH_TOKEN'],
        :payload => {
                    :Body => body,
                    :From => from,
                    :To => to
                    }
      ).execute
    rescue RestClient::BadRequest => error
      message = JSON.parse(error.response)['message']
      errors.add(:base, message)
      false
    end
  end

end

