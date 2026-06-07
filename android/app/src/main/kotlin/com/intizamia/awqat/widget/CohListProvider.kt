package com.intizamia.awqat.widget

import android.content.Context
import android.widget.RemoteViews
import com.intizamia.awqat.R

private val LIST_PRAYERS = listOf("fajr", "dhuhr", "asr", "maghrib", "isha")

private val rowIds   = listOf(R.id.row0, R.id.row1, R.id.row2, R.id.row3, R.id.row4)
private val markIds  = listOf(R.id.mark0, R.id.mark1, R.id.mark2, R.id.mark3, R.id.mark4)
private val nameIds  = listOf(R.id.name0, R.id.name1, R.id.name2, R.id.name3, R.id.name4)
private val timeIds  = listOf(R.id.time0, R.id.time1, R.id.time2, R.id.time3, R.id.time4)
private val divIds   = listOf(R.id.div01, R.id.div12, R.id.div23, R.id.div34)

internal fun applyListRows(
    rv: RemoteViews,
    data: WidgetData,
    colors: WidgetColorScheme,
    layoutId: Int,
    ctx: Context,
) {
    rv.setInt(layoutId, "setBackgroundColor", colors.bg)
    divIds.forEach { rv.setInt(it, "setBackgroundColor", colors.divider) }

    val rows = data.prayerRowsNoSunrise
        .filter { it.key in LIST_PRAYERS }
        .sortedBy { LIST_PRAYERS.indexOf(it.key) }

    rows.forEachIndexed { i, row ->
        val isNext = row.key == data.nextKey
        val textColor = if (isNext) colors.accent else colors.text
        rv.setInt(markIds[i], "setBackgroundResource",
            if (isNext) colors.markActiveRes else colors.markInactiveRes)
        rv.setTextViewText(nameIds[i], row.name)
        rv.setTextViewText(timeIds[i], row.timeStr)
        rv.setTextColor(nameIds[i], textColor)
        rv.setTextColor(timeIds[i], if (isNext) colors.accent else colors.textMute)
    }
}

internal fun buildListViews(ctx: Context, data: WidgetData, colors: WidgetColorScheme): RemoteViews {
    val rv = RemoteViews(ctx.packageName, R.layout.widget_coh_list)
    applyListRows(rv, data, colors, R.id.root, ctx)
    return rv
}

class CohListProvider : WidgetProviderBase() {
    override val skin = WidgetSkin.AUTO
    override fun buildRemoteViews(ctx: Context, data: WidgetData, colors: WidgetColorScheme) =
        buildListViews(ctx, data, colors)
}