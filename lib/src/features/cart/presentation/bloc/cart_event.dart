import '../../../offers/data/models/offer.dart';
import '../../../offers/data/models/offer_option.dart';
import '../../data/models/cart_item.dart';

abstract class CartEvent {
  const CartEvent();
}

class AddToCart extends CartEvent {
  final Offer offer;
  final OfferOption option;

  const AddToCart({required this.offer, required this.option});
}

class RemoveFromCart extends CartEvent {
  final CartItem item;

  const RemoveFromCart({required this.item});
}

class ToggleGift extends CartEvent {
  final bool isGift;

  const ToggleGift({required this.isGift});
}

class SelectPaymentMethod extends CartEvent {
  final String method;

  const SelectPaymentMethod({required this.method});
}

class ClearCart extends CartEvent {
  const ClearCart();
}
