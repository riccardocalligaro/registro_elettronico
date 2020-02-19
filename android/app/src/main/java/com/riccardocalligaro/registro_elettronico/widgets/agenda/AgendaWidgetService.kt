package com.riccardocalligaro.registro_elettronico.widgets.agenda

import android.content.Intent
import android.widget.RemoteViewsService

class AgendaWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return AgendaWidgetFactory(this.applicationContext, intent)
    }
}