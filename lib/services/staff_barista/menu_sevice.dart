import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/menu_item.dart';
import '../../models/category.dart';

class MenuService {
  final String? baseUrl = dotenv.env['BARISTA_URL'];

  Future<List<MenuItem>> fetchMenuItems() async {
    final url = Uri.parse('$baseUrl/menu-items');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("Response body: ${response.body}");
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> data = responseData['data'];
          return data.map((item) => MenuItem.fromJson(item)).toList();
        }
      } else {
        throw Exception('Không thể tải danh sách sản phẩm');
      }
    } catch (error) {
      print("Lỗi khi tải menu: $error");
      throw Exception('Lỗi kết nối đến server');
    }
    throw Exception('Không thể tải danh sách sản phẩm');
  }

  Future<List<Category>> fetchCategories() async {
    final url = Uri.parse('$baseUrl/categories');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data') && responseData['data'] is List) {
          return responseData['data']
              .map<Category>((item) => Category.fromJson(item))
              .toList();
        }
      }
      throw Exception('Không thể tải danh mục');
    } catch (error) {
      print("Lỗi khi tải danh mục: $error");
      throw Exception('Lỗi kết nối đến server');
    }
  }

  Future<void> toggleAvailability(int itemId) async {
    final url = Uri.parse('$baseUrl/menu-items/$itemId/toggle');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("Cập nhật trạng thái thành công");
      } else {
        throw Exception("Không thể cập nhật trạng thái");
      }
    } catch (error) {
      print("Lỗi khi cập nhật trạng thái: $error");
      throw Exception("Lỗi kết nối đến server");
    }
  }
}
