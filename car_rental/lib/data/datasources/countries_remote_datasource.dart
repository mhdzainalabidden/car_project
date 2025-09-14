import '../../domain/entities/country.dart';

class CountriesResponse {
  final List<Country> countries;
  final int currentPage;
  final int lastPage;
  final int total;

  CountriesResponse({
    required this.countries,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}

abstract class CountriesRemoteDataSource {
  Future<CountriesResponse> getCountries({int page = 1});
}
