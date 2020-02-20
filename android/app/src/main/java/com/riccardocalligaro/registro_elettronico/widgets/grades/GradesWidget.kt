package com.riccardocalligaro.registro_elettronico.widgets.grades

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import com.riccardocalligaro.registro_elettronico.R

/**
 * Implementation of App Widget functionality.
 */
class GradesWidget : AppWidgetProvider() {
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
    val intent = Intent(context, GradesWidgetService::class.java).apply {
        putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
        data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
    }


    val rv = RemoteViews(context.packageName, R.layout.grades_widget).apply {
        setRemoteAdapter(R.id.grades_remote_list, intent)
        setEmptyView(R.id.grades_remote_list, R.id.grades_empty)
    }

    appWidgetManager.updateAppWidget(appWidgetId, rv)
    appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.grades_remote_list)
}