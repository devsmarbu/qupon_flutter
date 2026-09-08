import '../../data/models/offer.dart';
import '../../data/models/offer_option.dart';

abstract class ProductDetailEvent {
  const ProductDetailEvent();
}

class InitializeProductDetail extends ProductDetailEvent {
  final Offer offer;
  final List<OfferOption> variants;
  final bool preloaded;

  const InitializeProductDetail(
    this.offer, {
    this.variants = const [],
    this.preloaded = false,
  });
}

class SelectOption extends ProductDetailEvent {
  final int index;

  const SelectOption(this.index);
}

class ToggleFavorite extends ProductDetailEvent {
  const ToggleFavorite();
}

class ToggleBookmark extends ProductDetailEvent {
  const ToggleBookmark();
}
