[![Build Status](https://travis-ci.org/atkit/TryUserNotifications.svg?branch=master)](https://travis-ci.org/atkit/TryUserNotifications)

The purpose of this small project is to learn and share how to use iOS10 UserNotifications.framework for local and remote notifications

![tab 2](https://raw.githubusercontent.com/atkit/TryUserNotifications/master/Screenshots/tab-2.jpg)
![tab 3](https://raw.githubusercontent.com/atkit/TryUserNotifications/master/Screenshots/tab-3.jpg)

## Sending Pushes using [Houston](https://github.com/nomad/houston):
- Put your dev-push.pem (see Houston instruction how to create one) to ./Secret folder (convert_certificate.sh can help)
- use ./send_push.rb <Device ID>
- use ./send_push_with_image.rb <Device ID>

<Device ID> is printed to console on app start
