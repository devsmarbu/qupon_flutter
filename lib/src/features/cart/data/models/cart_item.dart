import '../../../offers/data/models/offer.dart';
import '../../../offers/data/models/offer_option.dart';

class CartItem {
  final Offer offer;
  final OfferOption option;
  final int quantity;

  const CartItem({
    required this.offer,
    required this.option,
    this.quantity = 1,
  });

  CartItem copyWith({
    Offer? offer,
    OfferOption? option,
    int? quantity,
  }) {
    return CartItem(
      offer: offer ?? this.offer,
      option: option ?? this.option,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          offer.id == other.offer.id &&
          option.id == other.option.id;

  @override
  int get hashCode => offer.id.hashCode ^ option.id.hashCode;
}
