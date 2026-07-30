import '../../data/models/offer.dart';

abstract class ProductDetailEvent {
  const ProductDetailEvent();
}

class InitializeProductDetail extends ProductDetailEvent {
  final Offer offer;

  const InitializeProductDetail(this.offer);
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
