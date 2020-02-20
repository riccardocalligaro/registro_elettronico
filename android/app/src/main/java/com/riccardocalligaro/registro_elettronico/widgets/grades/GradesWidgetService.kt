package com.riccardocalligaro.registro_elettronico.widgets.grades

import android.content.Intent
import android.widget.RemoteViewsService

class GradesWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return GradesWidgetFactory(this.applicationContext, intent)
    }
}