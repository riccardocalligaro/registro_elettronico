package com.riccardocalligaro.registro_elettronico.data

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import io.flutter.Log
import java.io.File

class DBHelper private constructor(private val context: Context) {

    lateinit var database: SQLiteDatabase


    companion object {

        @Volatile
        private var INSTANCE: SQLiteDatabase? = null

        fun getInstance(context: Context): SQLiteDatabase =
                INSTANCE ?: synchronized(this) {
                    INSTANCE ?: open(context).also { INSTANCE = it }
                }

        private fun open(context: Context): SQLiteDatabase {
            Log.i("DBHelper", "Opening database")
            // We go to the moor db path
            val folder = context.applicationInfo.dataDir
            val file = "$folder/databases/db.sqlite"

            val dbFile = File(file)


            Log.i("Database exists", dbFile.exists().toString())
            Log.i("Database exists", dbFile.path)

            if (!dbFile.exists()) {
                Log.e("DBHelper", "Database doesent'exist, throwing runtime exception")
                throw RuntimeException("Error opening db")
            }

            Log.i("DBHelper", "DB Exists, returning the SQLITEDatabase")


            return SQLiteDatabase.openDatabase(dbFile.path, null, SQLiteDatabase.OPEN_READONLY)
        }
    }
}