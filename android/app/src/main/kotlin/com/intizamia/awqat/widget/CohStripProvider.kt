package com.intizamia.awqat.widget

import android.content.Context
import android.widget.RemoteViews
import com.intizamia.awqat.R

private val STRIP_PRAYERS = listOf("fajr", "dhuhr", "asr", "maghrib", "isha")
private val STRIP_ABBRS   = listOf("FJR",  "DHR",  "ASR", "MGH",    "ISH")

private val cellAbbrIds = listOf(R.id.cell0_abbr, R.id.cell1_abbr, R.id.cell2_abbr, R.id.cell3_abbr, R.id.cell4_abbr)
private val cellTimeIds = listOf(R.id.cell0_time, R.id.cell1_time, R.id.cell2_time, R.id.cell3_time, R.id.cell4_time)

internal fun buildStripViews(ctx: Context, data: WidgetData, colors: WidgetColorScheme): RemoteViews {
    val rv = RemoteViews(ctx.packageName, R.layout.widget_coh_strip)

    rv.setInt(R.id.root, "setBackgroundColor", colors.bg)
    rv.setInt(R.id.vline, "setBackgroundColor", colors.divider)

    rv.setTextColor(R.id.next_label, colors.textMute)
    rv.setTextColor(R.id.next_name, colors.text)
    rv.setTextColor(R.id.next_countdown, colors.accent)

    rv.setTextViewText(R.id.next_name, data.nextName)
    rv.setTextViewText(R.id.next_countdown, data.countdownStr())

    val cells = data.prayerRowsNoSunrise
        .filter { it.key in STRIP_PRAYERS }
        .sortedBy { STRIP_PRAYERS.indexOf(it.key) }

    STRIP_PRAYERS.forEachIndexed { i, key ->
        val cell = cells.firstOrNull { it.key == key }
        rv.setTextViewText(cellAbbrIds[i], STRIP_ABBRS[i])
        rv.setTextViewText(cellTimeIds[i], cell?.timeStr ?: "—")

        val isNext = key == data.nextKey
        val textColor = if (isNext) colors.accent else colors.text
        val muteColor = if (isNext) colors.accent else colors.textMute
        rv.setTextColor(cellAbbrIds[i], muteColor)
        rv.setTextColor(cellTimeIds[i], textColor)
    }

    return rv
}

class CohStripProvider : WidgetProviderBase() {
    override val skin = WidgetSkin.AUTO
    override fun buildRemoteViews(ctx: Context, data: WidgetData, colors: WidgetColorScheme) =
        buildStripViews(ctx, data, colors)
}