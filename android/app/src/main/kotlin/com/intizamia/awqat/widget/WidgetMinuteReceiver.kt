package com.intizamia.awqat.widget

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent

class WidgetMinuteReceiver : BroadcastReceiver() {
    override fun onReceive(ctx: Context, intent: Intent) {
        AwqatWidgetRefreshReceiver.updateAllWidgets(ctx)
        WidgetProviderBase.scheduleMinuteAlarm(ctx)
    }
}
