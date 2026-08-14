part of 'offers_bloc.dart';

abstract class OffersState {
  const OffersState();
}

class OffersInitial extends OffersState {
  const OffersInitial();
}

class OffersLoading extends OffersState {
  const OffersLoading();
}

class OffersLoaded extends OffersState {
  final List<Offer> offers;
  const OffersLoaded(this.offers);
}

class OffersError extends OffersState {
  final String message;
  const OffersError(this.message);
}
