import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:property_agent/data/models/media_item.dart';
import 'package:property_agent/data/models/property.dart';
import 'package:property_agent/data/models/property_enums.dart';
import 'package:property_agent/data/mappers/property_prefill_mapper.dart';
import 'package:property_agent/data/models/property_kind.dart';
import 'package:property_agent/providers/property_form/property_form_state.dart';

part 'property_form_notifier.g.dart';

/// Business logic for the property creation/edit form.
/// All field mutations go through here — the UI just calls methods and reads state.
@riverpod
class PropertyForm extends _$PropertyForm {
  @override
  PropertyFormState build() => const PropertyFormState();

  // ── Basic ──────────────────────────────────────────────────────────────────

  void setTitle(String v) => state = state.copyWith(title: v);
  void setDescription(String v) => state = state.copyWith(description: v);
  void setPrice(String v) => state = state.copyWith(price: v);
  void setArea(String v) => state = state.copyWith(area: v);
  void setAreaUnit(String v) => state = state.copyWith(areaUnit: v);
  void setType(PropertyType v) => state = state.copyWith(type: v);
  void setListingType(String v) => state = state.copyWith(listingType: v);
  void setPropertyKind(PropertyKind v) =>
      state = state.copyWith(propertyKind: v);

  // ── Category ──────────────────────────────────────────────────────────────

  void selectParentCategory({required int id, required String slug}) {
    state = state.copyWith(
      selectedParentCategoryId: id,
      selectedParentCategorySlug: slug,
      // reset child when parent changes
      selectedCategoryId: null,
      selectedCategorySlug: '',
      commercialType: '',
    );
  }

  void selectChildCategory({
    required int id,
    required String slug,
    String commercialType = '',
  }) {
    state = state.copyWith(
      selectedCategoryId: id,
      selectedCategorySlug: slug,
      commercialType: commercialType,
    );
  }

  // ── Common Details ─────────────────────────────────────────────────────────

  void setBedrooms(int v) => state = state.copyWith(bedrooms: v);
  void setBathrooms(int v) => state = state.copyWith(bathrooms: v);
  void setBalconies(int v) => state = state.copyWith(balconies: v);
  void setParking(int v) => state = state.copyWith(parking: v);
  void setFurnishing(String v) => state = state.copyWith(furnishing: v);
  void setFacing(String v) => state = state.copyWith(facing: v);
  void setFloor(String v) => state = state.copyWith(floor: v);
  void setTotalFloors(String v) => state = state.copyWith(totalFloors: v);
  void setCarpetArea(String v) => state = state.copyWith(carpetArea: v);
  void setBuiltUpArea(String v) => state = state.copyWith(builtUpArea: v);
  void setSuperBuiltUpArea(String v) =>
      state = state.copyWith(superBuiltUpArea: v);
  void setPlotArea(String v) => state = state.copyWith(plotArea: v);
  void setOpenSides(int v) => state = state.copyWith(openSides: v);
  void setCommercialType(String v) => state = state.copyWith(commercialType: v);

  // ── Pricing ───────────────────────────────────────────────────────────────

  void setMaintenanceCharges(String v) =>
      state = state.copyWith(maintenanceCharges: v);
  void setBookingAmount(String v) => state = state.copyWith(bookingAmount: v);
  void setPriceNegotiable(bool? v) =>
      state = state.copyWith(priceNegotiable: v);
  void setSecurityDeposit(String v) =>
      state = state.copyWith(securityDeposit: v);
  void setVillaMaintenanceCharges(String v) =>
      state = state.copyWith(villaMaintenanceCharges: v);
  void setVillaBookingAmount(String v) =>
      state = state.copyWith(villaBookingAmount: v);
  void setRentMaintenanceCharges(String v) =>
      state = state.copyWith(rentMaintenanceCharges: v);
  void setBrokerage(String v) => state = state.copyWith(brokerage: v);
  void setRentNegotiable(bool? v) => state = state.copyWith(rentNegotiable: v);
  void setPossessionStatus(String v) =>
      state = state.copyWith(possessionStatus: v);
  void setAvailability(String v) => state = state.copyWith(availability: v);
  void setOwnership(String v) => state = state.copyWith(ownership: v);

  // ── Location ──────────────────────────────────────────────────────────────

  void setAddress(String v) => state = state.copyWith(address: v);
  void setCity(String v) => state = state.copyWith(city: v);
  void setState_(String v) => state = state.copyWith(state: v);
  void setPincode(String v) => state = state.copyWith(pincode: v);
  void setCoordinates(double lat, double lng) =>
      state = state.copyWith(latitude: lat, longitude: lng);

