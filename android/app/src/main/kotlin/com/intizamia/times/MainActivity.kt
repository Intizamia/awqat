package com.intizamia.awqat

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "awqat/sensor")
            .setMethodCallHandler { call, result ->
                if (call.method == "hasMagnetometer") {
                    val sm = getSystemService(Context.SENSOR_SERVICE) as SensorManager
                    result.success(sm.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD) != null)
                } else {
                    result.notImplemented()
                }
            }
    }
}
