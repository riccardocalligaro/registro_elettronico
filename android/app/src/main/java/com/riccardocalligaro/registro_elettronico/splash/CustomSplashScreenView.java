package com.riccardocalligaro.registro_elettronico.splash;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Color;
import android.os.Build;
import android.view.Gravity;
import android.view.ViewPropertyAnimator;
import android.widget.FrameLayout;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.riccardocalligaro.registro_elettronico.R;

public class CustomSplashScreenView extends FrameLayout {

    private ImageView flutterLogo;
    private Runnable onTransitionComplete;
    private ViewPropertyAnimator fadeAnimator;


    //main function
    @SuppressLint("NewApi")
    public CustomSplashScreenView(Context context) {
        super(context);
        setBackgroundColor(Color.parseColor("#212121"));
        flutterLogo = new ImageView(getContext());
        flutterLogo.setImageDrawable(getResources().getDrawable(R.drawable.launch_background, getContext().getTheme()));
        addView(flutterLogo, new FrameLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT, Gravity.CENTER));
    }


    //transition animation
    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    public void animateAway(@NonNull Runnable onTransitionComplete) {
        fadeAnimator = animate()
                .alpha(0.0f)
                .setDuration(0);
        fadeAnimator.start();
    }

    @SuppressLint("NewApi")
    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
    }

}