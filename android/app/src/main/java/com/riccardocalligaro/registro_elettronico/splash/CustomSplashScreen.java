package com.riccardocalligaro.registro_elettronico.splash;

import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import org.jetbrains.annotations.NotNull;

import io.flutter.embedding.android.SplashScreen;


public class CustomSplashScreen implements SplashScreen {
    private CustomSplashScreenView splashView;

    @Nullable
    public View createSplashView(@NonNull Context context, @Nullable Bundle bundle) {
        if (splashView == null) {
            splashView = new CustomSplashScreenView(context);
        }
        return splashView;
    }

    //closing the splash
    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    public void transitionToFlutter(@NotNull Runnable onTransitionComplete) {
        if (splashView != null) {
            splashView.animateAway(onTransitionComplete);
        } else {
            onTransitionComplete.run();
        }
    }


}