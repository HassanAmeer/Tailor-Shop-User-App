import 'package:tailor_admin/helpers/nullables.dart';

class ItemModel {
  String id;
  String title;
  String desc;
  String image;
  String size;
  String price;

  ItemModel(
      {this.id = "",
      this.title = "",
      this.desc = "",
      this.image = "",
      this.size = "",
      this.price = ""});

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
        id: map['id'].toString().toNullString(),
        title: map['title'].toString().toNullString(),
        desc: map['desc'].toString().toNullString(),
        image: map['image'].toString().toNullString(),
        size: map['size'].toString().toNullString(),
        price: map['price'].toString().toNullString());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'image': image,
      'size': size,
      'price': price,
    };
  }
}
