import '../repositories/countries_repository.dart';
import '../../data/datasources/countries_remote_datasource.dart';

class GetCountriesUseCase {
  final CountriesRepository _countriesRepository;

  GetCountriesUseCase(this._countriesRepository);

  Future<CountriesResponse> call({int page = 1}) async {
    return await _countriesRepository.getCountries(page: page);
  }
}