  // ── Owner ─────────────────────────────────────────────────────────────────

  void setOwnerName(String v) => state = state.copyWith(ownerName: v);
  void setOwnerPhone(String v) => state = state.copyWith(ownerPhone: v);

  // ── Warehouse ─────────────────────────────────────────────────────────────

  void setWarehouseType(String v) => state = state.copyWith(warehouseType: v);
  void setWarehousePlotArea(String v) =>
      state = state.copyWith(warehousePlotArea: v);
  void setWarehousePlotAreaUnit(String v) =>
      state = state.copyWith(warehousePlotAreaUnit: v);
  void setWarehouseCeilingHeight(String v) =>
      state = state.copyWith(warehouseCeilingHeight: v);
  void setWarehouseLoadingBays(String v) =>
      state = state.copyWith(warehouseLoadingBays: v);
  void setWarehouseDockLevelers(String v) =>
      state = state.copyWith(warehouseDockLevelers: v);
  void setWarehousePowerSupply(String v) =>
      state = state.copyWith(warehousePowerSupply: v);
  void setWarehouseIndustrialLicense(bool? v) =>
      state = state.copyWith(warehouseIndustrialLicense: v);
  void setWarehouseTruckAccess(String v) =>
      state = state.copyWith(warehouseTruckAccess: v);
  void setWarehouseAreaName(String v) =>
      state = state.copyWith(warehouseAreaName: v);
  void setWarehouseCity(String v) => state = state.copyWith(warehouseCity: v);
  void setWarehouseLiftAvailable(bool v) =>
      state = state.copyWith(warehouseLiftAvailable: v);
  void setWarehouseGoodsLift(bool v) =>
      state = state.copyWith(warehouseGoodsLift: v);
  void setWarehousePreLeased(bool v) =>
      state = state.copyWith(warehousePreLeased: v);

  // ── Office ────────────────────────────────────────────────────────────────

  void setOfficeType(String v) => state = state.copyWith(officeType: v);
  void setOfficeArea(String v) => state = state.copyWith(officeArea: v);
  void setCabins(String v) => state = state.copyWith(cabins: v);
  void setMeetingRooms(String v) => state = state.copyWith(meetingRooms: v);
  void setSeats(String v) => state = state.copyWith(seats: v);
  void setMaxSeats(String v) => state = state.copyWith(maxSeats: v);
  void setConferenceRooms(String v) =>
      state = state.copyWith(conferenceRooms: v);
  void setReceptionArea(bool v) => state = state.copyWith(receptionArea: v);
  void setPantry(bool v) => state = state.copyWith(pantry: v);
  void setCafeteria(bool v) => state = state.copyWith(cafeteria: v);
  void setServerRoom(bool v) => state = state.copyWith(serverRoom: v);
  void setFireSafetyInstalled(bool v) =>
      state = state.copyWith(fireSafetyInstalled: v);
  void setCentralAC(bool v) => state = state.copyWith(centralAC: v);
  void setVisitorParking(bool v) => state = state.copyWith(visitorParking: v);
  void setNumberOfLifts(String v) => state = state.copyWith(numberOfLifts: v);
  void setOfficeNegotiable(bool? v) =>
      state = state.copyWith(officeNegotiable: v);
  void setOfficeMaintenanceCharges(String v) =>
      state = state.copyWith(officeMaintenanceCharges: v);
  void setOfficeBookingAmount(String v) =>
      state = state.copyWith(officeBookingAmount: v);

  // ── Shop ─────────────────────────────────────────────────────────────────

  void setShopType(String v) => state = state.copyWith(shopType: v);
  void setShopArea(String v) => state = state.copyWith(shopArea: v);
  void setShopAreaUnit(String v) => state = state.copyWith(shopAreaUnit: v);
  void setFrontageWidth(String v) => state = state.copyWith(frontageWidth: v);
  void setCeilingHeight(String v) => state = state.copyWith(ceilingHeight: v);
  void setMainRoadFacing(bool? v) => state = state.copyWith(mainRoadFacing: v);
  void setCornerShop(bool? v) => state = state.copyWith(cornerShop: v);
  void setWashroomAvailable(bool? v) =>
      state = state.copyWith(washroomAvailable: v);
  void setFloorType(String v) => state = state.copyWith(floorType: v);
  void setMarketName(String v) => state = state.copyWith(marketName: v);
  void setLocality(String v) => state = state.copyWith(locality: v);

