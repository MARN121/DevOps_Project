#!/bin/bash

# Define your RDS instance identifier
RDS_INSTANCE="masadrn-devops-project-postgres"

# Generate timestamp
TIMESTAMP=$(date +%Y%m%d%H%M)

# Define snapshot name
SNAPSHOT_ID="${RDS_INSTANCE}-snapshot-${TIMESTAMP}"

echo "Creating RDS snapshot: $SNAPSHOT_ID"

# Create the snapshot
aws rds create-db-snapshot \
  --db-instance-identifier $RDS_INSTANCE \
  --db-snapshot-identifier $SNAPSHOT_ID

# Optional: Wait for snapshot to complete
echo "Waiting for snapshot to become available..."
aws rds wait db-snapshot-available \
  --db-snapshot-identifier $SNAPSHOT_ID

echo "Snapshot $SNAPSHOT_ID is available."

# Run Terraform destroy
echo "Destroying infrastructure using Terraform..."
terraform destroy -auto-approve
