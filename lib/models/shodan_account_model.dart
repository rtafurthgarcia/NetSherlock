class ShodanAccount {
  late int _creditsLeft;
  late bool _isMember;
  late String _accountName;
  late DateTime _creationDate;

  int get creditsLeft => _creditsLeft;
  bool get isMember => _isMember;
  String get accountName => _accountName;
  DateTime get creationDate => _creationDate;

  ShodanAccount();

  ShodanAccount._({required int creditsLeft, required bool isMember, required String accountName, required DateTime creationDate}):
    _creditsLeft = creditsLeft, _isMember = isMember, _accountName = accountName, _creationDate = creationDate;

  factory ShodanAccount.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'member': bool isMember,
        'credits': int creditsLeft,
        'display_name': String? accountName,
        'created': String creationDate
      } =>
        ShodanAccount._(
          accountName: accountName ?? '',
          creditsLeft: creditsLeft,
          isMember: isMember,
          creationDate: DateTime.parse(creationDate)
        ),

      _ => throw Exception('Failed to load account details.'),
    };
  }
}
