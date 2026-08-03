import '../../../offers/data/models/offer.dart';
import '../../../offers/data/models/offer_option.dart';

abstract class CartEvent {
  const CartEvent();
}

class LoadCart extends CartEvent {
  const LoadCart();
}

class AddToCart extends CartEvent {
  final Offer offer;
  final OfferOption option;

  const AddToCart({required this.offer, required this.option});
}

class RemoveFromCart extends CartEvent {
  final String key;

  const RemoveFromCart({required this.key});
}

class ToggleGift extends CartEvent {
  final bool isGift;

  const ToggleGift({required this.isGift});
}


class SelectPaymentMethod extends CartEvent {
  final String method;

  const SelectPaymentMethod({required this.method});
}

class PlaceOrder extends CartEvent {
  /// Recipient phone number — only relevant when gift == true
  final String giftPhoneNumber;

  const PlaceOrder({this.giftPhoneNumber = ''});
}

class ClearCart extends CartEvent {
  const ClearCart();
}
