import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:property_agent/data/services/google_places_service.dart';

part 'address_suggestions_provider.g.dart';

@riverpod
class AddressSuggestions extends _$AddressSuggestions {
  final _places = GooglePlacesService();

  @override
  AsyncValue<List<PlacePrediction>> build() => const AsyncData([]);

  Future<void> fetchSuggestions(String query) async {
    if (query.length < 3) {
      state = const AsyncData([]);
      return;
    }
    
    state = const AsyncLoading();
    try {
      final preds = await _places.autocomplete(
        input: query,
        country: 'in',
        language: 'en',
      );
      state = AsyncData(preds);
    } catch (e, st) {
      state = AsyncError(e, st);
      // We return the error so the UI can show a snackbar if needed
      throw e;
    }
  }

  void clear() {
    state = const AsyncData([]);
  }
}
