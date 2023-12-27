import 'dart:io';
/*** 
class ShodanTrigger {
  final String _name; 
  final bool _triggered;

  String get name => _name;
  bool get triggered => _triggered;

  ShodanTrigger(String name, bool triggered): _name = name, _triggered = triggered;
}

class ShodanAlert {
  final String _name;
  final DateTime _created;
  final Set<InternetAddress> filters;
  late DateTime _expiration;

  ShodanAlert({required String name, required DateTime created, })

  factory ShodanAlert.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'created': String creationDate,
        'filters': Set<ShodanTrigger> filters,
        'expiration': String expirationDate
      } => 
        ShodanAlert(na)
    };
  }
}*/