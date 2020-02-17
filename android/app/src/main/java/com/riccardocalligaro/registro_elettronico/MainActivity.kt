package com.riccardocalligaro.registro_elettronico


import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.database.Cursor
import android.widget.RemoteViews
import androidx.annotation.NonNull
import com.riccardocalligaro.registro_elettronico.data.DBHelper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL_WIDGET = "com.riccardocalligaro.registro_elettronico/home_widget"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_WIDGET).setMethodCallHandler { call, result ->
            if (call.method == "updateWidgets") {
                val appWidgetManager = AppWidgetManager.getInstance(this)
                val remoteViews = RemoteViews(this.packageName, R.layout.timetable_widget)
                val thisWidget = ComponentName(this, TimetableWidget::class.java)

                val db = DBHelper(context)
                var cursor: Cursor? = null

                cursor = db.database.rawQuery("select * from lessons", null)
                var name = ""

                if (cursor!!.moveToFirst()) {
                    while (!cursor.isAfterLast) {

                        name = cursor.getString(cursor.getColumnIndex("author"))

                        cursor.moveToNext()
                    }
                }

                cursor.close();

                remoteViews.setTextViewText(R.id.appwidget_text, "Author: $name")
                appWidgetManager.updateAppWidget(thisWidget, remoteViews)
                result.success("Success")
            }

        }
    }
}