import 'dart:developer';

import 'package:flutter/foundation.dart';

// const apiUrl = 'https://piki-backend.onrender.com/';
// const apiUrl = 'https://piki-backend-prod.onrender.com/';
// https://piki-backend.onrender.com/users/allUsers
String apiUrl = '';

setEnvironmentConfig() {
  if (kReleaseMode) {
    log('Release Mode');
    apiUrl = 'https://piki-backend-prod.onrender.com/';
  } else {
    log('Debug Mode');
    apiUrl = 'https://piki-backend.onrender.com/';
  }
}
