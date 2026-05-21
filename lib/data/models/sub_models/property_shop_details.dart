import 'package:equatable/equatable.dart';

class PropertyShopDetails extends Equatable {
  final String? shopType;
  final double? shopArea;
  final String? shopAreaUnit;
  final double? frontageWidth;
  final double? ceilingHeight;
  final bool? mainRoadFacing;
  final bool? cornerShop;
  final bool? washroomAvailable;
  final String? floorType;
  final String? marketName;
  final String? locality;

  const PropertyShopDetails({
    this.shopType,
    this.shopArea,
    this.shopAreaUnit,
    this.frontageWidth,
    this.ceilingHeight,
    this.mainRoadFacing,
    this.cornerShop,
    this.washroomAvailable,
    this.floorType,
    this.marketName,
    this.locality,
  });

  @override
  List<Object?> get props => [
        shopType,
        shopArea,
        shopAreaUnit,
        frontageWidth,
        ceilingHeight,
        mainRoadFacing,
        cornerShop,
        washroomAvailable,
        floorType,
        marketName,
        locality,
      ];
}
