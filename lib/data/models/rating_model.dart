
class RatingModel {
  final String criteria;
  final double rating;
  final String? comment;

  RatingModel({
    required this.criteria,
    required this.rating,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'criteria': criteria,
      'rating': rating,
      'comment': comment,
    };
  }
}
