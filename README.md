# swift-chat-example
Chat plugin example in Swift

## Features
This example app demonstrates basic usage of iOS Chat SDK, it implemented :

- Skygear basic authentication
- Create direct(one to one)/group conversation
- Add/remove conversation participants
- A simple chatroom
- Send Message with extra metadata field and image asset
- Unread conversations/messages count


## How to run this demo app

1. Register your app in https://portal.skygear.io/
1. You can find your cloud code repo in skygear
   [protal](http://portal.skygear.io)), `INFO` tab, the format is:
   `ssh://git@git.skygeario.com/<yourappname>.git`
1. Add your ssh key to [My Account](https://portal.skygear.io/user/settings)
1. To enable chat feature, you need to push Chat Plugin into your skygear
   server cloud code repository. Skygear Chat Plugin is located at
   https://github.com/SkygearIO/chat, you may also reference this for plugin
   tutorial https://docs.skygear.io/plugin/guide/first1.plugin
1. After you clone this project, run `pod install` under the directory.
1. to run `pod install`, you will need install https://cocoapods.org/
1. When you first launch app, it will ask you to configure `SkygearEndpoint`
   and `SkygearApiKey`, they are also in skygear protal `INFO` section:
   https://portal-staging.skygear.io/app/info.
1. Done!
