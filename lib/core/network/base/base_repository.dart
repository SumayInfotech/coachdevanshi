import '../client/api_client_impl.dart';
import '../contracts/network_service.dart';

abstract class BaseRepository {
  final NetworkService networkService = ApiClientImpl();
}