package com.riccardocalligaro.registro_elettronico.widgets.timetable

import android.content.Intent
import android.widget.RemoteViewsService


class TimetableWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return TimetableWidgetFactory(this.applicationContext, intent)
    }
}