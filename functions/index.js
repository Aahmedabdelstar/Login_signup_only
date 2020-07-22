const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.notifications = functions.database.ref('notifications/{id}').onCreate((snapshot, context) => {
                         msgData = snapshot.val();



                            const payload = {
                                    notification:{
                                        title : msgData.title,
                                        body : msgData.message,
                                        badge : '1',
                                        sound : 'default'
                                    }
                                };

    return admin.database().ref('fcm-token').once('value').then(allToken => {
        if(allToken.val()){
            console.log('token available');
            const token = Object.keys(allToken.val());
            return admin.messaging().sendToDevice(token,payload);
        }else{
            console.log('No token available');
        }
    });
});