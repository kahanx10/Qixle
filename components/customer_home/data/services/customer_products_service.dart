import 'package:amazon_clone/common/data/constants.dart';
import 'package:http/http.dart' as http;

class CustomerProductsService {
  // Rating
  static Future<http.Response?> rateProduct({
    required num rating,
    required String productId,
    required String token,
  }) async {
    try {
      var res = await http.get(
        Uri.parse(
          '${Constants.host}/products/$productId/ratings/$rating',
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authToken': token,
        },
      );

      return res;
    } catch (e) {
      print('Error rating product: $e');
      return null;
    }
  }

  static Future<http.Response?> fetchDealOfTheDay({
    required String token,
  }) async {
    try {
      var res = await http.get(
        Uri.parse(
          '${Constants.host}/products/deal-of-the-day',
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authToken': token,
        },
      );

      return res;
    } catch (e) {
      print('Error rating product: $e');
      return null;
    }
  }

  static Future<http.Response?> fetchMyRatingOnProduct({
    required String productId,
    required String token,
  }) async {
    try {
      var res = await http.get(
        Uri.parse(
          '${Constants.host}/products/$productId/my-rating',
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authToken': token,
        },
      );

      return res;
    } catch (e) {
      print('Error rating product: $e');
      return null;
    }
  }

  // Method to fetch products by their name
  static Future<http.Response?> fetchProductsBySearch({
    required String name,
    required String token,
  }) async {
    try {
      var res = await http.get(
        Uri.parse('${Constants.host}/products/$name'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authToken': token,
        },
      );

      return res;
    } catch (e) {
      print('Error fetching products by name: $e');
      return null;
    }
  }

  // Method to fetch products by their category
  static Future<http.Response?> fetchProductsByCategory({
    required String category,
    required String token,
  }) async {
    try {
      var res = await http.get(
        Uri.parse('${Constants.host}/products?category=$category'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authToken': token,
        },
      );

      return res;
    } catch (e) {
      print('Error fetching products by name: $e');
      return null;
    }
  }
}
