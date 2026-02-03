import 'package:flutter/foundation.dart';

class ResponsiveHelper {
  // Detecta si estamos en desktop
  static bool isDesktop() {
    return defaultTargetPlatform == TargetPlatform.windows ||
           defaultTargetPlatform == TargetPlatform.macOS ||
           defaultTargetPlatform == TargetPlatform.linux;
  }
  
  static String getImageResolution() {
    if (isDesktop()) {
      return 'w780';
    }
    return 'w500';
  }
  
  static String getBackdropResolution() {
    if (isDesktop()) {
      return 'w1280';
    }
    return 'w780';
  }
  
  static bool shouldShowScrollbars() {
    return isDesktop();
  }
}