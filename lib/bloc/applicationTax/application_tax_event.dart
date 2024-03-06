// ignore_for_file: public_member_api_docs, sort_constructors_first
class ApplicationTaxEvent {
  final bool isUSCitizen;
  final bool isUSResident;
  final bool isPPonly;
  final bool isTINvalid;
  final bool isCRS;
  final bool hasTIN;
  ApplicationTaxEvent({
    required this.isUSCitizen,
    required this.isUSResident,
    required this.isPPonly,
    required this.isTINvalid,
    required this.isCRS,
    required this.hasTIN,
  });
}
