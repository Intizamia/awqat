import 'dart:io';
import 'package:flutter/services.dart';

Future<bool> hasMagnetometer() async {
  if (!Platform.isAndroid) return true;
  const ch = MethodChannel('awqat/sensor');
  return await ch.invokeMethod<bool>('hasMagnetometer') ?? false;
}
