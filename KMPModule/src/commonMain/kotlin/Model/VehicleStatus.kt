package com.chatsopond.kmp.model

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json

@Serializable
data class VehicleStatus(
    val vehicleId: String,
    val battery: Int,
    val speed: Int
) {
    fun toJson(): String = Json.encodeToString(serializer(), this)

    companion object {
        fun fromJson(json: String): VehicleStatus = Json.decodeFromString(serializer(), json)
    }
}