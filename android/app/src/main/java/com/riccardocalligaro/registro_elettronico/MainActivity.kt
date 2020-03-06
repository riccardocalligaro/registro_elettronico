package com.riccardocalligaro.registro_elettronico


import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.util.Log
import androidx.annotation.NonNull
import com.riccardocalligaro.registro_elettronico.widgets.agenda.AgendaWidget
import com.riccardocalligaro.registro_elettronico.widgets.grades.GradesWidget
import com.riccardocalligaro.registro_elettronico.widgets.timetable.TimetableWidget
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {
    private val CHANNEL_WIDGET = "com.riccardocalligaro.registro_elettronico/home_widget"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {

        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_WIDGET).setMethodCallHandler { call, result ->

            Log.i("MethodChannel", "Got call $call")

            when (call.method) {
                "updateTimetableWidget" -> {
                    val appWidgetManager = AppWidgetManager.getInstance(this)
                    val thisWidget = ComponentName(this, TimetableWidget::class.java)
                    val appWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
                    appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetIds, R.id.timetable_remote_list)
                    result.success("Success")
                }
                "updateAgendaWidget" -> {
                    val appWidgetManager = AppWidgetManager.getInstance(this)
                    val thisWidget = ComponentName(this, AgendaWidget::class.java)
                    val appWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
                    appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetIds, R.id.agenda_remote_list)
                    result.success("Success")
                }
                "updateGradesWidget" -> {
                    val appWidgetManager = AppWidgetManager.getInstance(this)
                    val thisWidget = ComponentName(this, GradesWidget::class.java)
                    val appWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
                    appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetIds, R.id.grades_remote_list)
                    result.success("Success")
                }
            }
//            if (call.method == "updateTimetableWidget") {
//                val appWidgetManager = AppWidgetManager.getInstance(this)
//                val thisWidget = ComponentName(this, TimetableWidget::class.java)
//                val appWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
//                appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetIds, R.id.timetable_remote_list)
//                result.success("Success")
//            }

        }
    }
}