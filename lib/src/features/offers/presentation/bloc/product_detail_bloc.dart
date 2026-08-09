import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/offer_option.dart';
import '../../data/repositories/offers_repository.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final OffersRepository _offersRepository;

  ProductDetailBloc({OffersRepository? offersRepository})
      : _offersRepository = offersRepository ?? OffersRepositoryImpl(),
        super(const ProductDetailState()) {
    on<InitializeProductDetail>(_onInitialize);
    on<SelectOption>(_onSelectOption);
    on<ToggleFavorite>(_onToggleFavorite);
    on<ToggleBookmark>(_onToggleBookmark);
  }

  Future<void> _onInitialize(
    InitializeProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    final offer = event.offer;

    // Use variants from the event if provided (populated from API).
    // Fall back to a Basic/Pro pair derived from the offer price if none exist.
    final List<OfferOption> options = event.variants.isNotEmpty
        ? event.variants
        : [
            OfferOption(
              id: '1',
              name: 'Basic',
              originalPrice: offer.price * 2.0,
              price: offer.price,
            ),
            OfferOption(
              id: '2',
              name: 'Pro',
              originalPrice: offer.price * 2.0,
              price: offer.price * 1.5,
            ),
          ];

    emit(ProductDetailState(
      offer: offer,
      options: options,
      selectedOptionIndex: 0,
      isFavorite: false,
      isBookmarked: false,
    ));

    final slug = (offer.slug != null && offer.slug!.isNotEmpty) ? offer.slug! : offer.id;
    if (slug.isNotEmpty) {
      try {
        final detailedOffer = await _offersRepository.getCouponDetails(slug);
        
        final List<OfferOption> newOptions = detailedOffer.variants.isNotEmpty
            ? detailedOffer.variants
            : options;

        emit(state.copyWith(
          offer: detailedOffer,
          options: newOptions,
        ));
      } catch (_) {
        // Keep showing the initial offer if fetch fails
      }
    }
  }

  void _onSelectOption(
    SelectOption event,
    Emitter<ProductDetailState> emit,
  ) {
    emit(state.copyWith(selectedOptionIndex: event.index));
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<ProductDetailState> emit,
  ) async {
    final couponId = state.offer?.id;
    final nextFav = !state.isFavorite;

    // Optimistic UI state update
    emit(state.copyWith(isFavorite: nextFav));

    if (couponId != null && couponId.isNotEmpty) {
      try {
        final wishlisted = await _offersRepository.toggleWishlist(couponId: couponId);
        emit(state.copyWith(isFavorite: wishlisted));
      } catch (_) {
        // Revert on error
        emit(state.copyWith(isFavorite: !nextFav));
      }
    }
  }

  void _onToggleBookmark(
    ToggleBookmark event,
    Emitter<ProductDetailState> emit,
  ) {
    emit(state.copyWith(isBookmarked: !state.isBookmarked));
  }
}
