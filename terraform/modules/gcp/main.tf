# OpenFiat node infrastructure — gcp
#
# This module currently defines variables and outputs only; resource blocks
# will be added once the target account/project structure is finalized. See
# ../../README.md for the multi-cloud module layout.

# Example (commented out until account details are supplied):
#
# resource "gcp_instance" "node" {
#   count = var.node_count
#   ...
# }
