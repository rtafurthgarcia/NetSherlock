class ShodanAccountUsageLimits {
  int _scanCredits;
  int _queryCredits;
  int _monitoredIps;

  int get scanCredits => _scanCredits;
  int get queryCredits => _queryCredits;
  int get monitoredIps => _monitoredIps;

  ShodanAccountUsageLimits({required int scanCredits, required int queryCredits, required int monitoredIps}): 
  _scanCredits = scanCredits, _queryCredits = queryCredits, _monitoredIps = monitoredIps;

  factory ShodanAccountUsageLimits.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'scan_credits': int scanCredits,
        'query_credits': int queryCredits,
        'monitored_ips': int monitoredIps,
      } =>
        ShodanAccountUsageLimits(
          scanCredits: scanCredits,
          queryCredits: queryCredits,
          monitoredIps: monitoredIps,
        ),

      _ => throw Exception('Failed to load usage limits.'),
    };
  }
}