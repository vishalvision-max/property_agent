#!/bin/bash

echo "Testing 1. Sale - Commercial - Shop"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="sale"' \
--form 'category_id="12"' \
--form 'property_kind="commercial"' \
--form 'commercial_type="shop"' \
--form 'listing_type="owner"' \
--form 'shop_type="retail"' \
--form 'shop_area="300"' \
--form 'shop_area_unit="sqft"' \
--form 'frontage_width="300"' \
--form 'celling_height="300"' \
--form 'main_road_facing="1"' \
--form 'corner_shop="1"' \
--form 'washroom_avialable="1"' \
--form 'floor_type="ground_floor"' \
--form 'market_name="test"' \
--form 'locality="test"' \
--form 'corner_property="1"' \
--form 'price="300"' \
--form 'maintenance_charges="1000"' \
--form 'booking_amount="600"' \
--form 'price_negotiable="1"' \
--form 'area="200"' \
--form 'area_unit="sqft"' \
--form 'amenities[]="1"' \
--form 'amenities[]="2"' \
--form 'furnishings[0][id]="6"' \
--form 'furnishings[1][id]="7"' \
--form 'furnishings[0][quantity]="3"' \
--form 'furnishings[1][quantity]="2"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 2. Sale - Commercial - Shoroom"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="sale"' \
--form 'category_id="13"' \
--form 'property_kind="commercial"' \
--form 'commercial_type="shop"' \
--form 'listing_type="owner"' \
--form 'shop_area="500"' \
--form 'shop_area_unit="sqft"' \
--form 'frontage_width="300"' \
--form 'celling_height="300"' \
--form 'main_road_facing="1"' \
--form 'corner_shop="1"' \
--form 'washroom_avialable="1"' \
--form 'parking_slots="6"' \
--form 'furnishing_status="furnished"' \
--form 'floor_type="ground_floor"' \
--form 'market_name="test"' \
--form 'locality="test"' \
--form 'owner_name="test "' \
--form 'owner_mobile="859674125"' \
--form 'corner_property="1"' \
--form 'price="300"' \
--form 'maintenance_charges="1000"' \
--form 'booking_amount="600"' \
--form 'price_negotiable="1"' \
--form 'showroom_area="200"' \
--form 'showroom_area_unit="sqft"' \
--form 'amenities[]="1"' \
--form 'amenities[]="2"' \
--form 'furnishings[0][id]="6"' \
--form 'furnishings[1][id]="7"' \
--form 'furnishings[0][quantity]="3"' \
--form 'furnishings[1][quantity]="2"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 3. Sale - Commercial - Warehouse"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="sale"' \
--form 'category_id="14"' \
--form 'property_kind="commercial"' \
--form 'commercial_type="warehouse"' \
--form 'listing_type="owner"' \
--form 'warehouse_type="warehouse"' \
--form 'warehouse_plot_area="300"' \
--form 'warehouse_plot_area_unit="sqft"' \
--form 'celling_height="300"' \
--form 'warehouse_ceiling_height_ft="600"' \
--form 'loading_bays="20"' \
--form 'dock_levelers="20"' \
--form 'power_supply="20"' \
--form 'industrial_license="1"' \
--form 'truck_access="heavy"' \
--form 'industrial_area_name="test"' \
--form 'industrial_area_city="city "' \
--form 'corner_property="1"' \
--form 'price="300"' \
--form 'maintenance_charges="1000"' \
--form 'booking_amount="600"' \
--form 'price_negotiable="1"' \
--form 'showroom_area="200"' \
--form 'showroom_area_unit="sqft"' \
--form 'amenities[]="1"' \
--form 'amenities[]="2"' \
--form 'furnishings[0][id]="6"' \
--form 'furnishings[1][id]="7"' \
--form 'furnishings[0][quantity]="3"' \
--form 'furnishings[1][quantity]="2"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 4. Sale - Land Plot - Residential-plot"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="sale"' \
--form 'category_id="21"' \
--form 'property_kind="plot"' \
--form 'listing_type="owner"' \
--form 'plot_area="1200"' \
--form 'plot_area_unit="sqft"' \
--form 'plot_length_ft="60"' \
--form 'plot_breadth_ft="20"' \
--form 'floors_allowed="4"' \
--form 'boundary_wall="1"' \
--form 'land_type="residential"' \
--form 'road_width_ft="30"' \
--form 'corner_property="1"' \
--form 'price="300"' \
--form 'maintenance_charges="1000"' \
--form 'booking_amount="600"' \
--form 'price_negotiable="1"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 5. Sale - Land Plot - Commercial-plot"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="sale"' \
--form 'category_id="22"' \
--form 'property_kind="plot"' \
--form 'listing_type="owner"' \
--form 'plot_area="1200"' \
--form 'plot_area_unit="sqft"' \
--form 'plot_length_ft="60"' \
--form 'plot_breadth_ft="20"' \
--form 'floors_allowed="4"' \
--form 'boundary_wall="1"' \
--form 'corner_plot="1"' \
--form 'land_type="residential"' \
--form 'road_width_ft="30"' \
--form 'possession_by="2026-12-31"' \
--form 'availability="ready_to_move"' \
--form 'corner_property="1"' \
--form 'construction_done="1"' \
--form 'road_access="1"' \
--form 'ownership="freehold"' \
--form 'open_slides="50"' \
--form 'corner_plot="1"' \
--form 'price="300"' \
--form 'maintenance_charges="1000"' \
--form 'booking_amount="600"' \
--form 'price_negotiable="1"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 6. Sale - Land Plot - Agricultural-plot"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="sale"' \
--form 'category_id="23"' \
--form 'property_kind="plot"' \
--form 'listing_type="owner"' \
--form 'plot_area="1200"' \
--form 'plot_area_unit="sqft"' \
--form 'plot_length_ft="60"' \
--form 'plot_breadth_ft="20"' \
--form 'floors_allowed="4"' \
--form 'boundary_wall="1"' \
--form 'corner_plot="1"' \
--form 'open_slides="50"' \
--form 'construction_done="1"' \
--form 'road_width_ft="30"' \
--form 'agri_water_source="municipal"' \
--form 'agri_fencing="1"' \
--form 'ownership="freehold"' \
--form 'corner_property="1"' \
--form 'possession_by="2026-12-31"' \
--form 'corner_property="1"' \
--form 'availability="ready_to_move"' \
--form 'price="300"' \
--form 'maintenance_charges="1000"' \
--form 'booking_amount="600"' \
--form 'price_negotiable="1"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 7. Rent - Residential - Flat Apartment"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="rent"' \
--form 'category_id="2"' \
--form 'property_kind="residential"' \
--form 'listing_type="owner"' \
--form 'bhk="4"' \
--form 'bathrooms="2"' \
--form 'balconies="2"' \
--form 'parking="5"' \
--form 'total_floors="6"' \
--form 'floor="2"' \
--form 'furnishing="furnished"' \
--form 'facing="north"' \
--form 'carpet_area="500"' \
--form 'built_up_area="300"' \
--form 'super_built_up_area="1200"' \
--form 'availability="ready_to_move"' \
--form 'possession_by="2026-12-31"' \
--form 'ownership="freehold"' \
--form 'additional_rooms="servant_room"' \
--form 'corner_property="1"' \
--form 'gated_society="1"' \
--form 'available_from="2026-12-31"' \
--form 'lease_duration="22"' \
--form 'lock_in_period="10"' \
--form 'notice_period_days="10"' \
--form 'preferred_tenant="family"' \
--form 'food_preference="veg"' \
--form 'promotion_type="urgent"' \
--form 'price="300"' \
--form 'maintenance_charges="1000"' \
--form 'booking_amount="600"' \
--form 'price_negotiable="1"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 8. Rent - Residential - Builder Floor"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="rent"' \
--form 'category_id="3"' \
--form 'property_kind="residential"' \
--form 'listing_type="owner"' \
--form 'bhk="4"' \
--form 'bathrooms="2"' \
--form 'balconies="2"' \
--form 'parking="5"' \
--form 'total_floors="6"' \
--form 'floor="2"' \
--form 'furnishing="furnished"' \
--form 'facing="north"' \
--form 'carpet_area="500"' \
--form 'built_up_area="300"' \
--form 'super_built_up_area="1200"' \
--form 'availability="ready_to_move"' \
--form 'possession_by="2026-12-31"' \
--form 'ownership="freehold"' \
--form 'lift="1"' \
--form 'gated_society="1"' \
--form 'society_name="test "' \
--form 'preferred_tenant="family"' \
--form 'corner_property="1"' \
--form 'price="300"' \
--form 'maintenance_charges="1000"' \
--form 'booking_amount="600"' \
--form 'price_negotiable="1"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 9. Rent - Residential - Independent house"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="rent"' \
--form 'category_id="3"' \
--form 'property_kind="residential"' \
--form 'listing_type="owner"' \
--form 'bhk="4"' \
--form 'bathrooms="2"' \
--form 'balconies="2"' \
--form 'parking="5"' \
--form 'total_floors="6"' \
--form 'floor="2"' \
--form 'furnishing="furnished"' \
--form 'facing="north"' \
--form 'carpet_area="500"' \
--form 'built_up_area="300"' \
--form 'super_built_up_area="1200"' \
--form 'availability="ready_to_move"' \
--form 'possession_by="2026-12-31"' \
--form 'ownership="freehold"' \
--form 'plot_area="100"' \
--form 'parking_spots="20"' \
--form 'outdoors[]="terrace"' \
--form 'water_source="tanker"' \
--form 'solar_power="1"' \
--form 'independent_entry="1"' \
--form 'corner_property="1"' \
--form 'price="300"' \
--form 'maintenance_charges="1000"' \
--form 'booking_amount="600"' \
--form 'price_negotiable="1"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 10. Rent - Residential - Villa"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="rent"' \
--form 'category_id="6"' \
--form 'property_kind="residential"' \
--form 'listing_type="owner"' \
--form 'parking="5"' \
--form 'total_floors="6"' \
--form 'floor="2"' \
--form 'furnishing="furnished"' \
--form 'facing="north"' \
--form 'carpet_area="500"' \
--form 'built_up_area="300"' \
--form 'super_built_up_area="1200"' \
--form 'availability="ready_to_move"' \
--form 'possession_by="2026-12-31"' \
--form 'ownership="freehold"' \
--form 'room_type="1rk"' \
--form 'kitchen_type="open"' \
--form 'tenant_preference="student"' \
--form 'corner_property="1"' \
--form 'price="300"' \
--form 'maintenance_charges="1000"' \
--form 'booking_amount="600"' \
--form 'price_negotiable="1"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 11. Rent - Residential - Studio Apartment"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="rent"' \
--form 'category_id="6"' \
--form 'property_kind="residential"' \
--form 'listing_type="owner"' \
--form 'bhk="4"' \
--form 'bathrooms="2"' \
--form 'balconies="2"' \
--form 'parking="5"' \
--form 'total_floors="6"' \
--form 'floor="2"' \
--form 'furnishing="furnished"' \
--form 'facing="north"' \
--form 'carpet_area="500"' \
--form 'built_up_area="300"' \
--form 'super_built_up_area="1200"' \
--form 'availability="ready_to_move"' \
--form 'possession_by="2026-12-31"' \
--form 'ownership="freehold"' \
--form 'corner_property="1"' \
--form 'price="300"' \
--form 'maintenance_charges="1000"' \
--form 'booking_amount="600"' \
--form 'price_negotiable="1"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 12. Rent - Residential - Duplex"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="rent"' \
--form 'category_id="24"' \
--form 'property_kind="residential"' \
--form 'listing_type="owner"' \
--form 'construction_allowed="1"' \
--form 'water_connection="1"' \
--form 'electricity_connection="1"' \
--form 'road_access="1"' \
--form 'nearby_facilities[]="metro"' \
--form 'corner_property="1"' \
--form 'price="300"' \
--form 'maintenance_charges="1000"' \
--form 'booking_amount="600"' \
--form 'price_negotiable="1"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 13. Rent - Residential - Independent Floor"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="rent"' \
--form 'category_id="25"' \
--form 'property_kind="residential"' \
--form 'listing_type="owner"' \
--form 'bhk="4"' \
--form 'bathrooms="2"' \
--form 'balconies="2"' \
--form 'parking="5"' \
--form 'total_floors="6"' \
--form 'floor="2"' \
--form 'furnishing="furnished"' \
--form 'facing="north"' \
--form 'carpet_area="500"' \
--form 'built_up_area="300"' \
--form 'super_built_up_area="1200"' \
--form 'availability="ready_to_move"' \
--form 'possession_by="2026-12-31"' \
--form 'ownership="freehold"' \
--form 'corner_property="1"' \
--form 'gated_society="1"' \
--form 'plot_area="100"' \
--form 'width="10"' \
--form 'height="20"' \
--form 'open_slides="20"' \
--form 'boundary_wall="1"' \
--form 'construction_allowed="1"' \
--form 'utilities[]="water"' \
--form 'price_per_sqft="100"' \
--form 'price="300"' \
--form 'maintenance_charges="1000"' \
--form 'booking_amount="600"' \
--form 'price_negotiable="1"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 14. Rent - Residential - Farmhouse"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="rent"' \
--form 'category_id="26"' \
--form 'property_kind="residential"' \
--form 'listing_type="owner"' \
--form 'land_area="100"' \
--form 'built_up_area="300"' \
--form 'utilities[]="water"' \
--form 'no_of_rooms="10"' \
--form 'no_of_washrooms="10"' \
--form 'total_floors="6"' \
--form 'floor="2"' \
--form 'balconies="2"' \
--form 'garden="1"' \
--form 'swiming_pool="1"' \
--form 'corner_property="1"' \
--form 'price="300"' \
--form 'maintenance_charges="1000"' \
--form 'booking_amount="600"' \
--form 'price_negotiable="1"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 15. Rent - Commercial - Office Space"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="rent"' \
--form 'category_id="11"' \
--form 'property_kind="commercial"' \
--form 'commercial_type="office"' \
--form 'listing_type="owner"' \
--form 'office_type="bare_shell"' \
--form 'office_area="200"' \
--form 'cabins="5"' \
--form 'meeting_rooms="3"' \
--form 'seats="2"' \
--form 'max_seats="6"' \
--form 'conference_seats="2"' \
--form 'corner_property="1"' \
--form 'price="300"' \
--form 'maintenance_charges="1000"' \
--form 'booking_amount="600"' \
--form 'price_negotiable="1"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 16. Rent - Commercial - Shop"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="rent"' \
--form 'category_id="12"' \
--form 'property_kind="commercial"' \
--form 'commercial_type="office"' \
--form 'listing_type="owner"' \
--form 'shop_type="retail"' \
--form 'shop_area="200"' \
--form 'shop_area_unit="sqft"' \
--form 'frontage_width="10"' \
--form 'ceiling_height="320"' \
--form 'main_road_facing="1"' \
--form 'corner_shop="1"' \
--form 'washroom_available="1"' \
--form 'floor_type="ground"' \
--form 'market_name="test"' \
--form 'locality="test"' \
--form 'corner_property="1"' \
--form 'price="300"' \
--form 'maintenance_charges="1000"' \
--form 'booking_amount="600"' \
--form 'price_negotiable="1"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 17. Rent - Commercial - Showroom"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="rent"' \
--form 'category_id="13"' \
--form 'property_kind="commercial"' \
--form 'commercial_type="office"' \
--form 'listing_type="owner"' \
--form 'showroom_area="200"' \
--form 'showroom_area_unit="sqft"' \
--form 'frontage_width="10"' \
--form 'ceiling_height="200"' \
--form 'main_road_facing="1"' \
--form 'corner_showroom="1"' \
--form 'washroom_available="1"' \
--form 'parking_slots="10"' \
--form 'furnishing="furnished"' \
--form 'floor_type="ground"' \
--form 'market_name="test"' \
--form 'locality="test"' \
--form 'owner_name="test"' \
--form 'owner_mobile="100"' \
--form 'corner_property="1"' \
--form 'price="3000"' \
--form 'monthly_rent="300"' \
--form 'built_up_area="1000"' \
--form 'built_up_area_unit="sqft"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 18. Rent - Commercial - Warehouse"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="rent"' \
--form 'category_id="14"' \
--form 'property_kind="commercial"' \
--form 'commercial_type="office"' \
--form 'listing_type="owner"' \
--form 'warehouse_type="warehouse"' \
--form 'warehouse_plot_area="300"' \
--form 'warehouse_plot_area_unit="sqft"' \
--form 'celling_height="300"' \
--form 'warehouse_ceiling_height_ft="600"' \
--form 'loading_bays="20"' \
--form 'dock_levelers="20"' \
--form 'power_supply="20"' \
--form 'industrial_license="1"' \
--form 'truck_access="heavy"' \
--form 'industrial_area_name="test"' \
--form 'industrial_area_city="city"' \
--form 'corner_property="1"' \
--form 'price="3000"' \
--form 'monthly_rent="300"' \
--form 'built_up_area="1000"' \
--form 'built_up_area_unit="sqft"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 19. Rent - Land Plot - Residential"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="rent"' \
--form 'category_id="21"' \
--form 'property_kind="plot"' \
--form 'listing_type="owner"' \
--form 'plot_area="1200"' \
--form 'plot_area_unit="sqft"' \
--form 'plot_length_ft="60"' \
--form 'plot_breadth_ft="20"' \
--form 'floors_allowed="4"' \
--form 'boundary_wall="1"' \
--form 'corner_plot="1"' \
--form 'open_slides="50"' \
--form 'construction_done="1"' \
--form 'road_width_ft="30"' \
--form 'road_access="1"' \
--form 'ownership="freehold"' \
--form 'corner_property="1"' \
--form 'possession_by="2026-12-31"' \
--form 'price="3000"' \
--form 'monthly_rent="300"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 20. Rent - Land Plot - Commercial Plot"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="rent"' \
--form 'category_id="22"' \
--form 'property_kind="plot"' \
--form 'listing_type="owner"' \
--form 'plot_area="1200"' \
--form 'plot_area_unit="sqft"' \
--form 'plot_length_ft="60"' \
--form 'plot_breadth_ft="20"' \
--form 'floors_allowed="4"' \
--form 'boundary_wall="1"' \
--form 'corner_plot="1"' \
--form 'open_slides="50"' \
--form 'construction_done="1"' \
--form 'road_width_ft="30"' \
--form 'road_access="1"' \
--form 'ownership="freehold"' \
--form 'availability="ready_to_move"' \
--form 'corner_property="1"' \
--form 'possession_by="2026-12-31"' \
--form 'price="3000"' \
--form 'monthly_rent="300"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 21. Rent - Land Plot - Agricultural Plot"
curl --location 'https://propertysearch.visionvivante.in/api/v1/staff/properties' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json' \
--form 'type="rent"' \
--form 'category_id="23"' \
--form 'property_kind="plot"' \
--form 'listing_type="owner"' \
--form 'plot_area="1200"' \
--form 'plot_area_unit="sqft"' \
--form 'plot_length_ft="60"' \
--form 'plot_breadth_ft="20"' \
--form 'floors_allowed="4"' \
--form 'boundary_wall="1"' \
--form 'corner_plot="1"' \
--form 'open_slides="50"' \
--form 'construction_done="1"' \
--form 'road_width_ft="30"' \
--form 'agri_water_source="municipal"' \
--form 'agri_fencing="1"' \
--form 'ownership="freehold"' \
--form 'corner_property="1"' \
--form 'possession_by="2026-12-31"' \
--form 'corner_property="1"' \
--form 'availability="ready_to_move"' \
--form 'price="3000"' \
--form 'monthly_rent="300"' \
--form 'address="Sco 21, Sector 5, MDC"' \
--form 'state="Panchkula"' \
--form 'city="Panchkula"' \
--form 'pincode="1354114"' \
--form 'owner_name="Test "' \
--form 'owner_phone="9874563214"' \
--form 'title="Sale Property"' \
--form 'description="This is Sale Property Description"'
echo -e "\n\n"

