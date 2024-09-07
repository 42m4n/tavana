#!/bin/bash

sleep 10
/usr/bin/mc alias set $MINIO_ALIAS $MINIO_URL $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD

# Create buckets and set policies
for bucket in $(echo $BUCKETS | tr -d "[]'," ); do
  if ! /usr/bin/mc ls $MINIO_ALIAS/$bucket; then
    /usr/bin/mc mb $MINIO_ALIAS/$bucket
    /usr/bin/mc policy set public $MINIO_ALIAS/$bucket
  fi
done

for user_pass in $(echo $MINIO_USERS | tr -d "[]'," ); do
  # Separate users and related passwords
  IFS=":" read -r user password <<< "$user_pass"
  # Create and attach policies
  if ! /usr/bin/mc admin policy info $MINIO_ALIAS "$user-policy"; then
    /usr/bin/mc admin policy create $MINIO_ALIAS "$user-policy" /policies/$user-policy.json
  fi
  # Add users and attach policies
  if ! /usr/bin/mc admin user info $MINIO_ALIAS $user; then
    /usr/bin/mc admin user add $MINIO_ALIAS $user $password
    /usr/bin/mc admin policy attach $MINIO_ALIAS $user-policy --user $user
  fi
done

exit 0
