import 'package:intl/intl.dart';

String calcTime(DateTime timestamp) {
  var format = DateFormat('HH:mm a');
  var sformat = DateFormat('EEEE, MMMM d, ' 'yyyy');
  var time = sformat.format(timestamp);

  return time;
}
