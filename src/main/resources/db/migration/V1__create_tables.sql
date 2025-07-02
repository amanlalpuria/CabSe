-- V1__create_person_role_rider_tables.sql
-- Migration to create person, role, and rider tables

-- ========================
-- Table: role
-- Stores different roles in the system (admin, customer, rider etc.)
-- ========================
CREATE TABLE role (
    id CHAR(36) PRIMARY KEY,
    role_name VARCHAR(255) UNIQUE NOT NULL,
    description VARCHAR(1024),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ========================
-- Table: person
-- Stores user details and credentials
-- ========================
CREATE TABLE person (
    id CHAR(36) PRIMARY KEY,
    uuid UUID,
    role_id CHAR(36) REFERENCES role(id),

    first_name VARCHAR(255),
    last_name VARCHAR(255),

    -- Encrypted + hashed email
    email_encrypted VARCHAR(255),
    email_hash BYTEA,
    email_verified BOOLEAN DEFAULT FALSE,

    -- Encrypted + hashed mobile
    mobile_number_encrypted VARCHAR(255),
    mobile_number_hash BYTEA,
    mobile_country_code VARCHAR(255),
    mobile_verified BOOLEAN DEFAULT FALSE,

    gender VARCHAR(255),
    date_of_birth TIMESTAMP,
    profile_picture TEXT,

    password_hash BYTEA,

    last_login_at TIMESTAMPTZ,

    -- Social provider login support
    provider VARCHAR(50), -- GOOGLE, APPLE, FACEBOOK
    social_id VARCHAR(255), -- External provider ID

    -- Notifications
    receive_notification BOOLEAN DEFAULT TRUE,
    notification_token VARCHAR(255), -- FCM Token

    -- Security controls
    failed_login_attempts INTEGER DEFAULT 0,
    failed_otp_attempts INTEGER DEFAULT 0,
    password_changed_at TIMESTAMP,

    -- Soft delete support
    is_deleted BOOLEAN DEFAULT FALSE,

    -- Client info for tracking issues
    client_bundle_version TEXT,
    client_config_version TEXT,
    client_os_type TEXT,
    client_os_version TEXT,
    client_sdk_version TEXT,
    client_react_native_version TEXT,
    imei_number_hash BYTEA,
    imei_number_encrypted CHAR,

    -- Referral system
    customer_referral_code TEXT,
    referral_code CHAR,
    referred_at TIMESTAMP,
    referred_by_customer TEXT,

    -- Safety feature
    share_emergency_contacts BOOLEAN DEFAULT FALSE,
    share_trip_with_emergency_contact_option TEXT,

    -- Localization
    language CHAR,

    -- Ratings
    cabse_ratings INTEGER,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ========================
-- Table: rider
-- Special table to track rider-specific fields
-- ========================
CREATE TABLE rider (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL REFERENCES person(id),

    adhar_verified BOOLEAN DEFAULT FALSE,

    -- Rule-based system support
    blocked BOOLEAN DEFAULT FALSE,
    blocked_at TIMESTAMP,
    blocked_by_rule_id VARCHAR(200),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Enforce uniqueness for user per entity
    CONSTRAINT uniq_rider_user UNIQUE(user_id)
);
