package com.example.flutter_auth;

import io.inway.ringtone.player.FlutterRingtonePlayerPlugin;
import com.github.sathish76.flutter_dnd.FlutterDndPlugin;
import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;

public class Application extends FlutterApplication implements PluginRegistrantCallback {
  @Override
  public void onCreate() {
    super.onCreate();
    FlutterFirebaseMessagingService.setPluginRegistrant(this);
    // FlutterRingtonePlayerPlugin.setPluginRegistrant(this);
  }

  @Override
  public void registerWith(PluginRegistry registry) {
    FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
    FlutterRingtonePlayerPlugin.registerWith(registry.registrarFor("io.inway.ringtone.player.FlutterRingtonePlayerPlugin"));
    FlutterDndPlugin.registerWith(registry.registrarFor("import com.github.sathish76.flutter_dnd.FlutterDndPlugin"));
  }
}