package com.riccardocalligaro.registro_elettronico.widgets.timetable

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.graphics.Color
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import com.riccardocalligaro.registro_elettronico.R
import com.riccardocalligaro.registro_elettronico.data.DBHelper
import com.riccardocalligaro.registro_elettronico.entities.TimetableEntry
import io.flutter.Log
import java.text.SimpleDateFormat
import java.util.*
import kotlin.time.ExperimentalTime


class TimetableWidgetFactory(val context: Context, val intent: Intent) : RemoteViewsService.RemoteViewsFactory {
    private val timetableEntries = mutableListOf<TimetableEntry>()
    private val todayCalendar = Calendar.getInstance()


    override fun onCreate() {
    }

    @ExperimentalTime
    override fun getViewAt(i: Int): RemoteViews {
        val entry = timetableEntries[i]
        val rv = RemoteViews(context.packageName, R.layout.timetable_widget_entry)

        val hours = "${entry.start}°"
        rv.setTextViewText(R.id.hour, hours)
        rv.setTextViewText(R.id.subject_name, capitalizeFirst(entry.subject))

        return rv
    }

    override fun getItemId(i: Int): Long {
        return i.toLong()
    }

    override fun onDataSetChanged() {
        Log.i("TimetableWidgetFactory", "Data set changed")


        timetableEntries.clear()
        try {
            Log.i("TimetableWidgetFactory", "Trying to open database")

            val db = DBHelper.getInstance(context)

            val cursor: Cursor?

            cursor = db.rawQuery("select * from timetable_entries", null)


            if (cursor!!.moveToFirst()) {
                while (!cursor.isAfterLast) {
                    Log.i("TimetableWidgetFactory", "Checking database data")

                    val dayOfWeek = (cursor.getInt(cursor.getColumnIndex("day_of_week")))

                    if (dayOfWeek == todayCalendar.get(Calendar.DAY_OF_WEEK)) {
                        val start = (cursor.getInt(cursor.getColumnIndex("start")))
                        val end = (cursor.getInt(cursor.getColumnIndex("start")))

                        val subject = (cursor.getString(cursor.getColumnIndex("subject_name")))

                        timetableEntries.add(TimetableEntry(start, end, dayOfWeek, subject))
                    }
                    cursor.moveToNext()
                }
            }

            cursor.close()


        } catch (e: RuntimeException) {
            Log.e("TimetableWidgetFactory", "Database runtime exception, pronbably it doesent exist", e)
            timetableEntries.clear()
        }


    }

    @SuppressLint("DefaultLocale")
    fun capitalizeFirst(a: String) = if (a.isNotEmpty()) a.substring(0, 1).toUpperCase() + a.substring(1).toLowerCase() else a

    override fun hasStableIds() = false
    override fun getCount() = timetableEntries.size
    override fun getViewTypeCount() = 3
    override fun getLoadingView() = null
    override fun onDestroy() {
        timetableEntries.clear()
    }

}