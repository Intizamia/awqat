package com.intizamia.awqat.widget

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.RemoteViews
import com.intizamia.awqat.R

abstract class WidgetProviderBase : AppWidgetProvider() {

    abstract val skin: WidgetSkin

    abstract fun buildRemoteViews(ctx: Context, data: WidgetData, colors: WidgetColorScheme): RemoteViews

    override fun onUpdate(ctx: Context, mgr: AppWidgetManager, ids: IntArray) {
        val data = WidgetData.read(ctx)
        val colors = WidgetColors.resolve(skin, ctx)
        val launchPi = launchAppPendingIntent(ctx)
        ids.forEach { id ->
            val rv = if (data.hasData) buildRemoteViews(ctx, data, colors)
                     else buildEmptyStateViews(ctx, colors)
            rv.setOnClickPendingIntent(R.id.root, launchPi)
            mgr.updateAppWidget(id, rv)
        }
        scheduleMinuteAlarm(ctx)
    }

    override fun onDeleted(ctx: Context, ids: IntArray) {
        super.onDeleted(ctx, ids)
        val mgr = AppWidgetManager.getInstance(ctx)
        val anyRemaining = AwqatWidgetRefreshReceiver.allProviders.any { cls ->
            mgr.getAppWidgetIds(android.content.ComponentName(ctx, cls)).isNotEmpty()
        }
        if (!anyRemaining) cancelMinuteAlarm(ctx)
    }

    companion object {
        private const val ALARM_ACTION = "com.intizamia.awqat.WIDGET_MINUTE_TICK"
        private const val ALARM_REQUEST_CODE = 0xA771

        fun launchAppPendingIntent(ctx: Context): PendingIntent {
            val intent = ctx.packageManager.getLaunchIntentForPackage(ctx.packageName)
                ?: Intent().apply {
                    setClassName(ctx.packageName, "${ctx.packageName}.MainActivity")
                }
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            return PendingIntent.getActivity(
                ctx, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        }

        fun buildEmptyStateViews(ctx: Context, colors: WidgetColorScheme): RemoteViews {
            val rv = RemoteViews(ctx.packageName, R.layout.widget_empty_state)
            rv.setInt(R.id.root, "setBackgroundColor", colors.bg)
            rv.setTextColor(R.id.empty_label, colors.textMute)
            rv.setTextColor(R.id.empty_cta, colors.accent)
            return rv
        }

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
