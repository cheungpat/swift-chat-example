// TODO: This model should be included in JS SDK
class PushNotification {
  constructor({title, message}) {
    this._title = title;
    this._message = message;

    this.toJSON = this.toJSON.bind(this);
  }

  get title() {
    return this._title || '';
  }

  get message() {
    return this._message || '';
  }

  toJSON() {
    return {
      apns: {
        aps: {
          alert: this.message,
          sound: 'default',
          badge: 1
        },
        from: 'skygear',
        operation: 'notification'
      },
      gcm: {
        notification: {
          title: this.title,
          body: this.message
        },
        data: {
          from: 'skygear',
          operation: 'notification'
        }
      }
    }
  }
}

module.exports = {
  PushNotification
};
