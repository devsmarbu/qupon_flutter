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
    
    // Generate options: Basic and Pro based on the offer's base price.
    // Basic: originalPrice is double the base price, price is base price.
    // Pro: originalPrice is double the base price, price is base price * 1.5.
    // For QAR 20, Basic = 20, Pro = 30. Original = 40.
    final basePrice = offer.price;
    final options = [
      OfferOption(
        id: 'basic',
        name: 'Basic',
        originalPrice: basePrice * 2.0,
        price: basePrice,
      ),
      OfferOption(
        id: 'pro',
        name: 'Pro',
        originalPrice: basePrice * 2.0,
        price: basePrice * 1.5,
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
