
class TK303 {
  static String singleTrack(String duration, String intervals, String password) => "fix${duration}s0${intervals}n$password";

  static String unlimitedTrack(String password) => "fix300s018m***n$password";

  static String stopTracking(String password) => "nofix$password";

  static String monitor(String password) => "monitor$password";

  static String track(String password) => "tracker$password";

  static String lowBatteryOn(String password) => "lowbattery$password on";

  static String lowBatteryOff(String password) => "lowbattery$password off";

  static String externalPowerOn(String password) => "extpower$password on";

  static String externalPowerOff(String password) => "extpower$password off";

  static String stockade(String password, double firstLat, double firstLng, double secondLat, double secondLng ) => "stockade$password $firstLat,$firstLng;$secondLat,$secondLng";

  static String stockadeOff(String password ) => "nostockade$password";

  static String movement(String password, int distance ) => "move$password 0$distance";

  static String movementOff(String password) => "nomove$password";

  static String overSpeed(String password) => "speed$password 080";

  static String overSpeedOff(String password) => "nospeed$password";

  static String acc(String password) => "ACC$password";

  static String accOff(String password) => "noACC$password";

  static String quickStop(String password) => "quickstop$password";
  static String quickStopOff(String password) => "noquickstop$password";

  static String StopEngine(String password) => "resume$password";
  static String StartEngine(String password) => "stop$password";

  static String arm(String password) => "arm$password";
  static String disarm(String password) => "disarm$password";

  static String state(String password) => "check$password";
}