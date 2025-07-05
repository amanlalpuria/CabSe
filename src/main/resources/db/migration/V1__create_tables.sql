-- ===========================================
-- Flyway Migration Script: V1__create_ride_and_person_tables.sql
-- Purpose: Create core tables for person, rider, ride, role, and person_device_used
-- ===========================================

-- PERSON TABLE
CREATE TABLE person (
    id CHARACTER(36) PRIMARY KEY,
    uuid UUID,
    role_id CHARACTER(36) REFERENCES role(id),

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

    provider VARCHAR(50), -- GOOGLE, APPLE, FACEBOOK
    social_id VARCHAR(255), -- ID from respective social provider

    receive_notification BOOLEAN,
    notification_token VARCHAR(255), -- Firebase FCM token

    failed_login_attempts INTEGER,
    failed_otp_attempts INTEGER,

    password_changed_at TIMESTAMP, -- used to invalidate tokens issued before

    is_deleted BOOLEAN, -- soft delete

    customer_referral_code TEXT,
    referral_code CHARACTER,
    referred_at TIMESTAMP,
    referred_by_customer TEXT,

    share_emergency_contacts BOOLEAN,
    share_trip_with_emergency_contact_option TEXT,

    language CHARACTER,
    cabse_ratings INTEGER,

    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
);

-- ROLE TABLE
CREATE TABLE role (
    id CHARACTER(36) PRIMARY KEY,
    name VARCHAR(255) UNIQUE,
    description VARCHAR(1024),
    permission JSONB,
    is_active BOOLEAN,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
);

-- PERSON_DEVICE_USED TABLE
CREATE TABLE person_device_used (
    id CHARACTER(36) PRIMARY KEY,
    person_id CHARACTER(36) REFERENCES person(id),

    client_bundle_version TEXT,
    client_config_version TEXT,
    client_os_type TEXT,
    client_os_version TEXT,
    client_sdk_version TEXT,
    client_react_native_version TEXT,

    imei_number_hash BYTEA,
    imei_number_encrypted CHARACTER,

    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,

    CONSTRAINT unique_person_device UNIQUE (person_id, client_bundle_version)
);

-- RIDER TABLE
CREATE TABLE rider (
    id CHARACTER(36) PRIMARY KEY,
    user_id CHARACTER(36) REFERENCES person(id),

    adhar_verified BOOLEAN,
    blocked BOOLEAN,
    blocked_at TIMESTAMP,
    blocked_by_rule_id VARCHAR(200),

    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,

    CONSTRAINT unique_rider_user UNIQUE (user_id)
);

-- RIDE TABLE
CREATE TABLE ride (
    id CHARACTER(36) PRIMARY KEY,
    rider_id CHARACTER(36) REFERENCES rider(id),
    booking_id CHARACTER(36),

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
    updated_at TIMESTAMPTZ,

    CONSTRAINT unique_rider_booking UNIQUE (rider_id, booking_id)
);