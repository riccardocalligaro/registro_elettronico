package com.riccardocalligaro.registro_elettronico.widgets.agenda

import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import androidx.appcompat.content.res.AppCompatResources.getDrawable
import com.riccardocalligaro.registro_elettronico.R
import com.riccardocalligaro.registro_elettronico.data.DBHelper
import com.riccardocalligaro.registro_elettronico.entities.AgendaEvent
import io.flutter.Log
import java.text.SimpleDateFormat
import java.util.*
import kotlin.time.ExperimentalTime


class AgendaWidgetFactory(val context: Context, val intent: Intent) : RemoteViewsService.RemoteViewsFactory {
    private val list = mutableListOf<AgendaEvent>()
    private val dateFormat = SimpleDateFormat("EEEE d MMMM", Locale.getDefault())
    private val todayTime = Date().time


    override fun onCreate() {
    }

    @ExperimentalTime
    override fun getViewAt(i: Int): RemoteViews {
        val current = list[i]
        val rv = RemoteViews(context.packageName, R.layout.agenda_widget_event)

        // val diff = current.date.time - todayTime


        val subtitle = "${current.author} - ${dateFormat.format(current.date)}"


        //val songsFound = getQuantityString(R.plurals.numberOfSongsAvailable, count, count)
        rv.setTextViewText(R.id.title, current.notes)
        rv.setTextViewText(R.id.subtitle, subtitle)


        val shape = getDrawable(context, R.drawable.card_bg) as GradientDrawable
        shape.setColor(Color.RED)

        return rv


    }

    override fun getItemId(i: Int): Long {
        return i.toLong()
    }

    override fun onDataSetChanged() {
        Log.i("AgendaWidgetFactory", "Data set changed")


        list.clear()
        try {
            Log.i("AgendaWidgetFactory", "Trying to open database")

            val db = DBHelper.getInstance(context)

            val cursor: Cursor?

            cursor = db.rawQuery("select * from agenda_events", null)

            val today = Date()

            if (cursor!!.moveToFirst()) {
                while (!cursor.isAfterLast) {
                    Log.i("AgendaWidgetFactory", "Checking database data")

                    val authorName = (cursor.getString(cursor.getColumnIndex("author_name")))
                    val isFullDay: Boolean = cursor.getInt(cursor.getColumnIndex("is_full_day")) == 1
                    val timestamp = (cursor.getLong(cursor.getColumnIndex("begin")))
                    val notes = (cursor.getString(cursor.getColumnIndex("notes")))

                    val date = Date(timestamp * 1000)
                    //list.add(AgendaEvent(authorName, notes, isFullDay, date))
                    if (date.after(today)) list.add(AgendaEvent(authorName, notes, isFullDay, date))
                    cursor.moveToNext()
                }
            }

            // We close the database
            cursor.close()

            list.sortBy { it.date }
        } catch (e: RuntimeException) {
            Log.e("AgendaWidgetFactory", "Database runtime exception, pronbably it doesent exist", e)
            list.clear()
        }


    }


    override fun hasStableIds() = false
    override fun getCount() = list.size
    override fun getViewTypeCount() = 3
    override fun getLoadingView() = null
    override fun onDestroy() {
        list.clear()
    }

}