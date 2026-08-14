import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/offer.dart';
import '../../data/repositories/offers_repository.dart';

part 'offers_event.dart';
part 'offers_state.dart';

class OffersBloc extends Bloc<OffersEvent, OffersState> {
  final OffersRepository _offersRepository;

  OffersBloc({required OffersRepository offersRepository})
      : _offersRepository = offersRepository,
        super(const OffersInitial()) {
    on<FetchOffers>(_onFetchOffers);
  }

  Future<void> _onFetchOffers(FetchOffers event, Emitter<OffersState> emit) async {
    emit(const OffersLoading());
    try {
      final List<Offer> offers;
      if (event.categoryId != null) {
        offers = await _offersRepository.getCategoryOffers(event.categoryId!);
      } else {
        offers = await _offersRepository.getOffers();
      }
      emit(OffersLoaded(offers));
    } catch (e) {
      emit(OffersError(e.toString()));
    }
  }
}
