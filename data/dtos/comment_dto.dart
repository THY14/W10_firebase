import '../../model/comment/comment.dart';

class CommentDto {
  static const String textKey = 'text';
  static const String artistIdKey = 'artistId';

  static Comment fromJson(String id, Map<String, dynamic> json) {
    return Comment(
      id: id,
      text: json[textKey],
      artistId: json[artistIdKey],
    );
  }

  static Map<String, dynamic> toJson(String artistId, String text) {
    return {
      textKey: text,
      artistIdKey: artistId,
    };
  }
}