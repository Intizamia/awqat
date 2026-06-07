package com.intizamia.awqat.widget

import android.content.Context
import android.content.res.Configuration
import com.intizamia.awqat.R

enum class WidgetSkin { AUTO, GREEN }

data class WidgetColorScheme(
    val bg: Int,
    val heroBg: Int,
    val text: Int,
    val textMute: Int,
    val accent: Int,
    val divider: Int,
    val markActive: Int,
    val markInactive: Int,
    val markActiveRes: Int,
    val markInactiveRes: Int,
)

object WidgetColors {
    private const val WHITE      = 0xFFFFFFFF.toInt()
    private const val OFF_WHITE  = 0xFFE7EDE9.toInt()  // warm stone, faint green tint
    private const val BLACK      = 0xFF141C18.toInt()  // near black, green undertone
    private const val DARK_SURF  = 0xFF101614.toInt()  // very dark, slight forest cast
    private const val DARK_SURF2 = 0xFF172019.toInt()
    private const val MUTE_LIGHT = 0xFF4E5D57.toInt()  // green-warm muted
    private const val MUTE_DARK  = 0xFF879690.toInt()  // dark green-warm muted
    private const val RULE_LIGHT = 0xFFCDD8D2.toInt()  // warm green rule
    private const val RULE_DARK  = 0xFF1A2421.toInt()  // dark forest rule
    private const val GREEN_DEEP = 0xFF003C33.toInt()
    private const val GREEN_MID  = 0xFF004D42.toInt()
    private const val GREEN_PALE = 0xFFBFF0DD.toInt()
    private const val GREEN_RULE = 0xFF005548.toInt()
    private const val ACCENT_LT  = 0xFF003C33.toInt()
    private const val ACCENT_DK  = 0xFF74C7A8.toInt()

    val light = WidgetColorScheme(
        bg = OFF_WHITE, heroBg = GREEN_DEEP,
        text = BLACK, textMute = MUTE_LIGHT,
        accent = ACCENT_LT, divider = RULE_LIGHT,
        markActive = ACCENT_LT, markInactive = RULE_LIGHT,
        markActiveRes = R.drawable.widget_mark_accent_light,
        markInactiveRes = R.drawable.widget_mark_muted_light,
    )

    val dark = WidgetColorScheme(
        bg = DARK_SURF, heroBg = GREEN_DEEP,
        text = WHITE, textMute = MUTE_DARK,
        accent = ACCENT_DK, divider = RULE_DARK,
        markActive = ACCENT_DK, markInactive = RULE_DARK,
        markActiveRes = R.drawable.widget_mark_accent_dark,
        markInactiveRes = R.drawable.widget_mark_muted_dark,
    )

    val green = WidgetColorScheme(
        bg = GREEN_DEEP, heroBg = GREEN_MID,
        text = WHITE, textMute = GREEN_PALE,
        accent = GREEN_PALE, divider = GREEN_RULE,
        markActive = GREEN_PALE, markInactive = GREEN_RULE,
        markActiveRes = R.drawable.widget_mark_accent_dark,
        markInactiveRes = R.drawable.widget_mark_muted_dark,
    )

    fun resolve(skin: WidgetSkin, ctx: Context): WidgetColorScheme = when (skin) {
        WidgetSkin.GREEN -> green
        WidgetSkin.AUTO -> {
            val nightMode = ctx.resources.configuration.uiMode and
                    Configuration.UI_MODE_NIGHT_MASK
            if (nightMode == Configuration.UI_MODE_NIGHT_YES) dark else light
        }
    }
}
