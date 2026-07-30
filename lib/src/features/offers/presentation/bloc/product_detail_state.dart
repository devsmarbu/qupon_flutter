import '../../data/models/offer.dart';
import '../../data/models/offer_option.dart';

class ProductDetailState {
  final Offer? offer;
  final List<OfferOption> options;
  final int selectedOptionIndex;
  final bool isFavorite;
  final bool isBookmarked;

  const ProductDetailState({
    this.offer,
    this.options = const [],
    this.selectedOptionIndex = 0,
    this.isFavorite = false,
    this.isBookmarked = false,
  });

  ProductDetailState copyWith({
    Offer? offer,
    List<OfferOption>? options,
    int? selectedOptionIndex,
    bool? isFavorite,
    bool? isBookmarked,
  }) {
    return ProductDetailState(
      offer: offer ?? this.offer,
      options: options ?? this.options,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
      isFavorite: isFavorite ?? this.isFavorite,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
