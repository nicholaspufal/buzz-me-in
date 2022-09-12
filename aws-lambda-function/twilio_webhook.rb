require "twilio-ruby"

def verify_request_origin(event, context)
  # If the request is from Twilio proceed
  user_agent = event.dig("headers", "user-agent")
  unless user_agent && user_agent.downcase.include?("twilioproxy")
    puts "User-Agent is NOT Twilio-Proxy, it's #{user_agent}. Aborting..."
    return "Aborting. Invalid request."
  end
end

def send_messages
  client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_TOKEN"])
  twilio_phone_number = ENV.fetch("TWILIO_PHONE_NUMBER")
  destination_phone_numbers = ENV.fetch("DESTINATION_PHONE_NUMBERS", "").split(",")
  threads = []

  destination_phone_numbers.each do |destination_phone_number|
    threads << Thread.new do
      puts "Attempting to send the message to #{destination_phone_number}..."

      client.messages.create(
        from: twilio_phone_number,
        to: destination_phone_number,
        body: "Someone was buzzed in."
      )
    end
  end

  threads.each(&:join)
end

def twilio_postback_handler(event: nil, context: nil)
  verify_request_origin(event, context)
  send_messages
  puts "Messages sent!"
rescue StandardError => e
  puts "Failed to send Twilio SMS: #{e.message}"
end
