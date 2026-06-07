package com.intizamia.awqat.widget

import android.content.Context
import org.json.JSONArray

data class PrayerRow(
    val key: String,
    val name: String,
    val timeStr: String,
    val timeMs: Long,
)

data class WidgetData(
    val nextName: String = "—",
    val nextTimeMs: Long = 0L,
    val nextTimeStr: String = "—",
    val nextKey: String = "",
    val followingName: String = "—",
    val followingTimeStr: String = "—",
    val location: String = "—",
    val dateGreg: String = "—",
    val dateHijri: String = "—",
    val prayers: List<PrayerRow> = emptyList(),
) {
    fun countdownStr(): String {
        val diffMs = nextTimeMs - System.currentTimeMillis()
        if (diffMs <= 0) return "now"
        val totalMins = (diffMs / 60_000).toInt()
        val h = totalMins / 60
        val m = totalMins % 60
        return if (h > 0) "${h}h ${m}m" else "${m}m"
    }

    /** Prayer rows excluding Sunrise. */
    val prayerRowsNoSunrise: List<PrayerRow>
        get() = prayers.filter { it.key != "sunrise" }

    companion object {
        private const val PREFS_NAME = "HomeWidgetPreferences"

        fun read(ctx: Context): WidgetData {
            val prefs = ctx.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

            val prayersJson = prefs.getString("widget_prayers_json", null)
            val prayers = parsePrayers(prayersJson)

            return WidgetData(
                nextName = prefs.getString("widget_next_name", "—") ?: "—",
                nextTimeMs = prefs.getLong("widget_next_time_ms", 0L),
                nextTimeStr = prefs.getString("widget_next_time_str", "—") ?: "—",
                nextKey = prefs.getString("widget_next_key", "") ?: "",
                followingName = prefs.getString("widget_following_name", "—") ?: "—",
                followingTimeStr = prefs.getString("widget_following_time_str", "—") ?: "—",
                location = prefs.getString("widget_location", "—") ?: "—",
                dateGreg = prefs.getString("widget_date_greg", "—") ?: "—",
                dateHijri = prefs.getString("widget_date_hijri", "—") ?: "—",
                prayers = prayers,
            )
        }

        private fun parsePrayers(json: String?): List<PrayerRow> {
            if (json.isNullOrEmpty()) return emptyList()
            return try {
                val arr = JSONArray(json)
                (0 until arr.length()).map { i ->
                    val obj = arr.getJSONObject(i)
                    PrayerRow(
                        key = obj.optString("key"),
                        name = obj.optString("name"),
                        timeStr = obj.optString("time"),
                        timeMs = obj.optLong("time_ms"),
                    )
                }
            } catch (_: Exception) {
                emptyList()
            }
        }
    }
}
