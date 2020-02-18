package com.riccardocalligaro.registro_elettronico.widgets

import android.appwidget.AppWidgetManager.INVALID_APPWIDGET_ID
import android.appwidget.AppWidgetManager.EXTRA_APPWIDGET_ID
import android.content.Intent
import android.widget.RemoteViewsService


class TimetableService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        intent.getIntExtra(
                EXTRA_APPWIDGET_ID,
                INVALID_APPWIDGET_ID)

        return ListProvider(this.applicationContext, intent)
    }

}