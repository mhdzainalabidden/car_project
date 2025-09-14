import 'package:http/http.dart' as http;
import 'dart:convert';
import 'countries_remote_datasource.dart';
import '../../domain/entities/country.dart';

class CountriesRemoteDataSourceImpl implements CountriesRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  CountriesRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<CountriesResponse> getCountries({int page = 1}) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/api/public/countries/?page=$page'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> countriesJson = data['data'] as List<dynamic>;
        final meta = data['meta'] as Map<String, dynamic>;

        final countries = countriesJson
            .map((json) => Country.fromJson(json as Map<String, dynamic>))
            .toList();

        return CountriesResponse(
          countries: countries,
          currentPage: meta['current_page'] as int,
          lastPage: meta['last_page'] as int,
          total: meta['total'] as int,
        );
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
