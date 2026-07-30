part of 'offers_bloc.dart';

@freezed
class OffersEvent with _$OffersEvent {
  const factory OffersEvent.fetchOffers({String? categoryId}) = FetchOffers;
}
