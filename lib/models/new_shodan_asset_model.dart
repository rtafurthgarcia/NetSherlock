import 'dart:convert';

class NewShodanAsset {
  final String _name;
  final DateTime? _expiration;
  final List<String> _ips;

  String get name => _name;
  DateTime? get expiration => _expiration;
  List<String> get ips => _ips;

  NewShodanAsset(
    {required String name,
    DateTime? expiration,
    required List<String> ips
    }): _name = name,
        _expiration = expiration,
        _ips = ips;

   String toJsonString() {
    return json.encode({
      'name': _name,
      'filters': {
        "ip": _ips
      },
      'expiration': _expiration == null ? null : _expiration!.toIso8601String() ,
    });
  }
}