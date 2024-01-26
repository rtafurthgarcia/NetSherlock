import 'package:netsherlock/models/shodan_account_usage_limits_model.dart';

class ShodanAccount {
  late int _scanCreditsLeft;
  late int _queryCreditsLeft;
  late int _amountOfMonitoredIps;
  late String _plan;
  late bool _isMember;
  late ShodanAccountUsageLimits _usageLimits;

  int get scanCreditsLeft => _scanCreditsLeft;
  int get queryCreditsLeft => _queryCreditsLeft;
  int get amountOfMonitoredIps => _amountOfMonitoredIps;
  String get plan => _plan;
  bool get isMember => _isMember;
  ShodanAccountUsageLimits get usageLimits => _usageLimits;

  ShodanAccount();

  ShodanAccount._(
      {required int scanCreditsLeft,
      required int queryCreditsLeft,
      required int amountOfMonitoredIps,
      required String currentPlan,
      required bool isMember,
      required ShodanAccountUsageLimits usageLimits})
      : _scanCreditsLeft = scanCreditsLeft,
        _queryCreditsLeft = queryCreditsLeft,
        _amountOfMonitoredIps = amountOfMonitoredIps,
        _plan = currentPlan,
        _isMember = isMember,
        _usageLimits = usageLimits;

  factory ShodanAccount.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'scan_credits': int scanCreditsLeft,
        'query_credits': int queryCreditsLeft,
        'monitored_ips': int amountOfMonitoredIps,
        'plan': String plan,
        'unlocked': bool isMember,
      } =>
        ShodanAccount._(
            scanCreditsLeft: scanCreditsLeft,
            queryCreditsLeft: queryCreditsLeft,
            amountOfMonitoredIps: amountOfMonitoredIps,
            currentPlan: plan,
            isMember: isMember,
            usageLimits: ShodanAccountUsageLimits.fromJson(json['usage_limits'])),
      _ => throw Exception('Failed to load account details.'),
    };
  }
}
