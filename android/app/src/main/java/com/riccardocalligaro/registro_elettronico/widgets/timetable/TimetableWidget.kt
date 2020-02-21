package com.riccardocalligaro.registro_elettronico.widgets.timetable

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import android.widget.RemoteViews
import com.riccardocalligaro.registro_elettronico.R

/**
 * Implementation of App Widget functionality.
 */
class TimetableWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

internal fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {

    Log.i("TimetableWidget", "Update the widget")

    val intent = Intent(context, TimetableWidgetService::class.java).apply {
        putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
        data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
    }


    val rv = RemoteViews(context.packageName, R.layout.timetable_widget).apply {
        setRemoteAdapter(R.id.timetable_remote_list, intent)
        setEmptyView(R.id.timetable_remote_list, R.id.timetable_empty)
    }

    appWidgetManager.updateAppWidget(appWidgetId, rv)
    appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.timetable_remote_list)
}