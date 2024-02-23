import 'dart:io';
 
class ShodanTrigger {
  final String _name; 
  final bool _triggered;

  String get name => _name;
  bool get triggered => _triggered;

  ShodanTrigger(String name, bool triggered): _name = name, _triggered = triggered;
}

class ShodanAlert {
  late String _id;
  late String _name;
  late DateTime _created;
  late DateTime? _expiration;

  String get id => _id;
  String get name => _name;
  DateTime get created => _created;
  DateTime? get expiration => _expiration;

  ShodanAlert(
    {required String id,
    required String name,
    required DateTime created,
    DateTime? expiration
    }): _id = id,
        _name = name,
        _created = created,
        _expiration = expiration;

  factory ShodanAlert.fromJson(Map<String, dynamic> json) {
    return ShodanAlert(
      id: json['id'], 
      name: json['name'], 
      created: DateTime.parse(json['created']) , 
      expiration: DateTime.tryParse(json['expiration'] ?? ''));
  }
}