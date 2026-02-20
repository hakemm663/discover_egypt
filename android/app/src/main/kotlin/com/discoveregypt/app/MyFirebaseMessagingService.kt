package com.discoveregypt.app

import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)

        try {
            if (remoteMessage.data.isNotEmpty()) {
                Log.d(TAG, "FCM data payload received with keys: ${remoteMessage.data.keys}")
            }

            remoteMessage.notification?.let { notification ->
                Log.d(TAG, "FCM notification received. title=${notification.title}, body=${notification.body}")
            }
        } catch (exception: Exception) {
            Log.e(TAG, "Error while handling FCM message", exception)
        }
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)

        if (token.isBlank()) {
            Log.w(TAG, "Received blank FCM token; skipping update")
            return
        }

        try {
            Log.d(TAG, "FCM token refreshed")
            // TODO: Send the token to your backend when server-side push notifications are enabled.
        } catch (exception: Exception) {
            Log.e(TAG, "Error while processing refreshed FCM token", exception)
        }
    }

    private companion object {
        private const val TAG = "MyFirebaseMsgService"
    }
}
