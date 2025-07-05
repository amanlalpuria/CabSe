-- Create table: role
CREATE TABLE role (
    id CHARACTER(36) PRIMARY KEY,
    name VARCHAR(255) UNIQUE,
    description VARCHAR(1024),
    permission JSONB,
    is_active BOOLEAN,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
);

-- Create table: person
CREATE TABLE person (
    id CHARACTER(36) PRIMARY KEY,
    uuid UUID,
    role_id CHARACTER(36),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email_encrypted VARCHAR(255),
    email_hash BYTEA,
    email_verified BOOLEAN,
    mobile_number_encrypted VARCHAR(255),
    mobile_number_hash BYTEA,
    mobile_country_code VARCHAR(255),
    mobile_verified BOOLEAN,
    gender VARCHAR(255),
    date_of_birth TIMESTAMP,
    profile_picture TEXT,
    password_hash BYTEA,
    last_login_at TIMESTAMPTZ,

    -- Social login provider info (e.g., GOOGLE, APPLE, FACEBOOK)
    provider VARCHAR(50),
    social_id VARCHAR(255),

    -- Notification support
    receive_notification BOOLEAN,
    notification_token VARCHAR(255),

    -- Account security
    failed_login_attempts INTEGER,
    failed_otp_attempts INTEGER,
    password_changed_at TIMESTAMP,
    is_deleted BOOLEAN,

    -- App client diagnostics
    client_bundle_version TEXT,
    client_config_version TEXT,
    client_os_type TEXT,
    client_os_version TEXT,
    client_sdk_version TEXT,
    client_react_native_version TEXT,
    imei_number_hash BYTEA,
    imei_number_encrypted CHARACTER,

    -- Referral system
    customer_referral_code TEXT,
    referral_code CHARACTER,
    referred_at TIMESTAMP,
    referred_by_customer TEXT,

    -- Ladies safety feature
    share_emergency_contacts BOOLEAN,
    share_trip_with_emergency_contact_option TEXT,

    -- Local language support
    language CHARACTER,

    -- CABSE ratings
    cabse_ratings INTEGER,

    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,

    CONSTRAINT fk_person_role FOREIGN KEY (role_id) REFERENCES role(id)
);

-- Create table: rider
CREATE TABLE rider (
    id CHARACTER(36) PRIMARY KEY,
    user_id CHARACTER(36),
    adhar_verified BOOLEAN,

    -- Rule-based block system
    blocked BOOLEAN,
    blocked_at TIMESTAMP,
    blocked_by_rule_id VARCHAR(200),

    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,

    CONSTRAINT fk_rider_user FOREIGN KEY (user_id) REFERENCES person(id),
    CONSTRAINT uq_rider_user_id UNIQUE (user_id)
);

-- Create table: ride
CREATE TABLE ride (
    id CHARACTER(36) PRIMARY KEY,
    booking_id CHARACTER(36),

    -- Previous ride end location
    previour_ride_trip_end_lon NUMERIC,
    previour_ride_trip_end_lat NUMERIC,

    driver_arrival_time TIMESTAMPTZ,
    is_advance_booking BOOLEAN,

    traveled_distance NUMERIC,
    chargeable_distance NUMERIC,

    trip_end_lat NUMERIC,
    trip_end_log NUMERIC,
    trip_end_time TIMESTAMP,

    trip_start_lat NUMERIC,
    trip_start_log NUMERIC,
    trip_start_time TIMESTAMP,

    toll_charges NUMERIC,
    toll_names TEXT[],
    fare NUMERIC,

    online_payment BOOLEAN,

    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
);