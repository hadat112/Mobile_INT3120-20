import 'package:scoped_model/scoped_model.dart';

class Product extends Model {
  final String name;
  final String description;
  final int price;
  final String image;
  int rating;

  Product(this.name, this.description, this.price, this.image, this.rating);
  factory Product.fromMap(Map<String, dynamic> json) {
    return Product(
      json['name'],
      json['description'],
      json['price'],
      json['image'],
      json['rating'],
    );
  }

  static List<Product> getProducts() {
    List<Product> items = <Product>[];

    items.add(
        Product(
            "Pixel",
            "Pixel is the most feature-full phone ever", 800,
            "pixel.jpeg", 0
        )
    );
    items.add(
        Product(
            "Laptop", "Laptop is most productive development tool", 2000,
            "laptop.jpeg", 0
        )
    );
    items.add(
        Product(
            "Tablet",
            "Tablet is the most useful device ever for meeting", 1500,
            "tablet.jpeg", 0
        )
    );
    items.add(
        Product(
            "Pendrive",
            "Pendrive is useful storage medium",
            100, "pendrive.jpeg", 0
        )
    );
    items.add(
        Product(
            "Floppy Drive",
            "Floppy drive is useful rescue storage medium", 20,
            "floppydisk.jpeg", 0
        )
    );
    return items;
  }


  void updateRating(int myRating) {
    rating = myRating;
    notifyListeners();
  }

}