part of 'offers_bloc.dart';

@freezed
class OffersState with _$OffersState {
  const factory OffersState.initial() = OffersInitial;
  const factory OffersState.loading() = OffersLoading;
  const factory OffersState.loaded(List<Offer> offers) = OffersLoaded;
  const factory OffersState.error(String message) = OffersError;
}
