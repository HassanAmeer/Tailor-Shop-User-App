import 'package:ThreeStarWorld/helpers/nullables.dart';

class ItemModel {
  String title;
  String desc;
  String image;
  String size;
  String price;

  ItemModel({
    this.title = "",
    this.desc = "",
    this.image = "",
    this.size = "",
    this.price = "",
  });

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      title: map['title'].toString().toNullString(),
      desc: map['desc'].toString().toNullString(),
      image: map['image'].toString().toNullString(),
      size: map['size'].toString().toNullString(),
      price: map['price'].toString().toNullString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'desc': desc,
      'image': image,
      'size': size,
      'price': price,
    };
  }
}
