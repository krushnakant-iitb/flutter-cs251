package com.example.flutter_auth

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.app.NotificationManager
import android.app.NotificationChannel
import android.net.Uri
import android.media.AudioAttributes
import android.content.ContentResolver
import android.media.RingtoneManager

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,"com.example.flutter_auth/1").setMethodCallHandler {
            call, result ->
            if (call.method == "createNotificationChannel") {
                val argData = call.arguments as java.util.HashMap<String, String>
                    val completed = createNotificationChannel(argData)
                    if(completed == true){
                        result.success(completed)
                    }
                    else{
                        result.error("Error Code", "Error Message", null)
                    }
            } else{
              result.notImplemented()
            }
        }
    }
    private fun createNotificationChannel(mapData: HashMap<String,String>): Boolean{
        val completed:Boolean
        if (VERSION.SDK_INT >= VERSION_CODES.O){
            val id=mapData["id"]
            val name=mapData["name"]
            val descriptionText=mapData["description"]
            val importance=NotificationManager.IMPORTANCE_MAX
            val mChannel=NotificationChannel(id,name,importance)
            mChannel.description=descriptionText
            mChannel.enableVibration(true)
            mChannel.setBypassDnd(false)
            val alarmTone = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            val att=AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build()
            mChannel.setSound(alarmTone, att)
            val notificationmanager=getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationmanager.createNotificationChannel(mChannel)
            completed=true
        }
        else{
            completed=false
        }
        return completed
    }
}
