package com.intizamia.awqat.widget

import android.content.Context
import android.widget.RemoteViews
import com.intizamia.awqat.R

private val SPLIT_PRAYERS = listOf("fajr", "dhuhr", "asr", "maghrib", "isha")

private val sRowIds  = listOf(R.id.row0, R.id.row1, R.id.row2, R.id.row3, R.id.row4)
private val sMarkIds = listOf(R.id.mark0, R.id.mark1, R.id.mark2, R.id.mark3, R.id.mark4)
private val sNameIds = listOf(R.id.name0, R.id.name1, R.id.name2, R.id.name3, R.id.name4)
private val sTimeIds = listOf(R.id.time0, R.id.time1, R.id.time2, R.id.time3, R.id.time4)
private val sDivIds  = listOf(R.id.div01, R.id.div12, R.id.div23, R.id.div34)

internal fun buildSplitViews(ctx: Context, data: WidgetData, colors: WidgetColorScheme): RemoteViews {
    val rv = RemoteViews(ctx.packageName, R.layout.widget_coh_split)

    rv.setInt(R.id.root, "setBackgroundColor", colors.bg)
    rv.setInt(R.id.left, "setBackgroundColor", colors.bg)
    rv.setInt(R.id.vline, "setBackgroundColor", colors.divider)
    sDivIds.forEach { rv.setInt(it, "setBackgroundColor", colors.divider) }

    rv.setTextColor(R.id.left_label, colors.textMute)
    rv.setTextColor(R.id.left_name, colors.text)
    rv.setTextColor(R.id.left_time, colors.textMute)
    rv.setTextColor(R.id.left_countdown, colors.accent)

    rv.setTextViewText(R.id.left_name, data.nextName)
    rv.setTextViewText(R.id.left_time, data.nextTimeStr)
    rv.setTextViewText(R.id.left_countdown, "in ${data.countdownStr()}")

    val rows = data.prayerRowsNoSunrise
        .filter { it.key in SPLIT_PRAYERS }
        .sortedBy { SPLIT_PRAYERS.indexOf(it.key) }

    rows.forEachIndexed { i, row ->
        val isNext = row.key == data.nextKey
        rv.setInt(sMarkIds[i], "setBackgroundResource",
            if (isNext) colors.markActiveRes else colors.markInactiveRes)
        rv.setTextViewText(sNameIds[i], row.name)
        rv.setTextViewText(sTimeIds[i], row.timeStr)
        rv.setTextColor(sNameIds[i], if (isNext) colors.accent else colors.text)
        rv.setTextColor(sTimeIds[i], if (isNext) colors.accent else colors.textMute)
    }

    return rv
}

class CohSplitProvider : WidgetProviderBase() {
    override val skin = WidgetSkin.AUTO
    override fun buildRemoteViews(ctx: Context, data: WidgetData, colors: WidgetColorScheme) =
        buildSplitViews(ctx, data, colors)
}