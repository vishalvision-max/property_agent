import 'package:equatable/equatable.dart';

class PropertyShowroomDetails extends Equatable {
  final double? showroomArea;
  final String? showroomAreaUnit;
  final double? showroomFrontageWidth;
  final double? showroomCeilingHeight;
  final bool? showroomMainRoadFacing;
  final bool? showroomCorner;
  final bool? showroomWashroom;
  final int? showroomParkingSlots;
  final String? showroomFurnishing;
  final String? showroomFloorType;
  final String? showroomMarketName;
  final String? showroomLocality;
  final String? showroomOwnerName;
  final String? showroomOwnerMobile;

  const PropertyShowroomDetails({
    this.showroomArea,
    this.showroomAreaUnit,
    this.showroomFrontageWidth,
    this.showroomCeilingHeight,
    this.showroomMainRoadFacing,
    this.showroomCorner,
    this.showroomWashroom,
    this.showroomParkingSlots,
    this.showroomFurnishing,
    this.showroomFloorType,
    this.showroomMarketName,
    this.showroomLocality,
    this.showroomOwnerName,
    this.showroomOwnerMobile,
  });

  @override
  List<Object?> get props => [
        showroomArea,
        showroomAreaUnit,
        showroomFrontageWidth,
        showroomCeilingHeight,
        showroomMainRoadFacing,
        showroomCorner,
        showroomWashroom,
        showroomParkingSlots,
        showroomFurnishing,
        showroomFloorType,
        showroomMarketName,
        showroomLocality,
        showroomOwnerName,
        showroomOwnerMobile,
      ];
}
