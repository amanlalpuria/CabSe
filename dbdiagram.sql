Table person {
  id character(36) [pk]
  uuid UUID
  role_id character(36)
  first_name varchar(255)
  last_name varchar(255)
  email_encrypted varchar(255)
  email_hash bytea
  email_verified BOOLEAN
  mobile_number_encrypted varchar(255)
  mobile_number_hash bytea
  mobile_country_code varchar(255)
  mobile_verified BOOLEAN
  gender varchar(255)
  date_of_birth timestamp
  profile_picture text

  password_hash bytea

  last_login_at timestamptz

  provider VARCHAR(50) //GOOGLE APPLE FACEBOKK
  social_id VARCHAR(255)  // GOOGLE APPLE ID..

  receive_notification boolean //Flag to receive notification
  notification_token VARCHAR(255) //firebase FCM token

  failed_login_attempts INTEGER //lock account after specified login attempt
  failed_otp_attempts INTEGER //lock account after specified otp attempt

  password_changed_at TIMESTAMP //should be pass in jwt so that after password change time the token should not be valid

  is_deleted BOOLEAN //if person mark account deleted we just need to mark this flag instead of deleting complete user details

  customer_referral_code text
  referral_code character
  referred_at timestamp
  referred_by_customer text

  // feature for ladies safety
  share_emergency_contacts boolean
  share_trip_with_emergency_contact_option text

  // local language feature
  language character

  cabse_ratings integer

  created_at timestamptz
  updated_at timestamptz
}

Table person_device_used{
  id character(36) [pk]
  person_id character(36)
  // to store app information, it can help us track build issues on specific versions
  client_bundle_version text
  client_config_version text
  client_os_type text
  client_os_version text
  client_sdk_version text
  client_react_native_version text
  imei_number_hash bytea
  imei_number_encrypted character

  created_at timestamptz
  updated_at timestamptz

  Note: "Unique(user_id, api_entity)"
}

Table role {
  id character(36) [pk]
  name varchar(255) [unique]
  description varchar(1024)
  permission JSONB
  is_active boolean
  created_at timestamptz
  updated_at timestamptz
}

Table rider {
  id character(36) [pk]
  user_id character(36)
  adhar_verified boolean
  // rule based system to judge rider
  blocked boolean
  blocked_at timestamp
  blocked_by_rule_id VARCHAR(200)

  created_at timestamptz
  updated_at timestamptz

  Note: "Unique(user_id, api_entity)"
}

Table ride {
  id character(36) [pk]
  rider_id character(36)
  booking_id character(36)
  // driver_ride_params
  previour_ride_trip_end_lon number // to track location from last ride to current ride
  previour_ride_trip_end_lat number // to track location from last ride to current ride
  driver_arrival_time timestamptz
  is_advance_booking boolean

  traveled_distance number
  chargeable_distance number

  trip_end_lat number
  trip_end_log number
  trip_end_time timestamp

  trip_start_lat number
  trip_start_log number
  trip_start_time timestamp

  toll_charges number
  toll_names text[]
  fare number

  online_payment boolean

  created_at timestamptz
  updated_at timestamptz

  Note: "Unique(user_id, api_entity)"
}

Ref: ride.rider_id > rider.id
Ref: person_device_used.person_id > person.id
Ref: person.role_id > role.id
Ref: rider.user_id > person.id