echo "Testing 22. Get 2BHK Flats"
curl --location --request GET 'https://propertysearch.visionvivante.in/api/v1/owner/twobhk/property' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json'
echo -e "\n\n"

echo "Testing 23. Get Flats Under 50 Lakhs"
curl --location --request GET 'https://propertysearch.visionvivante.in/api/v1/owner/flats/under/fiftylakh' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json'
echo -e "\n\n"

echo "Testing 24. Get Ready To Move Properties"
curl --location --request GET 'https://propertysearch.visionvivante.in/api/v1/owner/availability/readytomove' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json'
echo -e "\n\n"

echo "Testing 25. Get Furnished Properties"
curl --location --request GET 'https://propertysearch.visionvivante.in/api/v1/owner/furnishing/furnished' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json'
echo -e "\n\n"

echo "Testing 26. Get Gated Society Properties"
curl --location --request GET 'https://propertysearch.visionvivante.in/api/v1/owner/gated/society' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json'
echo -e "\n\n"

echo "Testing 27. Get Studio Apartment Properties"
curl --location --request GET 'https://propertysearch.visionvivante.in/api/v1/owner/studio/apartment' \
--header 'Authorization: Bearer 117|KSTcawQULB00neG2PEDjE55DFP094gvpaLtAZAAI39d489c8' \
--header 'Accept: application/json'
echo -e "\n\n"
