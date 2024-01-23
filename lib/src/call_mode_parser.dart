import 'package:call_mode/src/call_mode.dart';

class CallModeParser {
  CallMode fromString(String string) => CallMode.values.byName(string);
}
