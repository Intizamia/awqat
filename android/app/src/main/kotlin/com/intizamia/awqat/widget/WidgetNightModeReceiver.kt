package com.intizamia.awqat.widget

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class WidgetNightModeReceiver : BroadcastReceiver() {
    override fun onReceive(ctx: Context, intent: Intent) {
        AwqatWidgetRefreshReceiver.updateAllWidgets(ctx)
    }
}
