import '../models/infaq_models.dart';
import '../services/api_service.dart';

class InfaqController {
  final ApiService _apiService = ApiService();

  Future<List<Infaq>> getAllInfaq() async {
    return await _apiService.fetchInfaq();
  }

  Future<void> createInfaq(Infaq infaq) async {
    await _apiService.createInfaq(infaq);
  }

  Future<void> updateInfaq(Infaq infaq) async {
    await _apiService.updateInfaq(infaq);
  }

  Future<void> deleteInfaq(int id) async {
    await _apiService.deleteInfaq(id);
  }
}
