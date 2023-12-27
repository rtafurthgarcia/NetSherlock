class ShodanAccount {
  late int _scanCreditsLeft;
  late int _queryCreditsLeft;
  late int _amountOfMonitoredIps;
  late String _plan;
  late bool _isMember;

  int get scanCreditsLeft => _scanCreditsLeft;
  int get queryCreditsLeft => _queryCreditsLeft;
  int get amountOfMonitoredIps => _amountOfMonitoredIps;
  String get plan => _plan;
  bool get isMember => _isMember;

  ShodanAccount();

  ShodanAccount._({required int scanCreditsLeft, required int queryCreditsLeft, required int amountOfMonitoredIps, required String currentPlan, required bool isMember}):
    _scanCreditsLeft = scanCreditsLeft, _queryCreditsLeft =queryCreditsLeft, _amountOfMonitoredIps = amountOfMonitoredIps, _plan = currentPlan, _isMember = isMember;

  factory ShodanAccount.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'scan_credits': int scanCreditsLeft,
        'query_credits': int queryCreditsLeft,
        'monitored_ips': int amountOfMonitoredIps,
        'plan': String plan,
        'unlocked': bool isMember
      } =>
        ShodanAccount._(
          scanCreditsLeft: scanCreditsLeft,
          queryCreditsLeft: queryCreditsLeft,
          amountOfMonitoredIps: amountOfMonitoredIps,
          currentPlan: plan,
          isMember: isMember
        ),

      _ => throw Exception('Failed to load account details.'),
    };
  }
}
