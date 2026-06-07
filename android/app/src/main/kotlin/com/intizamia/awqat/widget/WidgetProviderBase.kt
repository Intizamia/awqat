package com.intizamia.awqat.widget

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.RemoteViews

abstract class WidgetProviderBase : AppWidgetProvider() {

    abstract val skin: WidgetSkin

    abstract fun buildRemoteViews(ctx: Context, data: WidgetData, colors: WidgetColorScheme): RemoteViews

    override fun onUpdate(ctx: Context, mgr: AppWidgetManager, ids: IntArray) {
        val data = WidgetData.read(ctx)
        val colors = WidgetColors.resolve(skin, ctx)
        ids.forEach { id ->
            mgr.updateAppWidget(id, buildRemoteViews(ctx, data, colors))
        }
        scheduleMinuteAlarm(ctx)
    }

    override fun onDeleted(ctx: Context, ids: IntArray) {
        super.onDeleted(ctx, ids)
        // Cancel alarm only if no more instances of ANY widget remain
        val mgr = AppWidgetManager.getInstance(ctx)
        val anyRemaining = AwqatWidgetRefreshReceiver.allProviders.any { cls ->
            mgr.getAppWidgetIds(android.content.ComponentName(ctx, cls)).isNotEmpty()
        }
        if (!anyRemaining) cancelMinuteAlarm(ctx)
    }

    companion object {
        private const val ALARM_ACTION = "com.intizamia.awqat.WIDGET_MINUTE_TICK"
        private const val ALARM_REQUEST_CODE = 0xA771

        fun scheduleMinuteAlarm(ctx: Context) {
            val alarmMgr = ctx.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(ctx, WidgetMinuteReceiver::class.java).apply {
                action = ALARM_ACTION
            }
            val pi = PendingIntent.getBroadcast(
                ctx, ALARM_REQUEST_CODE, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            val nowMs = System.currentTimeMillis()
            val nextMinuteMs = ((nowMs / 60_000) + 1) * 60_000
            // API 31+ requires SCHEDULE_EXACT_ALARM or USE_EXACT_ALARM for exact alarms.
            // USE_EXACT_ALARM is only recognized on API 33+, so on API 31-32 we check first
            // and fall back to a 30s window alarm if exact scheduling isn't available.
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && !alarmMgr.canScheduleExactAlarms()) {
                alarmMgr.setWindow(AlarmManager.RTC_WAKEUP, nextMinuteMs, 30_000L, pi)
            } else {
                alarmMgr.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, nextMinuteMs, pi)
            }
        }

        fun cancelMinuteAlarm(ctx: Context) {
            val alarmMgr = ctx.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(ctx, WidgetMinuteReceiver::class.java).apply {
                action = ALARM_ACTION
            }
            val pi = PendingIntent.getBroadcast(
                ctx, ALARM_REQUEST_CODE, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            alarmMgr.cancel(pi)
        }
    }
}
