import 'dart:io';
 
class ShodanTrigger {
  final String _name; 
  final bool _triggered;

  String get name => _name;
  bool get triggered => _triggered;

  ShodanTrigger(String name, bool triggered): _name = name, _triggered = triggered;
}

class ShodanAlert {
  late String _name;
  late DateTime _created;
  late DateTime _expiration;
  String get name => _name;
  DateTime get created => _created;
  DateTime get expiration => _expiration;

  ShodanAlert();

  ShodanAlert._(
    {required String name,
    required DateTime created,
    required DateTime expiration
    }): _name = name,
        _created = created,
        _expiration = expiration;

  factory ShodanAlert.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'created': DateTime creationDate,
        'expiration': DateTime expirationDate
      } => 
        ShodanAlert._(
          name: name, 
          created: creationDate,
          expiration: expirationDate,
        ),
      _ => throw Exception('Failed to load an alert.'),
    };
  }
}