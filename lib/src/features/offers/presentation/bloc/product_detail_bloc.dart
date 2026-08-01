import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/offer_option.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc() : super(const ProductDetailState()) {
    on<InitializeProductDetail>(_onInitialize);
    on<SelectOption>(_onSelectOption);
    on<ToggleFavorite>(_onToggleFavorite);
    on<ToggleBookmark>(_onToggleBookmark);
  }

  void _onInitialize(
    InitializeProductDetail event,
    Emitter<ProductDetailState> emit,
  ) {
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
  }

  void _onSelectOption(
    SelectOption event,
    Emitter<ProductDetailState> emit,
  ) {
    emit(state.copyWith(selectedOptionIndex: event.index));
  }

  void _onToggleFavorite(
    ToggleFavorite event,
    Emitter<ProductDetailState> emit,
  ) {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }

  void _onToggleBookmark(
    ToggleBookmark event,
    Emitter<ProductDetailState> emit,
  ) {
    emit(state.copyWith(isBookmarked: !state.isBookmarked));
  }
}
