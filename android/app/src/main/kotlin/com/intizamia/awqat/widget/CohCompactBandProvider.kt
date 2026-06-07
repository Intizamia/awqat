package com.intizamia.awqat.widget

import android.content.Context
import android.widget.RemoteViews
import com.intizamia.awqat.R

private val CB_PRAYERS = listOf("fajr", "dhuhr", "asr", "maghrib", "isha")

private val cbMarkIds = listOf(R.id.mark0, R.id.mark1, R.id.mark2, R.id.mark3, R.id.mark4)
private val cbNameIds = listOf(R.id.name0, R.id.name1, R.id.name2, R.id.name3, R.id.name4)
private val cbTimeIds = listOf(R.id.time0, R.id.time1, R.id.time2, R.id.time3, R.id.time4)
private val cbDivIds  = listOf(R.id.div01, R.id.div12, R.id.div23, R.id.div34)

internal fun buildCompactBandViews(ctx: Context, data: WidgetData, colors: WidgetColorScheme): RemoteViews {
    val rv = RemoteViews(ctx.packageName, R.layout.widget_coh_compact_band)

    // Hero always deep green
    rv.setInt(R.id.hero, "setBackgroundColor", WidgetColors.green.heroBg)
    rv.setInt(R.id.body, "setBackgroundColor", colors.bg)
    rv.setInt(R.id.root, "setBackgroundColor", colors.bg)
    rv.setInt(R.id.band_divider, "setBackgroundColor", colors.divider)

    val hColors = WidgetColors.green
    rv.setTextColor(R.id.hero_location, hColors.textMute)
    rv.setTextColor(R.id.hero_date_greg, hColors.textMute)
    rv.setTextColor(R.id.hero_date_hijri, hColors.textMute)
    rv.setTextColor(R.id.hero_label, hColors.textMute)
    rv.setTextColor(R.id.hero_next_name, hColors.text)
    rv.setTextColor(R.id.hero_countdown, hColors.accent)

    rv.setTextViewText(R.id.hero_location, data.location)
    rv.setTextViewText(R.id.hero_date_greg, data.dateGreg)
    rv.setTextViewText(R.id.hero_date_hijri, data.dateHijri)
    rv.setTextViewText(R.id.hero_next_name, data.nextName)
    rv.setTextViewText(R.id.hero_countdown, "in ${data.countdownStr()} · ${data.nextTimeStr}")

    cbDivIds.forEach { rv.setInt(it, "setBackgroundColor", colors.divider) }

    val rows = data.prayerRowsNoSunrise
        .filter { it.key in CB_PRAYERS }
        .sortedBy { CB_PRAYERS.indexOf(it.key) }

    rows.forEachIndexed { i, row ->
        val isNext = row.key == data.nextKey
        rv.setInt(cbMarkIds[i], "setBackgroundResource",
            if (isNext) colors.markActiveRes else colors.markInactiveRes)
        rv.setTextViewText(cbNameIds[i], row.name)
        rv.setTextViewText(cbTimeIds[i], row.timeStr)
        rv.setTextColor(cbNameIds[i], if (isNext) colors.accent else colors.text)
        rv.setTextColor(cbTimeIds[i], if (isNext) colors.accent else colors.textMute)
    }

    return rv
}

class CohCompactBandProvider : WidgetProviderBase() {
    override val skin = WidgetSkin.AUTO
    override fun buildRemoteViews(ctx: Context, data: WidgetData, colors: WidgetColorScheme) =
        buildCompactBandViews(ctx, data, colors)
}