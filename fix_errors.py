import re

screen_path = "lib/presentation/screens/property/property_create_screen.dart"
with open(screen_path, "r") as f:
    screen_code = f.read()

# Fix occurrences of `_fbNullable(..., fallback: ...)` across lines
# _pantry = _fbNullable(f, ['pantry'], fallback: _fb(office, ['pantry']));
screen_code = re.sub(
    r"_fbNullable\(([^,]+),\s*(\[[^\]]+\]),\s*fallback:\s*_fb\(([^,]+),\s*(\[[^\]]+\])\)\)",
    r"(_fbNullable(\1, \2) ?? _fbNullable(\3, \4))",
    screen_code
)

# Fix occurrences with line breaks
# _serverRoom = _fbNullable(f, [\n      'server_room',\n    ], fallback: _fb(office, ['server_room']));
screen_code = re.sub(
    r"_fbNullable\(([^,]+),\s*(\[[^\]]+\]),?\s*fallback:\s*_fb\(([^,]+),\s*(\[[^\]]+\])\)\)",
    r"(_fbNullable(\1, \2) ?? _fbNullable(\3, \4))",
    screen_code,
    flags=re.DOTALL
)

# And fix `fallback: _fbNullable` if I accidentally replaced `_fb` with `_fbNullable` inside fallback
screen_code = re.sub(
    r"_fbNullable\(([^,]+),\s*(\[[^\]]+\]),?\s*fallback:\s*_fbNullable\(([^,]+),\s*(\[[^\]]+\])\)\)",
    r"(_fbNullable(\1, \2) ?? _fbNullable(\3, \4))",
    screen_code,
    flags=re.DOTALL
)

# And `_fb(..., fallback: _fb(...))` where the first wasn't replaced
screen_code = re.sub(
    r"_fb\(([^,]+),\s*(\[[^\]]+\]),?\s*fallback:\s*_fb\(([^,]+),\s*(\[[^\]]+\])\)\)",
    r"(_fbNullable(\1, \2) ?? _fbNullable(\3, \4))",
    screen_code,
    flags=re.DOTALL
)

with open(screen_path, "w") as f:
    f.write(screen_code)

# 2. property_create_screen_details.dart
details_path = "lib/presentation/screens/property/property_create_screen_details.dart"
with open(details_path, "r") as f:
    details_code = f.read()

for var in [
    "petFriendly", "wheelchairFriendly", "liftAvailable", "receptionArea", 
    "pantry", "cafeteria", "serverRoom", "fireSafetyInstalled", "centralAC", 
    "visitorParking", "taxIncluded", "preLeased"
]:
    details_code = re.sub(
        rf"(_{var})\s*\?\s*'yes'\s*:\s*'no',",
        rf"\1 == null ? null : (\1! ? 'yes' : 'no'),",
        details_code
    )
    details_code = re.sub(
        rf"(_{var})\s*\?\s*'available'\s*:\s*'not_available',",
        rf"\1 == null ? null : (\1! ? 'available' : 'not_available'),",
        details_code
    )

with open(details_path, "w") as f:
    f.write(details_code)

# 3. property_create_screen_payload.dart
payload_path = "lib/presentation/screens/property/property_create_screen_payload.dart"
with open(payload_path, "r") as f:
    payload_code = f.read()

# Replace (_pgAttachedBathroom ? 1 : 0) -> (_pgAttachedBathroom == true ? 1 : 0)
payload_code = payload_code.replace("(_pgAttachedBathroom ? 1 : 0)", "(_pgAttachedBathroom == true ? 1 : 0)")
payload_code = payload_code.replace("(_pgBalcony ? 1 : 0)", "(_pgBalcony == true ? 1 : 0)")
payload_code = payload_code.replace("(_pgCupboardAvailable ? 1 : 0)", "(_pgCupboardAvailable == true ? 1 : 0)")
payload_code = payload_code.replace("(_pgStudyTableAvailable ? 1 : 0)", "(_pgStudyTableAvailable == true ? 1 : 0)")

with open(payload_path, "w") as f:
    f.write(payload_code)

