# swift-chat-example
Chat plugin example in Swift

## Features
This example app demonstrate basic usage of iOS Chat SDK, it implemented :

- Skygear basic authentication
- Unread conversations/messages count
- Create direct(one to one)/group conversation
- A simple chatroom
- Send Message with extra metadata field and image asset
- Add/remove conversation participants


## How to run this demo app

- Register your app in https://skygear.io/
- To enable chat feature, you need to push Chat Plugin into your skygear server cloud code repository.
- Skygear Chat Plugin : https://github.com/SkygearIO/chat, you may also reference this for plugin tutorial https://docs.skygear.io/plugin/guide/first-plugin
- you can found your cloud code repo in skygear protal, INFO tab, it will usually like `ssh://git@git.skygeario.com/<yourappname>.git`, please don't forget add your ssh key.
- After you clone this project, run `pod install` under the directory.
- to run `pod install`, you will need install https://cocoapods.org/
- When you first launch app, it will ask you to configure `SkygearEndpoint` and `SkygearApiKey`, they are also in skygear protal.
- Done!