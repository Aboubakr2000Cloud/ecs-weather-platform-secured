#!/bin/bash
set -euo pipefail

echo "=== IAM Credential Report ==="
aws iam generate-credential-report >/dev/null
sleep 5
aws iam get-credential-report \
  --query 'Content' --output text | base64 --decode

echo ""
echo "=== Security Groups with 0.0.0.0/0 ==="
aws ec2 describe-security-groups \
  --filters Name=ip-permission.cidr,Values='0.0.0.0/0' \
  --query 'SecurityGroups[*].[GroupId,GroupName,Description]' \
  --output table

echo ""
echo "=== S3 Buckets Public Access Status ==="
for bucket in $(aws s3api list-buckets --query 'Buckets[*].Name' --output text); do
    STATUS=$(aws s3api get-public-access-block --bucket "$bucket" \
      --query 'PublicAccessBlockConfiguration.BlockPublicAcls' \
      --output text 2>/dev/null || echo "NOT_SET")
    echo "$bucket: $STATUS"
done

echo ""
echo "=== RDS Encryption Status ==="
aws rds describe-db-instances \
  --query 'DBInstances[*].[DBInstanceIdentifier,StorageEncrypted,PubliclyAccessible]' \
  --output table

echo ""
echo "=== CloudTrail Status ==="
aws cloudtrail describe-trails \
  --query 'trailList[*].[Name,IsMultiRegionTrail,LogFileValidationEnabled]' \
  --output table
