import 'package:equatable/equatable.dart';

class PropertyOfficeDetails extends Equatable {
  final double? carpetArea;
  final double? builtUpArea;
  final double? superBuiltUpArea;
  final int? cabins;
  final int? meetingRooms;
  final int? seats;
  final int? maxSeats;
  final int? conferenceRooms;
  final bool? liftAvailable;
  final bool? preLeased;
  final String? officeType;
  final bool? receptionArea;
  final bool? pantry;
  final bool? cafeteria;
  final bool? serverRoom;
  final bool? fireSafetyInstalled;
  final bool? centralAC;
  final bool? visitorParking;
  final int? numberOfLifts;
  final bool? taxIncluded;
  final bool? officeNegotiable;
  final double? officeMaintenanceCharges;
  final double? officeBookingAmount;

  const PropertyOfficeDetails({
    this.carpetArea,
    this.builtUpArea,
    this.superBuiltUpArea,
    this.cabins,
    this.meetingRooms,
    this.seats,
    this.maxSeats,
    this.conferenceRooms,
    this.liftAvailable,
    this.preLeased,
    this.officeType,
    this.receptionArea,
    this.pantry,
    this.cafeteria,
    this.serverRoom,
    this.fireSafetyInstalled,
    this.centralAC,
    this.visitorParking,
    this.numberOfLifts,
    this.taxIncluded,
    this.officeNegotiable,
    this.officeMaintenanceCharges,
    this.officeBookingAmount,
  });

  @override
  List<Object?> get props => [
        carpetArea,
        builtUpArea,
        superBuiltUpArea,
        cabins,
        meetingRooms,
        seats,
        maxSeats,
        conferenceRooms,
        liftAvailable,
        preLeased,
        officeType,
        receptionArea,
        pantry,
        cafeteria,
        serverRoom,
        fireSafetyInstalled,
        centralAC,
        visitorParking,
        numberOfLifts,
        taxIncluded,
        officeNegotiable,
        officeMaintenanceCharges,
        officeBookingAmount,
      ];
}
