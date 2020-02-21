package com.riccardocalligaro.registro_elettronico.widgets.grades

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.view.View
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import com.riccardocalligaro.registro_elettronico.R
import com.riccardocalligaro.registro_elettronico.data.DBHelper
import com.riccardocalligaro.registro_elettronico.entities.Grade
import io.flutter.Log
import java.text.SimpleDateFormat
import java.util.*
import kotlin.time.ExperimentalTime


class GradesWidgetFactory(val context: Context, val intent: Intent) : RemoteViewsService.RemoteViewsFactory {
    private val grades = mutableListOf<Grade>()
    private val dateFormat = SimpleDateFormat("EEEE d MMMM", Locale.getDefault())
    private val todayTime = Date().time


    override fun onCreate() {
    }

    @ExperimentalTime
    override fun getViewAt(i: Int): RemoteViews {
        val current = grades[i]
        val rv = RemoteViews(context.packageName, R.layout.grades_widget_grade)

        rv.setTextViewText(R.id.grade_subject, capitalizeFirst(current.subject))
        rv.setTextViewText(R.id.grade_date, dateFormat.format(current.date))

        rv.setTextViewText(R.id.grade_value, current.displayValue)


        if (current.decimalValue == -1.00) {
            rv.setViewVisibility(R.id.blue_circle, View.VISIBLE)

            rv.setViewVisibility(R.id.red_circle, View.GONE)
            rv.setViewVisibility(R.id.yellow_circle, View.GONE)
            rv.setViewVisibility(R.id.green_circle, View.GONE)

        } else if (current.decimalValue >= 6) {
            rv.setViewVisibility(R.id.green_circle, View.VISIBLE)

            rv.setViewVisibility(R.id.red_circle, View.GONE)
            rv.setViewVisibility(R.id.yellow_circle, View.GONE)
            rv.setViewVisibility(R.id.blue_circle, View.GONE)
        } else if (current.decimalValue >= 5.5 && current.decimalValue < 6) {
            rv.setViewVisibility(R.id.yellow_circle, View.VISIBLE)

            rv.setViewVisibility(R.id.red_circle, View.GONE)
            rv.setViewVisibility(R.id.blue_circle, View.GONE)
            rv.setViewVisibility(R.id.green_circle, View.GONE)
        } else if (current.decimalValue < 5.5) {
            rv.setViewVisibility(R.id.red_circle, View.VISIBLE)

            rv.setViewVisibility(R.id.blue_circle, View.GONE)
            rv.setViewVisibility(R.id.yellow_circle, View.GONE)
            rv.setViewVisibility(R.id.green_circle, View.GONE)

        }

        //rv.setInt(R.id.grade_value, "setBackgroundTint", R.color.red_500)

//        // val diff = current.date.time - todayTime
//
//
//        val subtitle = "${current.author} - ${dateFormat.format(current.date)}"
//
//
//        //val songsFound = getQuantityString(R.plurals.numberOfSongsAvailable, count, count)
//        rv.setTextViewText(R.id.title, current.notes)
//        rv.setTextViewText(R.id.subtitle, subtitle)
//
//
//        val shape = getDrawable(context, R.drawable.card_bg) as GradientDrawable
//        shape.setColor(Color.RED)

        return rv


    }

    override fun getItemId(i: Int): Long {
        return i.toLong()
    }

    override fun onDataSetChanged() {
        Log.i("GradesWidgetFactory", "Data set changed")


        grades.clear()
        try {
            Log.i("GradesWidgetFactory", "Trying to open database")

            val db = DBHelper.getInstance(context)

            val cursor: Cursor?

            cursor = db.rawQuery("select * from grades", null)


            if (cursor!!.moveToFirst()) {
                while (!cursor.isAfterLast) {
                    Log.i("GradesWidgetFactory", "Checking database data")
                    val decimalValue = (cursor.getDouble(cursor.getColumnIndex("decimal_value")))
                    val displayValue = (cursor.getString(cursor.getColumnIndex("display_value")))
                    val notes = (cursor.getString(cursor.getColumnIndex("notes_for_family")))
                    val timestamp = (cursor.getLong(cursor.getColumnIndex("event_date")))
                    val date = Date(timestamp * 1000)

                    val subject = (cursor.getString(cursor.getColumnIndex("subject_desc")))

                    grades.add(Grade(decimalValue, displayValue, notes, date, subject))

//
//                    val authorName = (cursor.getString(cursor.getColumnIndex("author_name")))
//                    val isFullDay: Boolean = cursor.getInt(cursor.getColumnIndex("is_full_day")) == 1
//                    val timestamp = (cursor.getLong(cursor.getColumnIndex("begin")))
//                    val notes = (cursor.getString(cursor.getColumnIndex("notes")))
//
//                    val date = Date(timestamp * 1000)
//                    //list.add(AgendaEvent(authorName, notes, isFullDay, date))
//                    if (date.after(today)) list.add(AgendaEvent(authorName, notes, isFullDay, date))
                    cursor.moveToNext()
                }
            }

            grades.sortByDescending { it.date }

            // We close the database
            cursor.close()


        } catch (e: RuntimeException) {
            Log.e("GradesWidgetFactory", "Database runtime exception, pronbably it doesent exist", e)
            grades.clear()
        }


    }

    @SuppressLint("DefaultLocale")
    fun capitalizeFirst(a: String) = if (a.isNotEmpty()) a.substring(0, 1).toUpperCase() + a.substring(1).toLowerCase() else a

    override fun hasStableIds() = false
    override fun getCount() = grades.size
    override fun getViewTypeCount() = 3
    override fun getLoadingView() = null
    override fun onDestroy() {
        grades.clear()
    }

}