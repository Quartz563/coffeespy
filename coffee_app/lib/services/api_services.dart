import 'dart:convert';
import 'package:coffee_app/models/price_report.dart';
import 'package:coffee_app/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/cafe.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.93:4000/api';

  static Future<List<Cafe>> fetchCafes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/cafes'),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['data'];
      return jsonList.map((json) => Cafe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cafes');
    }
  }

  static Future<List<PriceReport>> fetchReports(int cafeId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cafes/$cafeId/price_reports'),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['data'];
      return jsonList.map((json) => PriceReport.fromJson(json)).toList();
      //this is erroring because it cannot create Cafe without address lat and long
    } else {
      throw Exception('Failed to get price reports for cafe $cafeId');
    }
  }

  static Future<List<PriceReport>> fetchUserReports(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/price_reports'),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['data'];
      return jsonList.map((json) => PriceReport.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get price reports for user $userId');
    }
  }

  static Future<PriceReport> createPriceReport(
    int cafeId,
    String drinkType,
    String milkType,
    String size,
    double price,
  ) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');
    final response = await http.post(
      Uri.parse('$baseUrl/cafes/$cafeId/price_reports/report'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'drink_type': drinkType,
        'milk_type': milkType,
        'size': size,
        'price': price,
      }),
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return PriceReport.fromJson(jsonResponse['data']);
    } else if (response.statusCode == 401) {
      throw Exception('Invalid User');
    } else {
      throw Exception('Price Report creation failed');
    }
  }

  static Future<void> createConfirmation(int cafeId, int priceReportId) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');
    final response = await http.post(
      Uri.parse('$baseUrl/cafes/$cafeId/price_reports/$priceReportId/confirm'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 201) {
      if (response.statusCode == 401) {
        throw Exception('Invalid User');
      } else {
        throw Exception('Confirmation failed');
      }
    }
  }
}
