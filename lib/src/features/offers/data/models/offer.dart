import 'package:freezed_annotation/freezed_annotation.dart';
import 'offer_option.dart';

part 'offer.freezed.dart';
part 'offer.g.dart';

@freezed
class Offer with _$Offer {
  const factory Offer({
    required String id,
    required String title,
    required String category,
    required String imageUrl,
    required int daysLeft,
    required int hoursLeft,
    required int minutesLeft,
    required String location,
    required String description,
    required double price,
    required String currency,
    String? titleAr,
    String? descriptionAr,
    String? vendor,
    String? validity,
    String? slug,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default([])
    List<OfferOption> variants,
  }) = _Offer;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
}
