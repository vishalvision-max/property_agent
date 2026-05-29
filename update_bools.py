import re

variables = [
    "pgElectricityIncluded",
    "pgWaterIncluded",
    "pgFoodChargesIncluded",
    "pgBrokerageRequired",
    "pgCoupleFriendly",
    "pgIdProofRequired",
    "pgCupboardAvailable",
    "pgStudyTableAvailable",
    "pgAttachedBathroom",
    "pgBalcony",
    "petFriendly",
    "wheelchairFriendly",
    "agriFencing",
    "receptionArea",
    "pantry",
    "cafeteria",
    "serverRoom",
    "fireSafetyInstalled",
    "centralAC",
    "visitorParking",
    "taxIncluded",
    "liftAvailable",
    "preLeased",
]

# 1. Update property_create_screen.dart
screen_path = "lib/presentation/screens/property/property_create_screen.dart"
with open(screen_path, "r") as f:
    screen_code = f.read()

for var in variables:
    # Declarations (e.g. bool _pgElectricityIncluded = false;)
    screen_code = re.sub(
        rf"bool (_{var})\s*=\s*(true|false);",
        rf"bool? \1;",
        screen_code
    )
    
    # Pre-fill logic using _fb() || _fb() -> _fbNullable() ?? _fbNullable()
    # Actually, some are `_fb(f, [...]) || _fb(...)` and some are `_fb(f, [...], fallback: _fb(...))`
    # Let's just find `_var = ... _fb` and carefully replace if needed.
    # It's easier to just regex _fb to _fbNullable for the assignments.
    
    # Let's handle the specific assignments.
    # Example: _pgElectricityIncluded = _fb(f, ['pg_electricity_included']) || _fb(pg, ['electricity_included']);
    # regex: _var = _fb(...) || _fb(...)
    screen_code = re.sub(
        rf"(_{var})\s*=\s*_fb\((.*?)\)\s*\|\|\s*_fb\((.*?)\);",
        rf"\1 = _fbNullable(\2) ?? _fbNullable(\3);",
        screen_code,
        flags=re.DOTALL
    )
    
    # Example: _pantry = _fb(f, ['pantry'], fallback: _fb(office, ['pantry']));
    screen_code = re.sub(
        rf"(_{var})\s*=\s*_fb\(([^,]+),\s*(\[[^\]]+\]),?\s*fallback:\s*_fb\(([^,]+),\s*(\[[^\]]+\])\)\s*\);",
        rf"\1 = _fbNullable(\2, \3) ?? _fbNullable(\4, \5);",
        screen_code,
        flags=re.DOTALL
    )
    
    # Handle decoded['var'] as bool? ?? _var
    # We don't need to change this because if _var is bool?, it still compiles perfectly!
    
with open(screen_path, "w") as f:
    f.write(screen_code)

# 2. Update property_create_screen_details.dart
details_path = "lib/presentation/screens/property/property_create_screen_details.dart"
with open(details_path, "r") as f:
    details_code = f.read()

# For agriFencing which uses _buildChoiceChipRow
details_code = re.sub(
    r"_agriFencing \? 'yes' : 'no',",
    r"_agriFencing == null ? null : (_agriFencing! ? 'yes' : 'no'),",
    details_code
)

with open(details_path, "w") as f:
    f.write(details_code)

# 3. Update property_create_screen_extras.dart (_simpleFilterChip definition)
extras_path = "lib/presentation/screens/property/property_create_screen_extras.dart"
with open(extras_path, "r") as f:
    extras_code = f.read()

extras_code = extras_code.replace(
    "required bool selected,",
    "required bool? selected,"
)
extras_code = extras_code.replace(
    "selected: selected,",
    "selected: selected ?? false,"
)
extras_code = extras_code.replace(
    "color: selected ?",
    "color: (selected ?? false) ?"
)

with open(extras_path, "w") as f:
    f.write(extras_code)

print("Done")
