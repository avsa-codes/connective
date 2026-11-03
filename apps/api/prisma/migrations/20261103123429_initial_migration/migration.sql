-- CreateEnum
CREATE TYPE "platform_admin_status" AS ENUM ('ACTIVE', 'REVOKED');

-- CreateEnum
CREATE TYPE "business_category" AS ENUM ('CLOTHING', 'SALON_SPA_WELLNESS');

-- CreateEnum
CREATE TYPE "organization_status" AS ENUM ('ACTIVE', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "onboarding_status" AS ENUM ('PENDING', 'IN_PROGRESS', 'COMPLETED');

-- CreateEnum
CREATE TYPE "day_of_week" AS ENUM ('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY');

-- CreateEnum
CREATE TYPE "website_status" AS ENUM ('DRAFT', 'PUBLISHED', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "website_template_status" AS ENUM ('DRAFT', 'ACTIVE', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "template_release_status" AS ENUM ('DRAFT', 'RELEASED', 'DEPRECATED');

-- CreateEnum
CREATE TYPE "website_domain_type" AS ENUM ('CONNECTIVE_SUBDOMAIN', 'CUSTOM_DOMAIN');

-- CreateEnum
CREATE TYPE "domain_verification_status" AS ENUM ('PENDING', 'VERIFIED', 'FAILED');

-- CreateEnum
CREATE TYPE "domain_activation_status" AS ENUM ('INACTIVE', 'ACTIVE', 'FAILED');

-- CreateEnum
CREATE TYPE "catalogue_type" AS ENUM ('PRODUCT', 'SERVICE');

-- CreateEnum
CREATE TYPE "catalogue_category_status" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "pricing_type" AS ENUM ('FIXED', 'STARTING_AT', 'RANGE');

-- CreateEnum
CREATE TYPE "catalogue_availability_status" AS ENUM ('AVAILABLE', 'UNAVAILABLE');

-- CreateEnum
CREATE TYPE "catalogue_image_role" AS ENUM ('PRIMARY', 'GALLERY');

-- CreateEnum
CREATE TYPE "media_type" AS ENUM ('IMAGE', 'AUDIO');

-- CreateEnum
CREATE TYPE "media_processing_status" AS ENUM ('PENDING', 'PROCESSING', 'READY', 'FAILED');

-- CreateEnum
CREATE TYPE "media_access_level" AS ENUM ('PUBLIC', 'PRIVATE');

-- CreateEnum
CREATE TYPE "media_variant_type" AS ENUM ('THUMBNAIL', 'SMALL', 'MEDIUM', 'LARGE');

-- CreateEnum
CREATE TYPE "lead_status" AS ENUM ('NEW', 'CONTACTED', 'FOLLOW_UP', 'CONVERTED', 'LOST');

-- CreateEnum
CREATE TYPE "lead_source" AS ENUM ('WEBSITE', 'WHATSAPP', 'INSTAGRAM', 'GOOGLE_BUSINESS', 'MANUAL', 'OTHER');

-- CreateEnum
CREATE TYPE "contact_channel" AS ENUM ('PHONE', 'EMAIL', 'WHATSAPP', 'WEBSITE_FORM', 'OTHER');

-- CreateEnum
CREATE TYPE "lead_follow_up_status" AS ENUM ('PENDING', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "availability_slot_status" AS ENUM ('AVAILABLE', 'UNAVAILABLE', 'BOOKED');

-- CreateEnum
CREATE TYPE "booking_status" AS ENUM ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED', 'NO_SHOW');

-- CreateEnum
CREATE TYPE "booking_activity_type" AS ENUM ('CREATED', 'CONFIRMED', 'RESCHEDULED', 'CANCELLED', 'COMPLETED', 'NO_SHOW', 'UPDATED');

-- CreateEnum
CREATE TYPE "ai_content_type" AS ENUM ('TEXT', 'IMAGE');

-- CreateEnum
CREATE TYPE "ai_content_generation_status" AS ENUM ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED');

-- CreateEnum
CREATE TYPE "notification_type" AS ENUM ('GENERAL', 'LEAD', 'BOOKING', 'SUBSCRIPTION', 'PAYMENT', 'SYSTEM');

-- CreateEnum
CREATE TYPE "notification_channel" AS ENUM ('IN_APP', 'WHATSAPP');

-- CreateEnum
CREATE TYPE "notification_delivery_status" AS ENUM ('PENDING', 'PROCESSING', 'SENT', 'DELIVERED', 'FAILED');

-- CreateEnum
CREATE TYPE "outbox_event_status" AS ENUM ('PENDING', 'PROCESSING', 'PROCESSED', 'FAILED');

-- CreateEnum
CREATE TYPE "integration_provider" AS ENUM ('GOOGLE_BUSINESS_PROFILE', 'INSTAGRAM', 'WHATSAPP');

-- CreateEnum
CREATE TYPE "integration_account_status" AS ENUM ('CONNECTED', 'REAUTH_REQUIRED', 'ERROR', 'DISCONNECTED');

-- CreateEnum
CREATE TYPE "integration_resource_status" AS ENUM ('ACTIVE', 'INACTIVE', 'ERROR');

-- CreateEnum
CREATE TYPE "integration_sync_status" AS ENUM ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "whatsapp_conversation_status" AS ENUM ('OPEN', 'CLOSED', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "whatsapp_message_direction" AS ENUM ('INBOUND', 'OUTBOUND');

-- CreateEnum
CREATE TYPE "whatsapp_content_type" AS ENUM ('TEXT', 'IMAGE', 'AUDIO', 'VIDEO', 'DOCUMENT', 'OTHER');

-- CreateEnum
CREATE TYPE "whatsapp_message_status" AS ENUM ('PENDING', 'SENT', 'DELIVERED', 'READ', 'FAILED');

-- CreateEnum
CREATE TYPE "plan_status" AS ENUM ('ACTIVE', 'INACTIVE', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "billing_interval" AS ENUM ('MONTHLY', 'YEARLY');

-- CreateEnum
CREATE TYPE "plan_price_status" AS ENUM ('ACTIVE', 'INACTIVE', 'SCHEDULED', 'RETIRED');

-- CreateEnum
CREATE TYPE "subscription_status" AS ENUM ('TRIALING', 'ACTIVE', 'PAST_DUE', 'CANCELLED', 'EXPIRED', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "payment_provider" AS ENUM ('RAZORPAY', 'OTHER');

-- CreateEnum
CREATE TYPE "payment_customer_status" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "payment_purpose" AS ENUM ('SUBSCRIPTION', 'MANAGED_SERVICE', 'OTHER');

-- CreateEnum
CREATE TYPE "payment_status" AS ENUM ('PENDING', 'REQUIRES_ACTION', 'SUCCEEDED', 'FAILED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "invoice_status" AS ENUM ('DRAFT', 'ISSUED', 'PAID', 'OVERDUE', 'VOID', 'CANCELLED');

-- CreateEnum
CREATE TYPE "invoice_item_type" AS ENUM ('SUBSCRIPTION', 'MANAGED_SERVICE', 'OTHER');

-- CreateEnum
CREATE TYPE "payment_provider_event_status" AS ENUM ('PENDING', 'PROCESSING', 'PROCESSED', 'FAILED');

-- CreateEnum
CREATE TYPE "service_inquiry_status" AS ENUM ('NEW', 'CONTACTED', 'IN_DISCUSSION', 'CLOSED');

-- CreateEnum
CREATE TYPE "audit_actor_type" AS ENUM ('USER', 'PLATFORM_ADMIN', 'SYSTEM', 'EXTERNAL_SERVICE');

-- CreateTable
CREATE TABLE "user" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "emailVerified" BOOLEAN NOT NULL DEFAULT false,
    "phoneNumber" TEXT,
    "phoneNumberVerified" BOOLEAN DEFAULT false,
    "image" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "session" (
    "id" UUID NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "token" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "userId" UUID NOT NULL,

    CONSTRAINT "session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "account" (
    "id" UUID NOT NULL,
    "accountId" TEXT NOT NULL,
    "providerId" TEXT NOT NULL,
    "userId" UUID NOT NULL,
    "accessToken" TEXT,
    "refreshToken" TEXT,
    "idToken" TEXT,
    "accessTokenExpiresAt" TIMESTAMP(3),
    "refreshTokenExpiresAt" TIMESTAMP(3),
    "scope" TEXT,
    "password" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "verification" (
    "id" UUID NOT NULL,
    "identifier" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "verification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "platform_admin_access" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "status" "platform_admin_status" NOT NULL DEFAULT 'ACTIVE',
    "grantedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "revokedAt" TIMESTAMP(3),
    "grantedByUserId" UUID,
    "revokedByUserId" UUID,
    "reason" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "platform_admin_access_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization" (
    "id" UUID NOT NULL,
    "ownerUserId" UUID NOT NULL,
    "businessName" TEXT NOT NULL,
    "businessCategory" "business_category" NOT NULL,
    "status" "organization_status" NOT NULL DEFAULT 'ACTIVE',
    "onboardingStatus" "onboarding_status" NOT NULL DEFAULT 'PENDING',
    "timezone" TEXT NOT NULL DEFAULT 'Asia/Kolkata',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "organization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "business_profile" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "displayName" TEXT NOT NULL,
    "description" TEXT,
    "logoAssetId" UUID,
    "contactEmail" TEXT,
    "contactPhone" TEXT,
    "addressLine1" TEXT,
    "addressLine2" TEXT,
    "city" TEXT,
    "state" TEXT,
    "postalCode" TEXT,
    "countryCode" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "business_profile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "business_hours" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "dayOfWeek" "day_of_week" NOT NULL,
    "opensAt" TIME(0) NOT NULL,
    "closesAt" TIME(0) NOT NULL,

    CONSTRAINT "business_hours_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "website" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "selectedTemplateReleaseId" UUID NOT NULL,
    "status" "website_status" NOT NULL DEFAULT 'DRAFT',
    "currentPublishedVersionId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "website_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "website_template" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "businessCategory" "business_category" NOT NULL,
    "status" "website_template_status" NOT NULL DEFAULT 'DRAFT',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "website_template_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "website_template_release" (
    "id" UUID NOT NULL,
    "templateId" UUID NOT NULL,
    "versionNumber" INTEGER NOT NULL,
    "status" "template_release_status" NOT NULL DEFAULT 'DRAFT',
    "releaseNotes" TEXT,
    "releasedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "website_template_release_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "website_draft" (
    "id" UUID NOT NULL,
    "websiteId" UUID NOT NULL,
    "templateReleaseId" UUID NOT NULL,
    "contentDocument" JSONB NOT NULL,
    "revisionNumber" INTEGER NOT NULL DEFAULT 1,
    "updatedByUserId" UUID NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "website_draft_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "website_version" (
    "id" UUID NOT NULL,
    "websiteId" UUID NOT NULL,
    "versionNumber" INTEGER NOT NULL,
    "templateReleaseId" UUID NOT NULL,
    "contentSnapshot" JSONB NOT NULL,
    "publishedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "publishedByUserId" UUID NOT NULL,
    "sourceVersionId" UUID,

    CONSTRAINT "website_version_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "website_domain" (
    "id" UUID NOT NULL,
    "websiteId" UUID NOT NULL,
    "domainName" TEXT NOT NULL,
    "domainType" "website_domain_type" NOT NULL,
    "verificationStatus" "domain_verification_status" NOT NULL DEFAULT 'PENDING',
    "activationStatus" "domain_activation_status" NOT NULL DEFAULT 'INACTIVE',
    "verifiedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "website_domain_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "catalogue_category" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "catalogueType" "catalogue_type" NOT NULL,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "status" "catalogue_category_status" NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "catalogue_category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "categoryId" UUID,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT,
    "pricingType" "pricing_type" NOT NULL DEFAULT 'FIXED',
    "basePrice" DECIMAL(10,2),
    "minimumPrice" DECIMAL(10,2),
    "maximumPrice" DECIMAL(10,2),
    "availabilityStatus" "catalogue_availability_status" NOT NULL DEFAULT 'AVAILABLE',
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "archivedAt" TIMESTAMP(3),

    CONSTRAINT "product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_variant" (
    "id" UUID NOT NULL,
    "productId" UUID NOT NULL,
    "size" TEXT,
    "colour" TEXT,
    "sku" TEXT,
    "priceOverride" DECIMAL(10,2),
    "availabilityStatus" "catalogue_availability_status" NOT NULL DEFAULT 'AVAILABLE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "archivedAt" TIMESTAMP(3),

    CONSTRAINT "product_variant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "salon_service" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "categoryId" UUID,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT,
    "pricingType" "pricing_type" NOT NULL DEFAULT 'FIXED',
    "basePrice" DECIMAL(10,2),
    "minimumPrice" DECIMAL(10,2),
    "maximumPrice" DECIMAL(10,2),
    "durationMinutes" INTEGER,
    "availabilityStatus" "catalogue_availability_status" NOT NULL DEFAULT 'AVAILABLE',
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "archivedAt" TIMESTAMP(3),

    CONSTRAINT "salon_service_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_image" (
    "id" UUID NOT NULL,
    "productId" UUID NOT NULL,
    "mediaAssetId" UUID NOT NULL,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "role" "catalogue_image_role",

    CONSTRAINT "product_image_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "service_image" (
    "id" UUID NOT NULL,
    "serviceId" UUID NOT NULL,
    "mediaAssetId" UUID NOT NULL,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "role" "catalogue_image_role",

    CONSTRAINT "service_image_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "media_asset" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "uploadedByUserId" UUID,
    "storageKey" TEXT NOT NULL,
    "originalFileName" TEXT NOT NULL,
    "mimeType" TEXT NOT NULL,
    "fileSizeBytes" BIGINT NOT NULL,
    "mediaType" "media_type" NOT NULL,
    "width" INTEGER,
    "height" INTEGER,
    "processingStatus" "media_processing_status" NOT NULL DEFAULT 'PENDING',
    "accessLevel" "media_access_level" NOT NULL DEFAULT 'PRIVATE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "media_asset_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "media_variant" (
    "id" UUID NOT NULL,
    "mediaAssetId" UUID NOT NULL,
    "variantType" "media_variant_type" NOT NULL,
    "storageKey" TEXT NOT NULL,
    "mimeType" TEXT NOT NULL,
    "fileSizeBytes" BIGINT NOT NULL,
    "width" INTEGER,
    "height" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "media_variant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lead" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "customerName" TEXT,
    "phone" TEXT,
    "email" TEXT,
    "message" TEXT NOT NULL,
    "source" "lead_source" NOT NULL,
    "contactChannel" "contact_channel" NOT NULL,
    "status" "lead_status" NOT NULL DEFAULT 'NEW',
    "createdByUserId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "archivedAt" TIMESTAMP(3),

    CONSTRAINT "lead_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lead_follow_up" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "leadId" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "dueAt" TIMESTAMP(3) NOT NULL,
    "status" "lead_follow_up_status" NOT NULL DEFAULT 'PENDING',
    "completedAt" TIMESTAMP(3),
    "createdByUserId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "lead_follow_up_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lead_note" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "leadId" UUID NOT NULL,
    "createdByUserId" UUID NOT NULL,
    "content" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "lead_note_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "availability_slot" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "startsAt" TIMESTAMP(3) NOT NULL,
    "endsAt" TIMESTAMP(3) NOT NULL,
    "status" "availability_slot_status" NOT NULL DEFAULT 'AVAILABLE',
    "createdByUserId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "availability_slot_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "booking" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "serviceId" UUID NOT NULL,
    "availabilitySlotId" UUID NOT NULL,
    "customerName" TEXT NOT NULL,
    "customerPhone" TEXT NOT NULL,
    "customerEmail" TEXT,
    "startsAt" TIMESTAMP(3) NOT NULL,
    "endsAt" TIMESTAMP(3) NOT NULL,
    "status" "booking_status" NOT NULL DEFAULT 'PENDING',
    "customerMessage" TEXT,
    "leadId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "booking_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "booking_activity" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "bookingId" UUID NOT NULL,
    "actorUserId" UUID,
    "activityType" "booking_activity_type" NOT NULL,
    "details" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "booking_activity_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ai_content_generation" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "createdByUserId" UUID NOT NULL,
    "conversationId" UUID,
    "contentType" "ai_content_type" NOT NULL,
    "prompt" TEXT NOT NULL,
    "responseText" TEXT,
    "mediaAssetId" UUID,
    "status" "ai_content_generation_status" NOT NULL DEFAULT 'PENDING',
    "errorCode" TEXT,
    "isSaved" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),

    CONSTRAINT "ai_content_generation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification" (
    "id" UUID NOT NULL,
    "organizationId" UUID,
    "recipientUserId" UUID NOT NULL,
    "notificationType" "notification_type" NOT NULL,
    "title" TEXT NOT NULL,
    "body" TEXT NOT NULL,
    "relatedEntityType" TEXT,
    "relatedEntityId" TEXT,
    "readAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3),

    CONSTRAINT "notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_delivery" (
    "id" UUID NOT NULL,
    "notificationId" UUID NOT NULL,
    "channel" "notification_channel" NOT NULL,
    "status" "notification_delivery_status" NOT NULL DEFAULT 'PENDING',
    "attemptCount" INTEGER NOT NULL DEFAULT 0,
    "nextAttemptAt" TIMESTAMP(3),
    "sentAt" TIMESTAMP(3),
    "deliveredAt" TIMESTAMP(3),
    "providerMessageId" TEXT,
    "failureCode" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "notification_delivery_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "outbox_event" (
    "id" UUID NOT NULL,
    "eventType" TEXT NOT NULL,
    "organizationId" UUID,
    "aggregateType" TEXT NOT NULL,
    "aggregateId" UUID NOT NULL,
    "payload" JSONB NOT NULL,
    "status" "outbox_event_status" NOT NULL DEFAULT 'PENDING',
    "attemptCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "processedAt" TIMESTAMP(3),
    "nextAttemptAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastErrorCode" TEXT,

    CONSTRAINT "outbox_event_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "integration_account" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "provider" "integration_provider" NOT NULL,
    "externalAccountId" TEXT NOT NULL,
    "displayName" TEXT,
    "status" "integration_account_status" NOT NULL DEFAULT 'CONNECTED',
    "connectedByUserId" UUID NOT NULL,
    "connectedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "disconnectedAt" TIMESTAMP(3),
    "lastValidatedAt" TIMESTAMP(3),

    CONSTRAINT "integration_account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "integration_credential" (
    "id" UUID NOT NULL,
    "integrationAccountId" UUID NOT NULL,
    "credentialReference" TEXT NOT NULL,
    "tokenExpiresAt" TIMESTAMP(3),
    "grantedScopes" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "lastRefreshedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "revokedAt" TIMESTAMP(3),

    CONSTRAINT "integration_credential_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "integration_resource" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "integrationAccountId" UUID NOT NULL,
    "resourceType" TEXT NOT NULL,
    "externalResourceId" TEXT NOT NULL,
    "displayName" TEXT,
    "status" "integration_resource_status" NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "integration_resource_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "integration_sync_job" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "integrationAccountId" UUID NOT NULL,
    "integrationResourceId" UUID,
    "jobType" TEXT NOT NULL,
    "status" "integration_sync_status" NOT NULL DEFAULT 'PENDING',
    "attemptCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "startedAt" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3),
    "nextAttemptAt" TIMESTAMP(3),
    "errorCode" TEXT,

    CONSTRAINT "integration_sync_job_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "integration_metric_snapshot" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "integrationResourceId" UUID NOT NULL,
    "metricType" TEXT NOT NULL,
    "periodStart" TIMESTAMP(3) NOT NULL,
    "periodEnd" TIMESTAMP(3) NOT NULL,
    "value" DECIMAL(20,4) NOT NULL,
    "retrievedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sourceMetadata" JSONB,

    CONSTRAINT "integration_metric_snapshot_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "whatsapp_conversation" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "customerPhone" TEXT NOT NULL,
    "customerName" TEXT,
    "leadId" UUID,
    "status" "whatsapp_conversation_status" NOT NULL DEFAULT 'OPEN',
    "lastMessageAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "whatsapp_conversation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "whatsapp_message" (
    "id" UUID NOT NULL,
    "conversationId" UUID NOT NULL,
    "direction" "whatsapp_message_direction" NOT NULL,
    "contentType" "whatsapp_content_type" NOT NULL,
    "body" TEXT,
    "mediaAssetId" UUID,
    "providerMessageId" TEXT,
    "status" "whatsapp_message_status" NOT NULL DEFAULT 'PENDING',
    "sentAt" TIMESTAMP(3),
    "deliveredAt" TIMESTAMP(3),
    "readAt" TIMESTAMP(3),
    "failureCode" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "whatsapp_message_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "plan" (
    "id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "status" "plan_status" NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "plan_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "plan_price" (
    "id" UUID NOT NULL,
    "planId" UUID NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "billingInterval" "billing_interval" NOT NULL,
    "effectiveFrom" TIMESTAMP(3) NOT NULL,
    "effectiveUntil" TIMESTAMP(3),
    "status" "plan_price_status" NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "plan_price_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "plan_entitlement" (
    "id" UUID NOT NULL,
    "planId" UUID NOT NULL,
    "featureCode" TEXT NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "limitValue" DECIMAL(12,2),
    "limitUnit" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "plan_entitlement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subscription" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "planId" UUID NOT NULL,
    "planPriceId" UUID NOT NULL,
    "status" "subscription_status" NOT NULL DEFAULT 'ACTIVE',
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "currentPeriodStart" TIMESTAMP(3) NOT NULL,
    "currentPeriodEnd" TIMESTAMP(3) NOT NULL,
    "gracePeriodEndsAt" TIMESTAMP(3),
    "cancelAtPeriodEnd" BOOLEAN NOT NULL DEFAULT false,
    "cancelledAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "subscription_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "usage_record" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "featureCode" TEXT NOT NULL,
    "quantity" DECIMAL(12,2) NOT NULL,
    "unit" TEXT NOT NULL,
    "occurredAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "periodStart" TIMESTAMP(3) NOT NULL,
    "periodEnd" TIMESTAMP(3) NOT NULL,
    "sourceType" TEXT,
    "sourceId" UUID,
    "idempotencyKey" TEXT,

    CONSTRAINT "usage_record_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_customer" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "provider" "payment_provider" NOT NULL,
    "externalCustomerId" TEXT NOT NULL,
    "status" "payment_customer_status" NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "payment_customer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "paymentCustomerId" UUID,
    "provider" "payment_provider" NOT NULL,
    "externalPaymentId" TEXT,
    "purpose" "payment_purpose" NOT NULL,
    "amount" DECIMAL(12,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "status" "payment_status" NOT NULL DEFAULT 'PENDING',
    "idempotencyKey" TEXT,
    "initiatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "succeededAt" TIMESTAMP(3),
    "failureCode" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "payment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoice" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "invoiceNumber" TEXT NOT NULL,
    "status" "invoice_status" NOT NULL DEFAULT 'DRAFT',
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "subtotalAmount" DECIMAL(12,2) NOT NULL,
    "taxAmount" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "totalAmount" DECIMAL(12,2) NOT NULL,
    "issuedAt" TIMESTAMP(3) NOT NULL,
    "dueAt" TIMESTAMP(3),
    "paidAt" TIMESTAMP(3),
    "voidedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "invoice_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoice_line" (
    "id" UUID NOT NULL,
    "invoiceId" UUID NOT NULL,
    "description" TEXT NOT NULL,
    "itemType" "invoice_item_type" NOT NULL,
    "quantity" DECIMAL(12,2) NOT NULL,
    "unitAmount" DECIMAL(12,2) NOT NULL,
    "taxAmount" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "lineTotal" DECIMAL(12,2) NOT NULL,
    "relatedSubscriptionId" UUID,
    "relatedServiceId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "invoice_line_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_allocation" (
    "id" UUID NOT NULL,
    "paymentId" UUID NOT NULL,
    "invoiceId" UUID NOT NULL,
    "allocatedAmount" DECIMAL(12,2) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payment_allocation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_provider_event" (
    "id" UUID NOT NULL,
    "provider" "payment_provider" NOT NULL,
    "externalEventId" TEXT NOT NULL,
    "eventType" TEXT NOT NULL,
    "receivedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "processedAt" TIMESTAMP(3),
    "processingStatus" "payment_provider_event_status" NOT NULL DEFAULT 'PENDING',
    "attemptCount" INTEGER NOT NULL DEFAULT 0,
    "relatedPaymentId" UUID,
    "relatedRefundId" UUID,
    "failureCode" TEXT,

    CONSTRAINT "payment_provider_event_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "service_inquiry" (
    "id" UUID NOT NULL,
    "merchantName" TEXT NOT NULL,
    "businessName" TEXT,
    "phone" TEXT NOT NULL,
    "email" TEXT,
    "serviceInterestedIn" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "status" "service_inquiry_status" NOT NULL DEFAULT 'NEW',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "service_inquiry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_log" (
    "id" UUID NOT NULL,
    "organizationId" UUID,
    "actorUserId" UUID,
    "actorType" "audit_actor_type" NOT NULL,
    "action" TEXT NOT NULL,
    "entityType" TEXT NOT NULL,
    "entityId" TEXT,
    "details" JSONB,
    "ipAddress" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_log_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "user_phoneNumber_key" ON "user"("phoneNumber");

-- CreateIndex
CREATE INDEX "session_userId_idx" ON "session"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "session_token_key" ON "session"("token");

-- CreateIndex
CREATE INDEX "account_userId_idx" ON "account"("userId");

-- CreateIndex
CREATE INDEX "verification_identifier_idx" ON "verification"("identifier");

-- CreateIndex
CREATE UNIQUE INDEX "platform_admin_access_userId_key" ON "platform_admin_access"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "organization_ownerUserId_key" ON "organization"("ownerUserId");

-- CreateIndex
CREATE UNIQUE INDEX "business_profile_organizationId_key" ON "business_profile"("organizationId");

-- CreateIndex
CREATE INDEX "business_hours_organizationId_dayOfWeek_idx" ON "business_hours"("organizationId", "dayOfWeek");

-- CreateIndex
CREATE UNIQUE INDEX "website_organizationId_key" ON "website"("organizationId");

-- CreateIndex
CREATE UNIQUE INDEX "website_currentPublishedVersionId_key" ON "website"("currentPublishedVersionId");

-- CreateIndex
CREATE UNIQUE INDEX "website_template_slug_key" ON "website_template"("slug");

-- CreateIndex
CREATE INDEX "website_template_release_templateId_status_idx" ON "website_template_release"("templateId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "website_template_release_templateId_versionNumber_key" ON "website_template_release"("templateId", "versionNumber");

-- CreateIndex
CREATE UNIQUE INDEX "website_draft_websiteId_key" ON "website_draft"("websiteId");

-- CreateIndex
CREATE INDEX "website_version_websiteId_publishedAt_idx" ON "website_version"("websiteId", "publishedAt");

-- CreateIndex
CREATE UNIQUE INDEX "website_version_websiteId_versionNumber_key" ON "website_version"("websiteId", "versionNumber");

-- CreateIndex
CREATE UNIQUE INDEX "website_domain_domainName_key" ON "website_domain"("domainName");

-- CreateIndex
CREATE INDEX "website_domain_websiteId_idx" ON "website_domain"("websiteId");

-- CreateIndex
CREATE INDEX "website_domain_verificationStatus_activationStatus_idx" ON "website_domain"("verificationStatus", "activationStatus");

-- CreateIndex
CREATE INDEX "catalogue_category_organizationId_catalogueType_status_idx" ON "catalogue_category"("organizationId", "catalogueType", "status");

-- CreateIndex
CREATE UNIQUE INDEX "catalogue_category_organizationId_slug_key" ON "catalogue_category"("organizationId", "slug");

-- CreateIndex
CREATE INDEX "product_organizationId_availabilityStatus_archivedAt_idx" ON "product"("organizationId", "availabilityStatus", "archivedAt");

-- CreateIndex
CREATE INDEX "product_categoryId_idx" ON "product"("categoryId");

-- CreateIndex
CREATE UNIQUE INDEX "product_organizationId_slug_key" ON "product"("organizationId", "slug");

-- CreateIndex
CREATE INDEX "product_variant_productId_availabilityStatus_archivedAt_idx" ON "product_variant"("productId", "availabilityStatus", "archivedAt");

-- CreateIndex
CREATE UNIQUE INDEX "product_variant_productId_sku_key" ON "product_variant"("productId", "sku");

-- CreateIndex
CREATE INDEX "salon_service_organizationId_availabilityStatus_archivedAt_idx" ON "salon_service"("organizationId", "availabilityStatus", "archivedAt");

-- CreateIndex
CREATE INDEX "salon_service_categoryId_idx" ON "salon_service"("categoryId");

-- CreateIndex
CREATE UNIQUE INDEX "salon_service_organizationId_slug_key" ON "salon_service"("organizationId", "slug");

-- CreateIndex
CREATE INDEX "product_image_productId_sortOrder_idx" ON "product_image"("productId", "sortOrder");

-- CreateIndex
CREATE INDEX "product_image_mediaAssetId_idx" ON "product_image"("mediaAssetId");

-- CreateIndex
CREATE INDEX "service_image_serviceId_sortOrder_idx" ON "service_image"("serviceId", "sortOrder");

-- CreateIndex
CREATE INDEX "service_image_mediaAssetId_idx" ON "service_image"("mediaAssetId");

-- CreateIndex
CREATE UNIQUE INDEX "media_asset_storageKey_key" ON "media_asset"("storageKey");

-- CreateIndex
CREATE INDEX "media_asset_organizationId_mediaType_deletedAt_idx" ON "media_asset"("organizationId", "mediaType", "deletedAt");

-- CreateIndex
CREATE INDEX "media_asset_organizationId_processingStatus_idx" ON "media_asset"("organizationId", "processingStatus");

-- CreateIndex
CREATE INDEX "media_asset_uploadedByUserId_idx" ON "media_asset"("uploadedByUserId");

-- CreateIndex
CREATE UNIQUE INDEX "media_variant_storageKey_key" ON "media_variant"("storageKey");

-- CreateIndex
CREATE INDEX "media_variant_mediaAssetId_idx" ON "media_variant"("mediaAssetId");

-- CreateIndex
CREATE UNIQUE INDEX "media_variant_mediaAssetId_variantType_key" ON "media_variant"("mediaAssetId", "variantType");

-- CreateIndex
CREATE INDEX "lead_organizationId_status_archivedAt_idx" ON "lead"("organizationId", "status", "archivedAt");

-- CreateIndex
CREATE INDEX "lead_organizationId_createdAt_idx" ON "lead"("organizationId", "createdAt");

-- CreateIndex
CREATE INDEX "lead_follow_up_organizationId_status_dueAt_idx" ON "lead_follow_up"("organizationId", "status", "dueAt");

-- CreateIndex
CREATE INDEX "lead_follow_up_leadId_status_idx" ON "lead_follow_up"("leadId", "status");

-- CreateIndex
CREATE INDEX "lead_note_leadId_createdAt_idx" ON "lead_note"("leadId", "createdAt");

-- CreateIndex
CREATE INDEX "lead_note_organizationId_idx" ON "lead_note"("organizationId");

-- CreateIndex
CREATE INDEX "availability_slot_organizationId_startsAt_endsAt_idx" ON "availability_slot"("organizationId", "startsAt", "endsAt");

-- CreateIndex
CREATE INDEX "availability_slot_organizationId_status_startsAt_idx" ON "availability_slot"("organizationId", "status", "startsAt");

-- CreateIndex
CREATE INDEX "booking_organizationId_startsAt_status_idx" ON "booking"("organizationId", "startsAt", "status");

-- CreateIndex
CREATE INDEX "booking_availabilitySlotId_status_idx" ON "booking"("availabilitySlotId", "status");

-- CreateIndex
CREATE INDEX "booking_serviceId_idx" ON "booking"("serviceId");

-- CreateIndex
CREATE INDEX "booking_leadId_idx" ON "booking"("leadId");

-- CreateIndex
CREATE INDEX "booking_activity_bookingId_createdAt_idx" ON "booking_activity"("bookingId", "createdAt");

-- CreateIndex
CREATE INDEX "booking_activity_organizationId_createdAt_idx" ON "booking_activity"("organizationId", "createdAt");

-- CreateIndex
CREATE INDEX "ai_content_generation_organizationId_createdAt_idx" ON "ai_content_generation"("organizationId", "createdAt");

-- CreateIndex
CREATE INDEX "ai_content_generation_organizationId_isSaved_createdAt_idx" ON "ai_content_generation"("organizationId", "isSaved", "createdAt");

-- CreateIndex
CREATE INDEX "ai_content_generation_status_createdAt_idx" ON "ai_content_generation"("status", "createdAt");

-- CreateIndex
CREATE INDEX "ai_content_generation_createdByUserId_idx" ON "ai_content_generation"("createdByUserId");

-- CreateIndex
CREATE INDEX "notification_recipientUserId_readAt_createdAt_idx" ON "notification"("recipientUserId", "readAt", "createdAt");

-- CreateIndex
CREATE INDEX "notification_organizationId_createdAt_idx" ON "notification"("organizationId", "createdAt");

-- CreateIndex
CREATE INDEX "notification_expiresAt_idx" ON "notification"("expiresAt");

-- CreateIndex
CREATE INDEX "notification_delivery_notificationId_channel_idx" ON "notification_delivery"("notificationId", "channel");

-- CreateIndex
CREATE INDEX "notification_delivery_status_nextAttemptAt_idx" ON "notification_delivery"("status", "nextAttemptAt");

-- CreateIndex
CREATE INDEX "notification_delivery_providerMessageId_idx" ON "notification_delivery"("providerMessageId");

-- CreateIndex
CREATE INDEX "outbox_event_status_nextAttemptAt_idx" ON "outbox_event"("status", "nextAttemptAt");

-- CreateIndex
CREATE INDEX "outbox_event_organizationId_createdAt_idx" ON "outbox_event"("organizationId", "createdAt");

-- CreateIndex
CREATE INDEX "outbox_event_aggregateType_aggregateId_idx" ON "outbox_event"("aggregateType", "aggregateId");

-- CreateIndex
CREATE INDEX "integration_account_organizationId_status_idx" ON "integration_account"("organizationId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "integration_account_organizationId_provider_externalAccount_key" ON "integration_account"("organizationId", "provider", "externalAccountId");

-- CreateIndex
CREATE INDEX "integration_credential_integrationAccountId_revokedAt_idx" ON "integration_credential"("integrationAccountId", "revokedAt");

-- CreateIndex
CREATE INDEX "integration_resource_organizationId_status_idx" ON "integration_resource"("organizationId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "integration_resource_integrationAccountId_resourceType_exte_key" ON "integration_resource"("integrationAccountId", "resourceType", "externalResourceId");

-- CreateIndex
CREATE INDEX "integration_sync_job_status_nextAttemptAt_idx" ON "integration_sync_job"("status", "nextAttemptAt");

-- CreateIndex
CREATE INDEX "integration_sync_job_organizationId_createdAt_idx" ON "integration_sync_job"("organizationId", "createdAt");

-- CreateIndex
CREATE INDEX "integration_sync_job_integrationAccountId_status_idx" ON "integration_sync_job"("integrationAccountId", "status");

-- CreateIndex
CREATE INDEX "integration_metric_snapshot_organizationId_metricType_perio_idx" ON "integration_metric_snapshot"("organizationId", "metricType", "periodStart");

-- CreateIndex
CREATE UNIQUE INDEX "integration_metric_snapshot_integrationResourceId_metricTyp_key" ON "integration_metric_snapshot"("integrationResourceId", "metricType", "periodStart", "periodEnd");

-- CreateIndex
CREATE INDEX "whatsapp_conversation_organizationId_status_lastMessageAt_idx" ON "whatsapp_conversation"("organizationId", "status", "lastMessageAt");

-- CreateIndex
CREATE INDEX "whatsapp_conversation_leadId_idx" ON "whatsapp_conversation"("leadId");

-- CreateIndex
CREATE UNIQUE INDEX "whatsapp_message_providerMessageId_key" ON "whatsapp_message"("providerMessageId");

-- CreateIndex
CREATE INDEX "whatsapp_message_conversationId_createdAt_idx" ON "whatsapp_message"("conversationId", "createdAt");

-- CreateIndex
CREATE INDEX "whatsapp_message_status_createdAt_idx" ON "whatsapp_message"("status", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "plan_code_key" ON "plan"("code");

-- CreateIndex
CREATE INDEX "plan_price_planId_status_effectiveFrom_idx" ON "plan_price"("planId", "status", "effectiveFrom");

-- CreateIndex
CREATE UNIQUE INDEX "plan_entitlement_planId_featureCode_key" ON "plan_entitlement"("planId", "featureCode");

-- CreateIndex
CREATE INDEX "subscription_organizationId_status_idx" ON "subscription"("organizationId", "status");

-- CreateIndex
CREATE INDEX "subscription_status_currentPeriodEnd_idx" ON "subscription"("status", "currentPeriodEnd");

-- CreateIndex
CREATE UNIQUE INDEX "usage_record_idempotencyKey_key" ON "usage_record"("idempotencyKey");

-- CreateIndex
CREATE INDEX "usage_record_organizationId_featureCode_periodStart_periodE_idx" ON "usage_record"("organizationId", "featureCode", "periodStart", "periodEnd");

-- CreateIndex
CREATE INDEX "usage_record_occurredAt_idx" ON "usage_record"("occurredAt");

-- CreateIndex
CREATE INDEX "payment_customer_organizationId_status_idx" ON "payment_customer"("organizationId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "payment_customer_provider_externalCustomerId_key" ON "payment_customer"("provider", "externalCustomerId");

-- CreateIndex
CREATE UNIQUE INDEX "payment_idempotencyKey_key" ON "payment"("idempotencyKey");

-- CreateIndex
CREATE INDEX "payment_organizationId_status_createdAt_idx" ON "payment"("organizationId", "status", "createdAt");

-- CreateIndex
CREATE INDEX "payment_paymentCustomerId_idx" ON "payment"("paymentCustomerId");

-- CreateIndex
CREATE UNIQUE INDEX "payment_provider_externalPaymentId_key" ON "payment"("provider", "externalPaymentId");

-- CreateIndex
CREATE INDEX "invoice_organizationId_status_issuedAt_idx" ON "invoice"("organizationId", "status", "issuedAt");

-- CreateIndex
CREATE UNIQUE INDEX "invoice_organizationId_invoiceNumber_key" ON "invoice"("organizationId", "invoiceNumber");

-- CreateIndex
CREATE INDEX "invoice_line_invoiceId_idx" ON "invoice_line"("invoiceId");

-- CreateIndex
CREATE INDEX "invoice_line_relatedSubscriptionId_idx" ON "invoice_line"("relatedSubscriptionId");

-- CreateIndex
CREATE INDEX "payment_allocation_invoiceId_idx" ON "payment_allocation"("invoiceId");

-- CreateIndex
CREATE UNIQUE INDEX "payment_allocation_paymentId_invoiceId_key" ON "payment_allocation"("paymentId", "invoiceId");

-- CreateIndex
CREATE INDEX "payment_provider_event_processingStatus_receivedAt_idx" ON "payment_provider_event"("processingStatus", "receivedAt");

-- CreateIndex
CREATE INDEX "payment_provider_event_relatedPaymentId_idx" ON "payment_provider_event"("relatedPaymentId");

-- CreateIndex
CREATE UNIQUE INDEX "payment_provider_event_provider_externalEventId_key" ON "payment_provider_event"("provider", "externalEventId");

-- CreateIndex
CREATE INDEX "service_inquiry_status_createdAt_idx" ON "service_inquiry"("status", "createdAt");

-- CreateIndex
CREATE INDEX "service_inquiry_phone_idx" ON "service_inquiry"("phone");

-- CreateIndex
CREATE INDEX "audit_log_organizationId_createdAt_idx" ON "audit_log"("organizationId", "createdAt");

-- CreateIndex
CREATE INDEX "audit_log_actorUserId_createdAt_idx" ON "audit_log"("actorUserId", "createdAt");

-- CreateIndex
CREATE INDEX "audit_log_entityType_entityId_idx" ON "audit_log"("entityType", "entityId");

-- CreateIndex
CREATE INDEX "audit_log_action_createdAt_idx" ON "audit_log"("action", "createdAt");

-- AddForeignKey
ALTER TABLE "session" ADD CONSTRAINT "session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "account" ADD CONSTRAINT "account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "platform_admin_access" ADD CONSTRAINT "platform_admin_access_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "platform_admin_access" ADD CONSTRAINT "platform_admin_access_grantedByUserId_fkey" FOREIGN KEY ("grantedByUserId") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "platform_admin_access" ADD CONSTRAINT "platform_admin_access_revokedByUserId_fkey" FOREIGN KEY ("revokedByUserId") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization" ADD CONSTRAINT "organization_ownerUserId_fkey" FOREIGN KEY ("ownerUserId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "business_profile" ADD CONSTRAINT "business_profile_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "business_profile" ADD CONSTRAINT "business_profile_logoAssetId_fkey" FOREIGN KEY ("logoAssetId") REFERENCES "media_asset"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "business_hours" ADD CONSTRAINT "business_hours_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "website" ADD CONSTRAINT "website_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "website" ADD CONSTRAINT "website_selectedTemplateReleaseId_fkey" FOREIGN KEY ("selectedTemplateReleaseId") REFERENCES "website_template_release"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "website" ADD CONSTRAINT "website_currentPublishedVersionId_fkey" FOREIGN KEY ("currentPublishedVersionId") REFERENCES "website_version"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "website_template_release" ADD CONSTRAINT "website_template_release_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES "website_template"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "website_draft" ADD CONSTRAINT "website_draft_websiteId_fkey" FOREIGN KEY ("websiteId") REFERENCES "website"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "website_draft" ADD CONSTRAINT "website_draft_templateReleaseId_fkey" FOREIGN KEY ("templateReleaseId") REFERENCES "website_template_release"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "website_draft" ADD CONSTRAINT "website_draft_updatedByUserId_fkey" FOREIGN KEY ("updatedByUserId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "website_version" ADD CONSTRAINT "website_version_websiteId_fkey" FOREIGN KEY ("websiteId") REFERENCES "website"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "website_version" ADD CONSTRAINT "website_version_templateReleaseId_fkey" FOREIGN KEY ("templateReleaseId") REFERENCES "website_template_release"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "website_version" ADD CONSTRAINT "website_version_publishedByUserId_fkey" FOREIGN KEY ("publishedByUserId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "website_version" ADD CONSTRAINT "website_version_sourceVersionId_fkey" FOREIGN KEY ("sourceVersionId") REFERENCES "website_version"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "website_domain" ADD CONSTRAINT "website_domain_websiteId_fkey" FOREIGN KEY ("websiteId") REFERENCES "website"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "catalogue_category" ADD CONSTRAINT "catalogue_category_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product" ADD CONSTRAINT "product_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product" ADD CONSTRAINT "product_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "catalogue_category"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_variant" ADD CONSTRAINT "product_variant_productId_fkey" FOREIGN KEY ("productId") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "salon_service" ADD CONSTRAINT "salon_service_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "salon_service" ADD CONSTRAINT "salon_service_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "catalogue_category"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_image" ADD CONSTRAINT "product_image_productId_fkey" FOREIGN KEY ("productId") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_image" ADD CONSTRAINT "product_image_mediaAssetId_fkey" FOREIGN KEY ("mediaAssetId") REFERENCES "media_asset"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "service_image" ADD CONSTRAINT "service_image_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "salon_service"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "service_image" ADD CONSTRAINT "service_image_mediaAssetId_fkey" FOREIGN KEY ("mediaAssetId") REFERENCES "media_asset"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "media_asset" ADD CONSTRAINT "media_asset_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "media_asset" ADD CONSTRAINT "media_asset_uploadedByUserId_fkey" FOREIGN KEY ("uploadedByUserId") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "media_variant" ADD CONSTRAINT "media_variant_mediaAssetId_fkey" FOREIGN KEY ("mediaAssetId") REFERENCES "media_asset"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead" ADD CONSTRAINT "lead_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead" ADD CONSTRAINT "lead_createdByUserId_fkey" FOREIGN KEY ("createdByUserId") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead_follow_up" ADD CONSTRAINT "lead_follow_up_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead_follow_up" ADD CONSTRAINT "lead_follow_up_leadId_fkey" FOREIGN KEY ("leadId") REFERENCES "lead"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead_follow_up" ADD CONSTRAINT "lead_follow_up_createdByUserId_fkey" FOREIGN KEY ("createdByUserId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead_note" ADD CONSTRAINT "lead_note_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead_note" ADD CONSTRAINT "lead_note_leadId_fkey" FOREIGN KEY ("leadId") REFERENCES "lead"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead_note" ADD CONSTRAINT "lead_note_createdByUserId_fkey" FOREIGN KEY ("createdByUserId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "availability_slot" ADD CONSTRAINT "availability_slot_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "availability_slot" ADD CONSTRAINT "availability_slot_createdByUserId_fkey" FOREIGN KEY ("createdByUserId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "booking" ADD CONSTRAINT "booking_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "booking" ADD CONSTRAINT "booking_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "salon_service"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "booking" ADD CONSTRAINT "booking_availabilitySlotId_fkey" FOREIGN KEY ("availabilitySlotId") REFERENCES "availability_slot"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "booking" ADD CONSTRAINT "booking_leadId_fkey" FOREIGN KEY ("leadId") REFERENCES "lead"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "booking_activity" ADD CONSTRAINT "booking_activity_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "booking_activity" ADD CONSTRAINT "booking_activity_bookingId_fkey" FOREIGN KEY ("bookingId") REFERENCES "booking"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "booking_activity" ADD CONSTRAINT "booking_activity_actorUserId_fkey" FOREIGN KEY ("actorUserId") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ai_content_generation" ADD CONSTRAINT "ai_content_generation_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ai_content_generation" ADD CONSTRAINT "ai_content_generation_createdByUserId_fkey" FOREIGN KEY ("createdByUserId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ai_content_generation" ADD CONSTRAINT "ai_content_generation_mediaAssetId_fkey" FOREIGN KEY ("mediaAssetId") REFERENCES "media_asset"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification" ADD CONSTRAINT "notification_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification" ADD CONSTRAINT "notification_recipientUserId_fkey" FOREIGN KEY ("recipientUserId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification_delivery" ADD CONSTRAINT "notification_delivery_notificationId_fkey" FOREIGN KEY ("notificationId") REFERENCES "notification"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "outbox_event" ADD CONSTRAINT "outbox_event_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "integration_account" ADD CONSTRAINT "integration_account_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "integration_account" ADD CONSTRAINT "integration_account_connectedByUserId_fkey" FOREIGN KEY ("connectedByUserId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "integration_credential" ADD CONSTRAINT "integration_credential_integrationAccountId_fkey" FOREIGN KEY ("integrationAccountId") REFERENCES "integration_account"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "integration_resource" ADD CONSTRAINT "integration_resource_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "integration_resource" ADD CONSTRAINT "integration_resource_integrationAccountId_fkey" FOREIGN KEY ("integrationAccountId") REFERENCES "integration_account"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "integration_sync_job" ADD CONSTRAINT "integration_sync_job_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "integration_sync_job" ADD CONSTRAINT "integration_sync_job_integrationAccountId_fkey" FOREIGN KEY ("integrationAccountId") REFERENCES "integration_account"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "integration_sync_job" ADD CONSTRAINT "integration_sync_job_integrationResourceId_fkey" FOREIGN KEY ("integrationResourceId") REFERENCES "integration_resource"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "integration_metric_snapshot" ADD CONSTRAINT "integration_metric_snapshot_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "integration_metric_snapshot" ADD CONSTRAINT "integration_metric_snapshot_integrationResourceId_fkey" FOREIGN KEY ("integrationResourceId") REFERENCES "integration_resource"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "whatsapp_conversation" ADD CONSTRAINT "whatsapp_conversation_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "whatsapp_conversation" ADD CONSTRAINT "whatsapp_conversation_leadId_fkey" FOREIGN KEY ("leadId") REFERENCES "lead"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "whatsapp_message" ADD CONSTRAINT "whatsapp_message_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "whatsapp_conversation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "whatsapp_message" ADD CONSTRAINT "whatsapp_message_mediaAssetId_fkey" FOREIGN KEY ("mediaAssetId") REFERENCES "media_asset"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "plan_price" ADD CONSTRAINT "plan_price_planId_fkey" FOREIGN KEY ("planId") REFERENCES "plan"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "plan_entitlement" ADD CONSTRAINT "plan_entitlement_planId_fkey" FOREIGN KEY ("planId") REFERENCES "plan"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription" ADD CONSTRAINT "subscription_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription" ADD CONSTRAINT "subscription_planId_fkey" FOREIGN KEY ("planId") REFERENCES "plan"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription" ADD CONSTRAINT "subscription_planPriceId_fkey" FOREIGN KEY ("planPriceId") REFERENCES "plan_price"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "usage_record" ADD CONSTRAINT "usage_record_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_customer" ADD CONSTRAINT "payment_customer_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment" ADD CONSTRAINT "payment_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment" ADD CONSTRAINT "payment_paymentCustomerId_fkey" FOREIGN KEY ("paymentCustomerId") REFERENCES "payment_customer"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoice" ADD CONSTRAINT "invoice_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoice_line" ADD CONSTRAINT "invoice_line_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "invoice"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoice_line" ADD CONSTRAINT "invoice_line_relatedSubscriptionId_fkey" FOREIGN KEY ("relatedSubscriptionId") REFERENCES "subscription"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_allocation" ADD CONSTRAINT "payment_allocation_paymentId_fkey" FOREIGN KEY ("paymentId") REFERENCES "payment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_allocation" ADD CONSTRAINT "payment_allocation_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "invoice"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_provider_event" ADD CONSTRAINT "payment_provider_event_relatedPaymentId_fkey" FOREIGN KEY ("relatedPaymentId") REFERENCES "payment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_log" ADD CONSTRAINT "audit_log_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_log" ADD CONSTRAINT "audit_log_actorUserId_fkey" FOREIGN KEY ("actorUserId") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;


-- =========================================================
-- CONNECTIVE: DATABASE CHECK CONSTRAINTS
-- =========================================================

-- 1. Product pricing
ALTER TABLE "product"
ADD CONSTRAINT "product_prices_nonnegative_check"
CHECK (
  ("basePrice" IS NULL OR "basePrice" >= 0)
  AND ("minimumPrice" IS NULL OR "minimumPrice" >= 0)
  AND ("maximumPrice" IS NULL OR "maximumPrice" >= 0)
  AND (
    "minimumPrice" IS NULL
    OR "maximumPrice" IS NULL
    OR "minimumPrice" <= "maximumPrice"
  )
);

-- 2. Product variant override price
ALTER TABLE "product_variant"
ADD CONSTRAINT "product_variant_priceOverride_nonnegative_check"
CHECK ("priceOverride" IS NULL OR "priceOverride" >= 0);

-- 3. Salon service pricing
ALTER TABLE "salon_service"
ADD CONSTRAINT "salon_service_prices_nonnegative_check"
CHECK (
  ("basePrice" IS NULL OR "basePrice" >= 0)
  AND ("minimumPrice" IS NULL OR "minimumPrice" >= 0)
  AND ("maximumPrice" IS NULL OR "maximumPrice" >= 0)
  AND (
    "minimumPrice" IS NULL
    OR "maximumPrice" IS NULL
    OR "minimumPrice" <= "maximumPrice"
  )
);

-- 4. Website template release version
ALTER TABLE "website_template_release"
ADD CONSTRAINT "website_template_release_version_positive_check"
CHECK ("versionNumber" > 0);

-- 5. Website version number
ALTER TABLE "website_version"
ADD CONSTRAINT "website_version_version_positive_check"
CHECK ("versionNumber" > 0);

-- 6. Website draft revision
ALTER TABLE "website_draft"
ADD CONSTRAINT "website_draft_revision_positive_check"
CHECK ("revisionNumber" > 0);

-- 7. Media asset metadata
ALTER TABLE "media_asset"
ADD CONSTRAINT "media_asset_metadata_nonnegative_check"
CHECK (
  "fileSizeBytes" >= 0
  AND ("width" IS NULL OR "width" >= 0)
  AND ("height" IS NULL OR "height" >= 0)
);

-- 8. Media variant metadata
ALTER TABLE "media_variant"
ADD CONSTRAINT "media_variant_metadata_nonnegative_check"
CHECK (
  "fileSizeBytes" >= 0
  AND ("width" IS NULL OR "width" >= 0)
  AND ("height" IS NULL OR "height" >= 0)
);

-- 9. Availability slot time range
ALTER TABLE "availability_slot"
ADD CONSTRAINT "availability_slot_time_range_check"
CHECK ("endsAt" > "startsAt");

-- 10. Booking time range
ALTER TABLE "booking"
ADD CONSTRAINT "booking_time_range_check"
CHECK ("endsAt" > "startsAt");

-- 11. Plan price
ALTER TABLE "plan_price"
ADD CONSTRAINT "plan_price_amount_nonnegative_check"
CHECK ("amount" >= 0);

-- 12. Plan entitlement limit
ALTER TABLE "plan_entitlement"
ADD CONSTRAINT "plan_entitlement_limit_nonnegative_check"
CHECK ("limitValue" IS NULL OR "limitValue" >= 0);

-- 13. Payment amount
ALTER TABLE "payment"
ADD CONSTRAINT "payment_amount_nonnegative_check"
CHECK ("amount" >= 0);

-- 14. Invoice amounts
ALTER TABLE "invoice"
ADD CONSTRAINT "invoice_amounts_nonnegative_check"
CHECK (
  "subtotalAmount" >= 0
  AND "taxAmount" >= 0
  AND "totalAmount" >= 0
);

-- 15. Invoice line amounts
ALTER TABLE "invoice_line"
ADD CONSTRAINT "invoice_line_amounts_nonnegative_check"
CHECK (
  "quantity" > 0
  AND "unitAmount" >= 0
  AND "taxAmount" >= 0
  AND "lineTotal" >= 0
);

-- 16. Payment allocation amount
ALTER TABLE "payment_allocation"
ADD CONSTRAINT "payment_allocation_amount_nonnegative_check"
CHECK ("allocatedAmount" >= 0);

-- 17. Usage quantity
ALTER TABLE "usage_record"
ADD CONSTRAINT "usage_record_quantity_nonnegative_check"
CHECK ("quantity" >= 0);

-- 18. Outbox event attempts
ALTER TABLE "outbox_event"
ADD CONSTRAINT "outbox_event_attempts_nonnegative_check"
CHECK ("attemptCount" >= 0);

-- 19. Notification delivery attempts
ALTER TABLE "notification_delivery"
ADD CONSTRAINT "notification_delivery_attempts_nonnegative_check"
CHECK ("attemptCount" >= 0);

-- 20. Integration sync attempts
ALTER TABLE "integration_sync_job"
ADD CONSTRAINT "integration_sync_job_attempts_nonnegative_check"
CHECK ("attemptCount" >= 0);

-- 21. Payment provider event attempts
ALTER TABLE "payment_provider_event"
ADD CONSTRAINT "payment_provider_event_attempts_nonnegative_check"
CHECK ("attemptCount" >= 0);

-- 22. Salon service duration
ALTER TABLE "salon_service"
ADD CONSTRAINT "salon_service_duration_positive_check"
CHECK ("durationMinutes" IS NULL OR "durationMinutes" > 0);

-- 23. Plan price validity period
ALTER TABLE "plan_price"
ADD CONSTRAINT "plan_price_validity_period_check"
CHECK ("effectiveUntil" IS NULL OR "effectiveUntil" > "effectiveFrom");

-- 24. Subscription billing period
ALTER TABLE "subscription"
ADD CONSTRAINT "subscription_billing_period_check"
CHECK ("currentPeriodEnd" > "currentPeriodStart");

-- 25. Usage reporting period
ALTER TABLE "usage_record"
ADD CONSTRAINT "usage_record_period_check"
CHECK ("periodEnd" > "periodStart");

-- 26. Integration metric period
ALTER TABLE "integration_metric_snapshot"
ADD CONSTRAINT "integration_metric_period_check"
CHECK ("periodEnd" > "periodStart");

