package com.riccardocalligaro.registro_elettronico

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.ArrayAdapter
import android.widget.ListView
import android.widget.RemoteViews

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
    val widgetText = context.getString(R.string.appwidget_text)
    // Construct the RemoteViews object
    val views = RemoteViews(context.packageName, R.layout.timetable_widget)
    //views.setTextViewText(R.id.appwidget_text, widgetText)



//    val listView = R.id.timetable_list

    val words = listOf("Test1", "Test2")


    val listItems = arrayOfNulls<String>(words.size)

    for (i in words.indices) {
        val word = words[i]
        listItems[i] = words[i]
    }


    val adapter = ArrayAdapter(context, android.R.layout.simple_dropdown_item_1line, listItems)

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}