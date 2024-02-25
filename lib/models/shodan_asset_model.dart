import 'dart:io';
 
class ShodanTrigger {
  final String _name; 
  final bool _triggered;

  String get name => _name;
  bool get triggered => _triggered;

  ShodanTrigger(String name, bool triggered): _name = name, _triggered = triggered;
}

class ShodanAsset {
  String _id;
  String _name;
  DateTime _created;
  DateTime? _expiration;
  List<String> _ips;

  String get id => _id;
  String get name => _name;
  DateTime get created => _created;
  DateTime? get expiration => _expiration;
  List<String> get ips => _ips;

  ShodanAsset(
    {required String id,
    required String name,
    required DateTime created,
    required DateTime? expiration,
    required List<String> ips
    }): _id = id,
        _name = name,
        _created = created,
        _expiration = expiration,
        _ips = ips;

  factory ShodanAsset.fromJson(Map<String, dynamic> json) {
    return ShodanAsset(
      id: json['id'], 
      name: json['name'], 
      created: DateTime.parse(json['created']), 
      expiration: json['expires'] > 0 ? DateTime.parse(json['expiration']) : null,
      ips: List<String>.from(json['filters']['ip'] as List));
  }
}