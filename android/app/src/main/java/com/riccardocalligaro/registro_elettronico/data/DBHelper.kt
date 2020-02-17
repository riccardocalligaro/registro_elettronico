package com.riccardocalligaro.registro_elettronico.data

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import io.flutter.Log
import java.io.File

class DBHelper(private val context: Context) {

    var database: SQLiteDatabase


    init {
        database = open()
    }

    private fun open(): SQLiteDatabase {
        val folder = context.applicationInfo.dataDir
        val file = "$folder/databases/db.sqlite"

        val folderFile = File(folder)

        folderFile.walk().forEach {
            Log.i("File", it.path)
        }


        val dbFile = File(file)


        Log.i("Database exists", dbFile.exists().toString())
        Log.i("Database exists", dbFile.path)

        if (!dbFile.exists()) {
            throw RuntimeException("Error opening db")
        }
        return SQLiteDatabase.openDatabase(dbFile.path, null, SQLiteDatabase.OPEN_READONLY)
    }


    fun close() {
        database.close()
    }
}
