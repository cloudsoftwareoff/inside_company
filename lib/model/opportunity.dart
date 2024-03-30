class Opportunity {
  final String id;
  final String addedby;
  String name;
  String content;
  String status;
  String? letter_link;
Opportunity({
  required this.id,
  required this.addedby,
  required this.name,
  required this.content,
  required this.status,
  this.letter_link,
});

}
