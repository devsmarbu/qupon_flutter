// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OfferImpl _$$OfferImplFromJson(Map<String, dynamic> json) => _$OfferImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  category: json['category'] as String,
  imageUrl: json['imageUrl'] as String,
  daysLeft: (json['daysLeft'] as num).toInt(),
  hoursLeft: (json['hoursLeft'] as num).toInt(),
  minutesLeft: (json['minutesLeft'] as num).toInt(),
  location: json['location'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  currency: json['currency'] as String,
  titleAr: json['titleAr'] as String?,
  descriptionAr: json['descriptionAr'] as String?,
  vendor: json['vendor'] as String?,
  validity: json['validity'] as String?,
  slug: json['slug'] as String?,
);

Map<String, dynamic> _$$OfferImplToJson(_$OfferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'imageUrl': instance.imageUrl,
      'daysLeft': instance.daysLeft,
      'hoursLeft': instance.hoursLeft,
      'minutesLeft': instance.minutesLeft,
      'location': instance.location,
      'description': instance.description,
      'price': instance.price,
      'currency': instance.currency,
      'titleAr': instance.titleAr,
      'descriptionAr': instance.descriptionAr,
      'vendor': instance.vendor,
      'validity': instance.validity,
      'slug': instance.slug,
    };
