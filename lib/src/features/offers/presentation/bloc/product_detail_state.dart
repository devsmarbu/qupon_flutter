import '../../data/models/offer.dart';
import '../../data/models/offer_option.dart';

class ProductDetailState {
  final Offer? offer;
  final List<OfferOption> options;
  final int selectedOptionIndex;
  final bool isFavorite;
  final bool isBookmarked;
  final bool isLoading;

  const ProductDetailState({
    this.offer,
    this.options = const [],
    this.selectedOptionIndex = 0,
    this.isFavorite = false,
    this.isBookmarked = false,
    this.isLoading = false,
  });

  ProductDetailState copyWith({
    Offer? offer,
    List<OfferOption>? options,
    int? selectedOptionIndex,
    bool? isFavorite,
    bool? isBookmarked,
    bool? isLoading,
  }) {
    return ProductDetailState(
      offer: offer ?? this.offer,
      options: options ?? this.options,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
      isFavorite: isFavorite ?? this.isFavorite,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
