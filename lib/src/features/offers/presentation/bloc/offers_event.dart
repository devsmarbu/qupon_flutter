part of 'offers_bloc.dart';

abstract class OffersEvent {
  const OffersEvent();
}

class FetchOffers extends OffersEvent {
  final String? categoryId;
  const FetchOffers({this.categoryId});
}
