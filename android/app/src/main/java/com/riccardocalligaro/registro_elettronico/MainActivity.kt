package com.riccardocalligaro.registro_elettronico


import androidx.annotation.NonNull
import com.riccardocalligaro.registro_elettronico.splash.CustomSplashScreen
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.SplashScreen
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

    override fun provideSplashScreen(): SplashScreen? {
        return CustomSplashScreen()
    }
}