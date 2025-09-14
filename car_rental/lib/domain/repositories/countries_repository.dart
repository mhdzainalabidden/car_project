import '../../data/datasources/countries_remote_datasource.dart';

abstract class CountriesRepository {
  Future<CountriesResponse> getCountries({int page = 1});
}
