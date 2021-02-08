import 'package:moor/moor.dart';

class Favorite {
  String productId;

  Favorite({@required this.productId});

  factory Favorite.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Favorite(
      productId: serializer.fromJson<String>(json['productId']),
    );
  }
}
