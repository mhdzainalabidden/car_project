import '../../domain/repositories/countries_repository.dart';
import '../datasources/countries_remote_datasource.dart';

class CountriesRepositoryImpl implements CountriesRepository {
  final CountriesRemoteDataSource _remoteDataSource;

  CountriesRepositoryImpl(this._remoteDataSource);

  @override
  Future<CountriesResponse> getCountries({int page = 1}) async {
    return await _remoteDataSource.getCountries(page: page);
  }
}
