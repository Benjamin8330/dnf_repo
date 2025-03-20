#!/bin/bash

# Path to the directory containing your RPMs
repo_dir="/444/2/AppStream"

# Output directory for .modulemd files
modulemd_dir="/444/2/modules"

# Ensure the modules directory exists
mkdir -p "$modulemd_dir"

# Loop through each module RPM (assuming they are in the correct directory)
for rpm in $(find "$repo_dir" -type f -name "*.rpm"); do
  # Extract the module name and version from the RPM filename (you can adjust this for your naming convention)
  module_name=$(rpm -qp --qf '%{NAME}\n' "$rpm" | cut -d'-' -f1)
  stream=$(rpm -qp --qf '%{VERSION}\n' "$rpm")
  version=$(rpm -qp --qf '%{RELEASE}\n' "$rpm")

  # Generate a basic .modulemd file
  cat > "$modulemd_dir/$module_name-$stream-$version.modulemd" <<EOF
document: modulemd
version: 2
data:
  name: $module_name
  stream: $stream
  version: 1
  context: $(openssl rand -hex 8)
  arch: aarch64
  summary: Auto-generated module for $module_name
  description: This is an auto-generated module for $module_name version $version.
  licenses:
    - MIT
  dependencies: []
  profiles:
    default:
      rpms:
        - $(basename "$rpm")
  components:
    rpms:
      $module_name:
        rationale: "Auto-generated RPM for $module_name"
        ref: "$(basename "$rpm")"
EOF

done

echo "Modulemd files generated in $modulemd_dir"