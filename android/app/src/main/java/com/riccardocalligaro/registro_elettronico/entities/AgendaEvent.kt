package com.riccardocalligaro.registro_elettronico.entities

import java.util.*

data class AgendaEvent(var author: String, var notes: String, var isFullDay: Boolean, var date: Date)