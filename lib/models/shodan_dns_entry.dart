import 'dart:io';

class ShodanDNSEntry {
  String _subdomain;
  String _type;
  String _value;
  DateTime _lastSeen;

  String get subdomain => _subdomain;
  String get type => _type;
  String get value => _value;
  DateTime get lastSeen => _lastSeen;

  ShodanDNSEntry(
    {required String subdomain,
    required String type, 
    required String value,
    required DateTime lastSeen
    }): _subdomain = subdomain,
        _type = type,
        _value = value,
        _lastSeen = lastSeen;

  factory ShodanDNSEntry.fromJson(Map<String, dynamic> json) {
    return ShodanDNSEntry(
      subdomain: json['subdomain'], 
      type: json['type'],
      value: json['value'],
      lastSeen: DateTime.parse(json['last_seen'])
    );
  }
}

class ShodanDNSLookupResult {
  String _domain;
  List<String> _subdomains;
  List<ShodanDNSEntry> _entries;

  String get name => _domain;
  List<String> get subdomains => _subdomains;
  List<ShodanDNSEntry> get entries => _entries; 

  ShodanDNSLookupResult(
    {required String domain,
    required List<String> subdomains, 
    required List<ShodanDNSEntry> entries
    }): _domain = domain,
        _subdomains = subdomains,
        _entries = entries;

  factory ShodanDNSLookupResult.fromJson(Map<String, dynamic> json) {
    return ShodanDNSLookupResult(
      domain: json['domain'], 
      entries: List<ShodanDNSEntry>.from((json['data'] as List).map((s) => ShodanDNSEntry.fromJson(s))),
      subdomains: List<String>.from(json['subdomains'] as List));
  }
}