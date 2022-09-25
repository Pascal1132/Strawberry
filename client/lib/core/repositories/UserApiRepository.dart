import 'package:http/http.dart';
import 'package:strawberry/core/repositories/AApiRepository.dart';

class UserApiRepository extends AApiRepository {
  Future<Response> getUser() async {
    return super.get('WeatherForecast');
  }
}
