import 'package:logger/logger.dart';

final _logger = Logger();

logDebug(dynamic content) {
  _logger.d(content, null, StackTrace.empty);
}

logInfo(dynamic content) {
  _logger.i(content);
}

logWarning(dynamic content) {
  _logger.w(content);
}

logError(dynamic content) {
  _logger.e(content);
}

logVerbose(dynamic content) {
  _logger.v(content);
}

logWTF(dynamic content) {
  _logger.wtf(content);
}
