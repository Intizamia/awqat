package com.intizamia.awqat.widget

import android.content.Context
import android.widget.RemoteViews
import com.intizamia.awqat.R

internal fun buildNextViews(ctx: Context, data: WidgetData, colors: WidgetColorScheme): RemoteViews {
    val rv = RemoteViews(ctx.packageName, R.layout.widget_coh_next)

    rv.setInt(R.id.root, "setBackgroundColor", colors.bg)
    rv.setInt(R.id.then_divider, "setBackgroundColor", colors.divider)

    rv.setTextColor(R.id.label, colors.textMute)
    rv.setTextColor(R.id.next_name, colors.text)
    rv.setTextColor(R.id.next_countdown, colors.accent)
    rv.setTextColor(R.id.next_time, colors.textMute)
    rv.setTextColor(R.id.then_label, colors.textMute)
    rv.setTextColor(R.id.following_name, colors.text)
    rv.setTextColor(R.id.following_time, colors.textMute)

    rv.setTextViewText(R.id.next_name, data.nextName)
    rv.setTextViewText(R.id.next_countdown, "in ${data.countdownStr()}")
    rv.setTextViewText(R.id.next_time, data.nextTimeStr)
    rv.setTextViewText(R.id.following_name, data.followingName)
    rv.setTextViewText(R.id.following_time, data.followingTimeStr)

    return rv
}

class CohNextProvider : WidgetProviderBase() {
    override val skin = WidgetSkin.AUTO
    override fun buildRemoteViews(ctx: Context, data: WidgetData, colors: WidgetColorScheme) =
        buildNextViews(ctx, data, colors)
}