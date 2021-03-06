#!/usr/bin/env ruby

require 'houston'

if ARGV.empty?
  puts "Please provide token as first argument"
  exit
end
token = ARGV.first
puts "Sending Push to Token: #{token}"

certificatePath = File.join(File.dirname(__FILE__), "../Secret/dev-push.pem")

# Environment variables are automatically read, or can be overridden by any specified options. You can also
# conveniently use `Houston::Client.development` or `Houston::Client.production`.
APN = Houston::Client.development
APN.certificate = File.read(certificatePath)

# Create a notification that alerts a message to the user, plays a sound, and sets the badge on the app
notification = Houston::Notification.new(device: token)
notification.alert = {body: "Checkout Rundom Emoji Inside", title: "Emoji Time" }
notification.sound = "default"
notification.category = "custom-ui"
# Notifications can also change the badge count, have a custom sound, have a category identifier, indicate available Newsstand content, or pass along arbitrary data.
# notification.badge = 57
# notification.category = "INVITE_CATEGORY"

# Image Data
notification.custom_data = { 'text' => '🙏' }

puts(notification.payload)

# And... sent! That's all it takes.
APN.push(notification)