  // ── Showroom ──────────────────────────────────────────────────────────────

  void setShowroomArea(String v) => state = state.copyWith(showroomArea: v);
  void setShowroomAreaUnit(String v) =>
      state = state.copyWith(showroomAreaUnit: v);
  void setShowroomFrontageWidth(String v) =>
      state = state.copyWith(showroomFrontageWidth: v);
  void setShowroomCeilingHeight(String v) =>
      state = state.copyWith(showroomCeilingHeight: v);
  void setShowroomMainRoadFacing(bool? v) =>
      state = state.copyWith(showroomMainRoadFacing: v);
  void setShowroomCorner(bool? v) => state = state.copyWith(showroomCorner: v);
  void setShowroomWashroom(bool? v) =>
      state = state.copyWith(showroomWashroom: v);
  void setShowroomParkingSlots(String v) =>
      state = state.copyWith(showroomParkingSlots: v);
  void setShowroomFurnishing(String v) =>
      state = state.copyWith(showroomFurnishing: v);
  void setShowroomFloorType(String v) =>
      state = state.copyWith(showroomFloorType: v);
  void setShowroomMarketName(String v) =>
      state = state.copyWith(showroomMarketName: v);
  void setShowroomLocality(String v) =>
      state = state.copyWith(showroomLocality: v);
  void setShowroomOwnerName(String v) =>
      state = state.copyWith(showroomOwnerName: v);
  void setShowroomOwnerMobile(String v) =>
      state = state.copyWith(showroomOwnerMobile: v);

  // ── Media ─────────────────────────────────────────────────────────────────

  void addImages(List<MediaItem> items) {
    state = state.copyWith(images: [...state.images, ...items]);
  }

  void removeImage(int index) {
    final updated = List<MediaItem>.from(state.images)..removeAt(index);
    state = state.copyWith(images: updated);
  }

  void setPrimaryImageIndex(int i) =>
      state = state.copyWith(primaryImageIndex: i);

  void addVideos(List<MediaItem> items) {
    state = state.copyWith(videos: [...state.videos, ...items]);
  }

  void removeVideo(int index) {
    final updated = List<MediaItem>.from(state.videos)..removeAt(index);
    state = state.copyWith(videos: updated);
  }

  // ── Amenities & Furnishings ───────────────────────────────────────────────

  void toggleAmenity(int id) {
    final updated = Set<int>.from(state.selectedAmenityIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    state = state.copyWith(selectedAmenityIds: updated);
  }

  void toggleFurnishing(int id) {
    final updated = Set<int>.from(state.selectedFurnishingIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    state = state.copyWith(selectedFurnishingIds: updated);
  }

  void setFurnishingQuantity(int id, int qty) {
    final updated = Map<int, int>.from(state.furnishingQuantities);
    updated[id] = qty;
    state = state.copyWith(furnishingQuantities: updated);
  }

  // ── Section UI ────────────────────────────────────────────────────────────

  void toggleSection(String key) {
    final updated = Map<String, bool>.from(state.expandedSections);
    updated[key] = !(updated[key] ?? false);
    state = state.copyWith(expandedSections: updated);
  }

  void expandNextSection(String currentKey) {
    const order = [
      'basic',
      'details',
      'pricing',
      'amenities',
      'furnishings',
      'media',
      'location',
      'description',
    ];
    final idx = order.indexOf(currentKey);
    if (idx == -1 || idx >= order.length - 1) return;
    final updated = Map<String, bool>.from(state.expandedSections);
    updated[currentKey] = false;
    updated[order[idx + 1]] = true;
    state = state.copyWith(expandedSections: updated);
  }

  // ── Submit / Loading ──────────────────────────────────────────────────────

  void setValidationErrors(Map<String, String?> errors) =>
      state = state.copyWith(validationErrors: errors);

  void setError(String field, String? error) {
    final updated = Map<String, String?>.from(state.validationErrors);
    updated[field] = error;
    state = state.copyWith(validationErrors: updated);
  }

  void clearError(String field) {
    final updated = Map<String, String?>.from(state.validationErrors);
    updated.remove(field);
    state = state.copyWith(validationErrors: updated);
  }

  // ── Prefill from existing Property (edit flow) ────────────────────────────

  void prefillFromProperty(Property p) {
    state = PropertyPrefillMapper.fromProperty(
      p,
    ).copyWith(selectedAmenityIds: Set<int>.from(p.amenityIds ?? []));
  }
}
