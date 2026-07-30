import 'package:flutter_test/flutter_test.dart';
import 'package:qupon/src/features/offers/data/models/offer.dart';
import 'package:qupon/src/features/offers/presentation/bloc/product_detail_bloc.dart';
import 'package:qupon/src/features/offers/presentation/bloc/product_detail_event.dart';
import 'package:qupon/src/features/offers/presentation/bloc/product_detail_state.dart';

void main() {
  group('ProductDetailBloc Tests', () {
    late Offer testOffer;

    setUp(() {
      testOffer = const Offer(
        id: '5',
        title: 'Tech Gadgets 15%',
        category: 'Electronics',
        imageUrl: 'https://images.unsplash.com/photo-1531297484001-80022131f5a1?auto=format&fit=crop&w=800&q=80',
        daysLeft: 152,
        hoursLeft: 15,
        minutesLeft: 32,
        location: '123 Tech Avenue, Silicon Valley, CA 94025',
        description: 'Upgrade your tech arsenal with 15% off smart home devices, headphones, and more.',
        price: 20.0,
        currency: 'QAR',
      );
    });

    test('initial state is correct', () {
      final bloc = ProductDetailBloc();
      expect(bloc.state.offer, isNull);
      expect(bloc.state.options, isEmpty);
      expect(bloc.state.selectedOptionIndex, 0);
      expect(bloc.state.isFavorite, isFalse);
      expect(bloc.state.isBookmarked, isFalse);
      bloc.close();
    });

    test('InitializeProductDetail populates offer and options', () {
      final bloc = ProductDetailBloc();
      bloc.add(InitializeProductDetail(testOffer));
      
      expect(
        bloc.stream,
        emitsInOrder([
          predicate<ProductDetailState>((state) {
            return state.offer == testOffer &&
                state.options.length == 2 &&
                state.options[0].name == 'Basic' &&
                state.options[0].price == 20.0 &&
                state.options[0].originalPrice == 40.0 &&
                state.options[1].name == 'Pro' &&
                state.options[1].price == 30.0 &&
                state.options[1].originalPrice == 40.0;
          }),
        ]),
      );
    });

    test('SelectOption updates selected option index', () {
      final bloc = ProductDetailBloc();
      bloc.add(InitializeProductDetail(testOffer));
      bloc.add(const SelectOption(1));

      expect(
        bloc.stream,
        emitsInOrder([
          anything, // Initialize state
          predicate<ProductDetailState>((state) => state.selectedOptionIndex == 1),
        ]),
      );
    });

    test('ToggleFavorite updates isFavorite state', () {
      final bloc = ProductDetailBloc();
      bloc.add(InitializeProductDetail(testOffer));
      bloc.add(const ToggleFavorite());

      expect(
        bloc.stream,
        emitsInOrder([
          anything, // Initialize state
          predicate<ProductDetailState>((state) => state.isFavorite == true),
        ]),
      );
    });

    test('ToggleBookmark updates isBookmarked state', () {
      final bloc = ProductDetailBloc();
      bloc.add(InitializeProductDetail(testOffer));
      bloc.add(const ToggleBookmark());

      expect(
        bloc.stream,
        emitsInOrder([
          anything, // Initialize state
          predicate<ProductDetailState>((state) => state.isBookmarked == true),
        ]),
      );
    });
  });
}
