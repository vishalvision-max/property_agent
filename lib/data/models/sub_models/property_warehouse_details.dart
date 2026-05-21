import 'package:equatable/equatable.dart';

class PropertyWarehouseDetails extends Equatable {
  final String? warehouseType;
  final double? warehousePlotArea;
  final String? warehousePlotAreaUnit;
  final double? warehouseCeilingHeight;
  final int? warehouseLoadingBays;
  final int? warehouseDockLevelers;
  final String? warehousePowerSupply;
  final bool? warehouseIndustrialLicense;
  final String? warehouseTruckAccess;
  final String? warehouseAreaName;
  final String? warehouseCity;

  const PropertyWarehouseDetails({
    this.warehouseType,
    this.warehousePlotArea,
    this.warehousePlotAreaUnit,
    this.warehouseCeilingHeight,
    this.warehouseLoadingBays,
    this.warehouseDockLevelers,
    this.warehousePowerSupply,
    this.warehouseIndustrialLicense,
    this.warehouseTruckAccess,
    this.warehouseAreaName,
    this.warehouseCity,
  });

  @override
  List<Object?> get props => [
        warehouseType,
        warehousePlotArea,
        warehousePlotAreaUnit,
        warehouseCeilingHeight,
        warehouseLoadingBays,
        warehouseDockLevelers,
        warehousePowerSupply,
        warehouseIndustrialLicense,
        warehouseTruckAccess,
        warehouseAreaName,
        warehouseCity,
      ];
}
