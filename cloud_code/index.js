const _ = require('lodash');

const skygear = require('skygear');
const skygearCloud = require('skygear/cloud');

const UserConversation = skygear.Record.extend('user_conversation');

const { PushNotification } = require('./models');

let skygearMasterContainer;

skygearCloud.event('after-plugins-ready', () => {
  const settings = skygearCloud.settings;
  const container = new skygearCloud.CloudCodeContainer();
  return container.config({
    apiKey: skygearCloud.settings.masterKey,
    endPoint: skygearCloud.settings.skygearEndpoint + '/'
  }).then((_container) => {
    skygearMasterContainer = _container;
    return {
      success: true
    };
  });
});

skygearCloud.afterSave('message', (newMessage, originalMessage) => {
  if (originalMessage === null) {
    // this is a newly created message
    const conversationId = skygear.Record.parseID(newMessage.conversation_id.id)[1];
    const userConversationQuery =
      new skygear.Query(UserConversation)
      .equalTo('conversation', conversationId);

    skygearMasterContainer.publicDB.query(userConversationQuery)
      .then((userConversations) => {
        if (userConversations.length === 0) {
          return;
        }

        const userIds = _.map(userConversations, (perUserConversation) => {
          const perUser = perUserConversation.user;
          return skygear.Record.parseID(perUser.id)[1];
        });

        const notification = new PushNotification({
          title: 'SKygear Chat Demo',
          message: 'You have a new message'
        });

        return skygearMasterContainer.makeRequest('push:user', {
          user_ids: userIds,
          notification: notification.toJSON()
        });
      })
      .then(() => {
        console.log('Push notification sent');
      })
      .catch((err) => {
        console.log('Fail to send push notification');
        console.error(err);
      });
  }
}, {
  async: true
});
