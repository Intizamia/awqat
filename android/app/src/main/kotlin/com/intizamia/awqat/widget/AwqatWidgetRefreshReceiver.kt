package com.intizamia.awqat.widget

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent

class AwqatWidgetRefreshReceiver : BroadcastReceiver() {
    override fun onReceive(ctx: Context, intent: Intent) {
        updateAllWidgets(ctx)
        WidgetProviderBase.scheduleMinuteAlarm(ctx)
    }

    companion object {
        val allProviders: List<Class<out WidgetProviderBase>> = listOf(
            CohStripProvider::class.java,
            CohNextProvider::class.java,
            CohListProvider::class.java,
            CohSplitProvider::class.java,
            CohCompactBandProvider::class.java,
        )

        fun updateAllWidgets(ctx: Context) {
            val mgr = AppWidgetManager.getInstance(ctx)
            allProviders.forEach { cls ->
                val ids = mgr.getAppWidgetIds(ComponentName(ctx, cls))
                if (ids.isNotEmpty()) {
                    val intent = Intent(ctx, cls).apply {
                        action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                        putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
                    }
                    ctx.sendBroadcast(intent)
                }
            }
        }
    }
}
