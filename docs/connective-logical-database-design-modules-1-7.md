# Connective --- Logical Database Design (Modules 1--7)

**Document type:** Logical database design\
**Status:** Working design record; no Prisma models or migrations have
been created\
**Scope:** Modules 1 through 7\
**Product:** Connective\
**Last updated:** 2 November 2026

------------------------------------------------------------------------

## 1. Purpose and design principles

This document records the agreed and proposed logical database design
for Connective through Module 7. It is intended for the repository's
`docs/` directory and should serve as the source of truth when the
project later moves from logical design to Prisma schema implementation.

### 1.1 Architecture

-   Connective is a modular monolith, not a microservices architecture.
-   Backend API: Node.js, Express and TypeScript.
-   Database: PostgreSQL, accessed by the backend through Prisma.
-   Merchant application: React Native, Expo and TypeScript.
-   Public merchant websites: Next.js, React and TypeScript.
-   Super Admin dashboard: separate Next.js application.
-   One shared PostgreSQL database serves all organizations; there is no
    separate database per merchant.
-   The browser-facing public website must not connect directly to
    PostgreSQL.
-   Better Auth is used for authentication, with one Better Auth
    instance in `apps/api`; mobile and Super Admin apps act as clients.
-   Public website visitors do not need Connective accounts to submit
    enquiries or book salon appointments.
-   Local development and hosted production use separate databases. No
    staging database is currently planned.

### 1.2 Logical-design workflow

The modules below are conceptual groupings, not separate PostgreSQL
schemas or services. The database design is being approved module by
module before Prisma models, migrations or database implementation are
written.

When moving to implementation: - Confirm remaining open decisions listed
below. - Validate current Better Auth and Prisma compatibility against
the installed versions and official documentation. - Enforce
authorization and tenant isolation on the server. - Use database
constraints and transactions for integrity-critical operations. - Keep
file bytes in object storage and store metadata/references in
PostgreSQL.

### 1.3 Cross-cutting requirements

**Tenant isolation:** Every organization-owned record must be scoped to
the correct organization. The backend must authorize access server-side;
knowing a record ID is not sufficient authorization.

**Time and timezone:** Store actual instants consistently in UTC using
PostgreSQL `timestamptz` where appropriate. Store each organization's
IANA timezone separately, such as `Asia/Kolkata`. Recurring business
hours and other wall-clock schedules use local times tied to that
timezone; `timestamptz` alone does not preserve the timezone name.

**Phone numbers:** Store phone numbers as text, preserving `+` and
leading zeroes. Normalize to international format where possible, for
example `+919876543210`.

**Public form protection:** Anti-bot protection is mandatory for public
forms in V1. Cloudflare Turnstile is preferred. The backend must verify
tokens using Siteverify; frontend validation alone is insufficient.
Public submission endpoints also require rate limiting. Secrets stay
server-side, and only verified submissions enter the normal
processing/notification flow. Turnstile tokens are single-use and expire
after five minutes.

**Soft deletion and retention:** Where specified, archive or soft-delete
records rather than immediately destroying historical data. Physical
cleanup must respect references and retention requirements.

**No implementation yet:** Entity and field lists below are logical
proposals, not Prisma code or a claim that database tables already
exist.

------------------------------------------------------------------------

## 2. Overall module map

The planned database is divided into 14 logical modules:

1.  Authentication & Access Control
2.  Organizations & Business Profiles
3.  Websites & Publishing
4.  Catalogue & Category-Specific Data
5.  Media & File Assets
6.  Leads & CRM
7.  Salon Availability & Bookings
8.  AI Studio & Content Management
9.  Notifications & Devices
10. Integrations & Social Hub
11. Plans, Subscriptions, Entitlements & Usage
12. Payments & Billing Records
13. Managed Services & Quotations
14. Analytics, Audit & Operational History

This document records Modules 1--7 only.

------------------------------------------------------------------------

# Module 1 --- Authentication & Access Control

**Status: Logical design approved.**

## 3. Purpose

Manage identities, sessions, login methods and separate Super Admin
authorization. Better Auth owns its core authentication records;
Connective should not duplicate those records in custom tables.

## 3.1 Authentication requirements

At launch, support: - Phone OTP sign-in using SMS. - Email and
password. - Google sign-in. - Required email verification through a
verification link. - Phone verification for phone-OTP login. - No Super
Admin MFA in the initial MVP. - No merchant self-service account
deletion in V1.

## 3.2 Entities

### Better Auth `User`

Core identity/profile record and email-verification state. Phone fields
may be added through supported Better Auth schema extensions if required
by the selected version.

### Better Auth `Session`

Authenticated session records managed by Better Auth.

### Better Auth `Account`

Password credentials and linked OAuth identities managed by Better Auth.

### Better Auth `Verification`

Verification workflows, including email verification links and other
verification flows supported by the installed Better Auth version.

### `PlatformAdminAccess` --- custom record

Grants or revokes Super Admin authorization independently of merchant
ownership.

Proposed logical attributes: - Identifier. - User reference. -
Active/revoked state. - Grant/revocation timestamps. - Actor and reason
where applicable.

Exact fields remain an implementation detail.

### `Organization` --- defined in Module 2

Each organization has a required owner user reference. A unique
constraint on the owner reference means a user can own at most one
organization.

No `Membership` entity is needed in V1 because there is one owner per
organization and no merchant staff roles.

## 3.3 Business rules

-   Every merchant organization has exactly one valid owner.
-   A user can own at most one organization.
-   Merchant access requires authentication, verified email and
    ownership authorization for organization resources.
-   Phone OTP login requires a verified phone number associated with the
    account.
-   Google sign-in must not silently merge identities solely because
    email strings match; a secure account-linking policy is required.
-   Super Admin access requires an active `PlatformAdminAccess` record
    and server-side authorization on protected API requests.
-   Admin access must be provisioned through a controlled, audited
    process, not public signup.
-   OTP abuse protection, rate limiting and generic responses to reduce
    account enumeration are required.
-   No merchant self-service account deletion in V1. Exceptional
    administrative deletion and retention policy are separate concerns.
-   OTP verification and email verification are distinct processes.

## 3.4 Open implementation decisions

These do not prevent logical design approval: - SMS provider, supported
regions and cost. - Whether phone OTP can both create an account and log
in. Recommended: allow both, while requiring email verification before
normal merchant access. - Secure Google/password identity-linking
behavior. - Email provider, verification-link expiry, resend rules and
redirect URLs. - Admin provisioning process. - Exact Better Auth
compatibility for phone OTP, email/password, Google and mandatory email
verification, to be checked against the installed version.

------------------------------------------------------------------------

# Module 2 --- Organizations & Business Profiles

**Status: Logical design approved.**

## 4. Purpose

Represent the merchant business independently from its owner account and
store business profile, category, timezone and opening hours.

## 4.1 V1 business categories

Only these categories are in scope: - Clothing. - Salon/Spa/Wellness.

Business category is fixed after onboarding. Changing it requires an
authorized support/admin process and must be audited.

## 4.2 `Organization`

Proposed logical attributes: - `id`: stable unique identifier. -
`ownerUserId`: required reference to Better Auth `User`; unique. -
`businessName`: required. - `businessCategory`: required; Clothing or
Salon/Spa/Wellness. - `status`: business lifecycle/suspension state. -
`onboardingStatus`: setup progress, distinct from business status. -
`timezone`: required IANA timezone, e.g. `Asia/Kolkata`. - `createdAt`,
`updatedAt`.

### Rules

-   Exactly one owner per organization; one organization maximum per
    user.
-   `status` and `onboardingStatus` are separate. A business may be
    active while optional setup remains incomplete, or onboarded and
    later suspended.
-   Suspension/reactivation must be enforced by the API. Exact effects
    on public websites, enquiries and bookings must be handled by the
    relevant modules.
-   Category changes require authorization and audit history, and must
    account for incompatible catalogue or website content.
-   Onboarding is complete once required business details and category
    are provided; website setup continues separately.

## 4.3 `BusinessProfile`

One profile per organization.

Proposed logical attributes: - `organizationId`: required, unique
reference to `Organization`. - `displayName`: required; may initially
match `businessName`. - `description`: optional. - `logoAssetId`:
optional reference to a Module 5 media asset. - `contactEmail`: optional
public contact email, separate from login email. - `contactPhone`:
optional public phone number. - `addressLine1`, `addressLine2`, `city`,
`state`, `postalCode`: optional. - `countryCode`: optional unless an
address is provided; if address details exist, country code will likely
be required. - `createdAt`, `updatedAt`.

Physical address is optional during onboarding. Some later features may
require location information. Logo bytes are stored in object storage;
PostgreSQL stores the media reference.

## 4.4 `BusinessHours`

Separate records allow multiple opening periods per weekday.

Proposed logical attributes: - `id`. - `organizationId`. -
`dayOfWeek`. - `opensAt`, `closesAt`: local wall-clock times, not UTC
timestamps.

### Rules

-   Multiple intervals per weekday are allowed.
-   Overnight periods are supported, e.g. Monday 20:00 to Tuesday 02:00.
-   The interpretation of overnight intervals and overlap prevention
    across midnight must be implemented carefully.
-   No holiday overrides or temporary closures in V1. No intervals for a
    weekday means closed.
-   Overlapping opening intervals must be prevented.
-   Business hours and appointment instants use the organization's
    timezone correctly.

## 4.5 Cross-module dependencies

-   Module 3: onboarding completion is independent from website setup
    and publishing.
-   Module 4: shared catalogue model with category-specific data.
-   Module 7: salon booking availability uses business timezone and
    opening hours.
-   Module 9: notifications use real event timestamps and appropriate
    display timezones.
-   Module 14: category changes, suspension and reactivation are
    audited.
-   Organization-owned records must be tenant-isolated.

------------------------------------------------------------------------

# Module 3 --- Websites & Publishing

**Status: Consolidated logical design; explicit final sign-off remains
pending.**

## 5. Product approach

Connective is an AI-assisted website generator using controlled,
predefined React templates---not a drag-and-drop site builder and not an
arbitrary code generator.

V1 intends to provide one master template per category: - One Clothing
template. - One Salon/Spa/Wellness template.

Additional templates may be introduced later based on usage and demand.
The exact fixed page names and required content for each category remain
to be finalized alongside Module 4.

## 5.1 Merchant workflow

1.  Merchant provides basic business details and chooses the predefined
    category template.
2.  AI asks relevant questions and generates content into supported
    fields.
3.  Merchant edits content manually or asks AI to rewrite selected
    fields.
4.  Merchant previews the website on desktop and mobile using the same
    frontend components used by the live website.
5.  Merchant publishes to a Connective subdomain; an eligible plan can
    use a custom domain.
6.  Editing a draft does not change the live website until publication.

The layout and structure are controlled by developers. The merchant
changes content and supported appearance settings, not arbitrary page
structure or generated website code.

## 5.2 Appearance and CTA settings

Four supported appearance controls: 1. Base theme: Light or Dark. 2.
Accent color: chosen from a predefined accessible palette. 3. Typography
preset: Classic/Elegant, Modern/Clean, or Bold/Minimal. 4. Hero style:
Banner (background image with centered overlay text) or Split (text
left, square image right).

Primary CTA options: - WhatsApp enquiry. - Book appointment. - View
catalogue.

CTA options must be validated against category and subscription
entitlements. Booking is available only when the plan and booking
feature allow it. A catalogue CTA must lead to a real catalogue.

## 5.3 Proposed entities

### `Website`

-   `id`.
-   Unique `organizationId` reference.
-   `selectedTemplateReleaseId`.
-   `status`.
-   Nullable `currentPublishedVersionId`.
-   Timestamps.

One website per organization.

### `WebsiteTemplate`

-   `id`.
-   `name`.
-   `slug`.
-   `businessCategory`.
-   `status`.
-   Timestamps.

### `WebsiteTemplateRelease`

-   `id`.
-   `templateId`.
-   `versionNumber`.
-   `status`.
-   `createdAt` and release metadata.

Template releases pin websites to a specific template version. Template
upgrades are deliberate, not automatic.

### `WebsiteDraft`

-   `id`.
-   Unique `websiteId`.
-   `templateReleaseId`.
-   `contentDocument`: structured content and appearance configuration.
-   `revisionNumber`.
-   `updatedByUserId`.
-   `updatedAt`.

A website has one editable draft.

### `WebsiteVersion`

-   `id`.
-   `websiteId`.
-   `versionNumber`.
-   `templateReleaseId`.
-   `contentSnapshot`.
-   `publishedAt`.
-   `publishedByUserId`.
-   Optional `sourceVersionId`.

Published versions are immutable to merchants. Rollback restores an
older version into a new draft, which must be previewed and republished
as a new version.

### `WebsiteDomain`

-   `id`.
-   `websiteId`.
-   `domainName`.
-   `domainType`.
-   `verificationStatus`.
-   `activationStatus`.
-   `verifiedAt`.
-   Timestamps.

Global hostname uniqueness is required. Each website can have at most
one Connective subdomain and one custom domain.

### `WebsitePreviewSession`

Optional; omitted for MVP. Authenticated preview is sufficient.
Shareable preview tokens are deferred.

## 5.4 Content, publishing and domains

-   Structured website content is stored in PostgreSQL, likely using
    JSONB where appropriate.
-   Fixed template page keys and required content are validated by the
    application.
-   Separate page tables are not required for V1 if page content remains
    within a structured document.
-   SEO content is versioned and included in published snapshots.
-   Preview is authenticated/authorized and draft-only; drafts must not
    be publicly served.
-   The merchant chooses a Connective subdomain slug, with availability
    checks and a database uniqueness constraint as final protection.
-   Eligible merchants may configure one custom domain.
-   Unpublishing retains versions and domain records but stops serving
    the public site.
-   Template changes preserve/map compatible content and require review
    before republishing.
-   Publication should be atomic.

## 5.5 Open decisions and dependencies

-   Explicit final sign-off on the consolidated Module 3 design is still
    pending.
-   Confirm whether live catalogue changes appear immediately without
    republishing website content. Recommended: catalogue records update
    live independently; website content, layout settings and SEO
    snapshots require publication.
-   Exact fixed page names and content are to be finalized with Module
    4.
-   Page path-change behavior and redirects remain to be decided.
-   Template content compatibility/migration rules need definition.
-   Module 5 supplies media references; Module 8 manages AI-generated
    content; Module 11 controls custom-domain entitlements; Module 14
    audits publication and domain changes.

------------------------------------------------------------------------

# Module 4 --- Catalogue & Category-Specific Data

**Status: Logical design finalized.**

## 6. Purpose and scope

The catalogue supports products for clothing merchants and services for
Salon/Spa/Wellness merchants.

The catalogue is for display and enquiry collection only. V1 does not
include cart, checkout, orders or inventory tracking. All prices are in
INR.

## 6.1 `CatalogueCategory`

Merchant-specific categories with default categories represented as
seeded records in the same entity.

Proposed attributes: - `id`. - `organizationId`. - `name`. - `slug`. -
`catalogueType`: product or service. - `sortOrder`. - `status`. -
Timestamps.

Rules: - Category name/slug uniqueness is scoped by organization and
catalogue type. - Merchants can create, rename and deactivate
categories. - Deactivating a category does not delete its items. -
Default categories and merchant-created categories use the same
conceptual model.

## 6.2 `Product`

Proposed attributes: - `id`. - `organizationId`. - Optional
`categoryId`. - `name`. - `slug`. - `description`. - `pricingType`. -
Applicable price fields: base, minimum and/or maximum as appropriate to
the pricing type. - `availabilityStatus`: Draft, Available or
Unavailable. - `sortOrder`. - Timestamps. - Archive marker.

Products do not track quantities or inventory. Merchants manually mark
them available or unavailable.

## 6.3 `ProductVariant`

Variants are optional; a simple product may have none.

Proposed attributes: - `id`. - `productId`. - Optional size, colour and
SKU. - Optional `priceOverride`. - `availabilityStatus`. - Timestamps
and archive marker.

Variant price inherits the product's price by default; a variant may
override it. If variants have actual prices, the displayed price range
should be derived from those prices to avoid conflicting sources.

## 6.4 `SalonService`

Proposed attributes: - `id`. - `organizationId`. - Optional
`categoryId`. - `name`. - `slug`. - `description`. - `pricingType`. -
Applicable price fields. - Optional `durationMinutes`. -
`availabilityStatus`: Draft, Available or Unavailable. - `sortOrder`. -
Timestamps and archive marker.

Service duration is optional for display but required before enabling
online booking.

## 6.5 `ProductImage` and `ServiceImage`

Separate association entities link catalogue records to Module 5 media
assets.

Proposed attributes: - Association identifier. - Product or service
reference. - `mediaAssetId`. - `sortOrder`. - Optional image role, such
as primary or gallery.

## 6.6 Pricing and business rules

Pricing modes: - `FIXED`. - `STARTING_AT`. - `RANGE`.

Rules: - Prices are in INR only. - Prices must be non-negative; minimum
must not exceed maximum. - No cart, checkout, orders, inventory ledger
or stock quantities in V1. - Products and services must belong to an
organization. - A category must belong to the same organization and
match product/service type. - Slugs are unique within the organization's
appropriate catalogue scope. - Only the appropriate business category
can create products or services. - Inactive entries are not publicly
displayed. - Subscription limits are enforced through Module 11. - Media
references must belong to the same organization. - Archived records
should not block slug reuse indefinitely, subject to
historical-reference requirements.

## 6.7 Publishing dependency

Recommended behavior, still to be explicitly confirmed in Module 3
sign-off: published website template/content/appearance snapshots remain
immutable, while catalogue record changes can appear live without
republishing the entire website.

------------------------------------------------------------------------

# Module 5 --- Media & File Assets

**Status: Logical design finalized.**

## 7. Purpose and supported media

Supported file types: - Images. - Audio recordings.

Files are stored in object storage; PostgreSQL stores metadata and
references. The storage provider remains provider-agnostic for now.

Assets can be public or private and can be reused within the same
organization.

## 7.1 `MediaAsset`

Proposed attributes: - `id`. - Required `organizationId`. -
`uploadedByUserId`, where applicable. - `storageKey`:
provider-independent internal object reference. - `originalFileName`. -
Validated `mimeType`. - `fileSizeBytes`. - `mediaType`: image or
audio. - Optional `width`, `height`. - `processingStatus`. -
`accessLevel`: public or private. - `createdAt`, `updatedAt`. - Nullable
`deletedAt`.

## 7.2 `MediaVariant`

Proposed attributes: - `id`. - `mediaAssetId`. - `variantType`, such as
thumbnail, card, medium or large. - `storageKey`. - `mimeType`. -
`fileSizeBytes`. - `width`, `height`. - `createdAt`.

An asset may have multiple variants. Audio assets do not have image
variants.

## 7.3 Relationships

-   Module 2: `BusinessProfile.logoAssetId`.
-   Module 3: website imagery.
-   Module 4: `ProductImage` and `ServiceImage`.
-   Module 6: private call recordings attached to leads.

## 7.4 Processing and security rules

-   Asset ID and storage key are internal references; do not rely on a
    permanent public URL.
-   Server-side tenant authorization is required; cross-organization
    asset reuse is not allowed.
-   Processing lifecycle: `PENDING_UPLOAD` → `UPLOADED` → `PROCESSING` →
    `READY`, with a `FAILED` state for errors.
-   Deletion/cleanup is a separately tracked, retryable process.
-   Only `READY` assets can be attached to business records.
-   Public assets are delivered publicly only when intended and approved
    for a published website.
-   Private recordings require authorized access and short-lived signed
    URLs where appropriate.
-   Validate actual file content/type and size; do not trust file
    extensions or client-supplied MIME types.
-   Keep storage secrets server-side and use short-lived upload
    authorization.
-   Automatically validate, optimize and create responsive image
    variants.
-   Soft deletion blocks new use but does not destroy files still
    referenced by published websites or other valid records.
-   Cleanup occurs only when no valid references or retention
    requirements remain; failed cleanup must be retryable.
-   Upload, deletion and sensitive access should be audited through
    Module 14.

## 7.5 Deferred implementation choices

Exact image formats, codecs, size limits, variant dimensions,
storage/CDN provider, retention period and security scanning remain
implementation decisions. Storage quotas are finalized in Module 11.

------------------------------------------------------------------------

# Module 6 --- Leads & CRM

**Status: Logical design approved.**

## 8. Purpose and lead creation

The CRM manages potential customers and individual enquiries for both
clothing and salon businesses.

Lead creation sources in V1: - Public website enquiries. - Merchant
manual entry.

Automatic ingestion from WhatsApp, phone systems or other external
integrations is not included in this initial decision. A merchant can
manually record an enquiry that arrived by phone, WhatsApp, walk-in,
Instagram or another channel.

Every enquiry creates a separate lead. Phone/email matches do not
automatically merge records. A future duplicate warning may be added
without automatically merging or rejecting an enquiry.

A separate `Customer`/`Contact` entity is not required in V1.

## 8.1 `Lead`

Proposed logical attributes: - `id`. - `organizationId`. -
`customerName`: optional if not provided. - `phone`: optional
individually. - `email`: optional individually. - `message`: original
enquiry or summary. - `source`: Website or Manual. - `contactChannel`:
Website form, phone, WhatsApp, walk-in, Instagram or other. -
`status`. - `createdByUserId`, where applicable. - `createdAt`,
`updatedAt`. - `archivedAt`, optional.

At least one of phone or email is required for merchant-entered leads.
Public website forms validate against their configured fields; those
fields may differ, but the backend must validate input consistently.

The distinction is: - `source` = how the lead record entered
Connective. - `contactChannel` = how the customer communicated with the
business.

## 8.2 Fixed five-status pipeline

Statuses: 1. `NEW`: enquiry received but not yet handled. 2.
`CONTACTED`: merchant has contacted the customer. 3. `FOLLOW_UP`:
further action is needed. 4. `CONVERTED`: desired outcome achieved. 5.
`LOST`: opportunity did not proceed.

The pipeline is fixed for V1. Leads can move between active stages as
needed. Converted and Lost leads can be reopened to an active status.
Historical status changes must be preserved.

Lost reason is optional. If a lead is reopened and later marked Lost
again, the latest outcome/reason must be handled without erasing prior
history.

## 8.3 `LeadFollowUp`

Separate records allow multiple reminders and preserve
completed/cancelled follow-ups.

Proposed attributes: - `id`. - `organizationId`. - `leadId`. -
`title`. - `dueAt`: actual instant. - `status`: Pending, Completed or
Cancelled. - `completedAt`. - `createdByUserId`. - `createdAt`,
`updatedAt`.

Rules: - Display due times in the organization's configured timezone. -
A follow-up must reference a lead in the same organization. - Completing
a follow-up does not automatically convert the lead. - Archiving/losing
a lead must not silently erase follow-up history. - A pending reminder
can be cancelled. - Notification delivery is handled by Module 9.

## 8.4 `LeadNote`

Private internal notes.

Proposed attributes: - `id`. - `organizationId`. - `leadId`. -
`createdByUserId`. - `content`. - `createdAt`, `updatedAt`. -
`deletedAt`, optional.

Notes must never appear on public websites or customer-facing responses.
Access requires authorization against the owning organization. V1
supports multiple notes, editing and soft deletion; separate note
categories/tags are not required.

## 8.5 `LeadRecording`

Links a lead to an existing private audio `MediaAsset` from Module 5.

Proposed attributes: - `id`. - `organizationId`. - `leadId`. -
`mediaAssetId`. - `uploadedByUserId`. - `createdAt`. - `deletedAt`,
optional.

Rules: - Only private, ready-to-use audio assets may be attached. -
Lead, asset and attachment must belong to the same organization. -
Access requires server-side authorization; short-lived signed URLs
should be used where appropriate. - Removing an attachment does not
automatically delete a media asset still referenced elsewhere. - Pro
recording entitlement is enforced server-side through Module 11. -
Consent, lawful recording practices and retention policies must be
addressed in product and operational policy.

## 8.6 `LeadActivity`

Preserves the lead timeline without replacing the underlying records.

Proposed attributes: - `id`. - `organizationId`. - `leadId`. -
`actorUserId`, nullable for system events. - `activityType`, such as
lead creation, status change, note added, follow-up completed or
recording attached. - `details`: structured event data where needed. -
`createdAt`.

For status changes, details preserve previous and new status. Lost
reason can be recorded where relevant. Important changes should be
recorded in the same database transaction as the corresponding change
where practical. Avoid copying full private notes or recording contents
into activity details.

## 8.7 Archiving and cross-module rules

-   Normal merchant workflow archives leads rather than hard-deleting
    them.
-   Archived leads are hidden from the default active CRM view but
    remain available in an archived view.
-   Notes, follow-ups, recordings and activity history must not
    disappear just because a lead is archived.
-   Every lead-related record is scoped to the organization.
-   Module 4 catalogue associations may be useful later but are not
    mandatory.
-   Salon appointment requests are Module 7 booking records; general
    questions remain leads. A lead may optionally link to a booking, but
    booking does not require a lead.
-   Module 9 delivers reminders.
-   Module 11 enforces plan limits and Pro recording entitlements.
-   Module 14 covers relevant audit and sensitive-access history.

------------------------------------------------------------------------

# Module 7 --- Salon Availability & Bookings

**Status: Logical design approved.**

## 9. Scope and agreed workflow

This module provides online appointment booking for Salon/Spa/Wellness
businesses.

Agreed V1 decisions: - Booking is instant-confirmation: confirm only if
the interval remains available. - Merchants manually create
date-specific availability, typically managing the upcoming week. - One
service per booking. - Only the merchant can cancel. - Only the merchant
can reschedule. - Confirmed bookings are protected from availability
edits that would invalidate them. - Clothing businesses do not use this
booking workflow in V1. - Online booking and manual slot management are
plan-gated features; salon online booking is a Pro feature.

## 9.1 `AvailabilitySlot`

Represents a specific interval the salon offers on a particular date.

Proposed attributes: - `id`. - `organizationId`. - `startsAt`, `endsAt`:
interval start/end instants. - `status`: Open or Closed. -
`createdByUserId`. - `createdAt`, `updatedAt`.

The merchant enters local date/times in the salon's timezone; Connective
stores the corresponding instants consistently.

Rules: - Intervals must be valid and comply with permitted business
hours. - Overlapping availability intervals for the same salon must be
prevented. - Availability is not itself a reservation. A booking can
occupy part of an interval. - The final implementation must decide
whether intervals can be adjacent and how overlap is enforced.

## 9.2 `Booking`

Represents one customer's appointment for one salon service.

Proposed attributes: - `id`. - `organizationId`. - `serviceId`: exactly
one `SalonService`. - `availabilitySlotId`: associated availability
interval, subject to final implementation review. - `customerName`. -
`customerPhone`. - `customerEmail`, optional. - `startsAt`, `endsAt`:
confirmed appointment interval. - `status`. - `customerMessage`,
optional. - `createdAt`, `updatedAt`.

Rules: - Public customers do not need Connective accounts. - Booking
must reference a service from the same organization. - Service must be
available for booking and have a valid duration. - Store the confirmed
start/end interval; do not recalculate old appointments from the
service's current duration. - Booking must fit entirely inside an open
availability interval and comply with business hours. - A booking may
optionally link to a Module 6 lead, but a lead is not required. - A
rejected booking attempt must not create a confirmed booking record.

## 9.3 `BookingActivity`

Proposed attributes: - `id`. - `organizationId`. - `bookingId`. -
`actorUserId`, where applicable. - `activityType`, such as confirmation,
cancellation or rescheduling. - `details`: structured event
information. - `createdAt`.

Rescheduling activity records should preserve previous and new
appointment times. Cancellation activity should preserve actor and time.
History should not be overwritten.

## 9.4 Booking lifecycle

V1 statuses: - `CONFIRMED`: appointment successfully reserved. -
`COMPLETED`: appointment took place. - `CANCELLED_BY_MERCHANT`: merchant
cancelled. - `NO_SHOW`: customer did not attend.

There is no ordinary `PENDING` status because confirmation is immediate.
There is no `CANCELLED_BY_CUSTOMER` status under the agreed policy.

Rules: - Only merchant can cancel or reschedule. - Cancelled
appointments release time for future bookings. - Completed, cancelled
and no-show bookings remain historical records. - Reinstating a
cancelled booking requires a fresh availability check and an auditable
change. - Rescheduling must successfully reserve the new interval before
releasing the old interval. - Appropriate changes trigger notifications
through Module 9.

## 9.5 Protecting confirmed appointments

-   An availability interval with no conflicting bookings may be edited
    or closed.
-   An interval cannot be shortened, closed or deleted if doing so
    invalidates confirmed appointments.
-   The merchant must cancel or reschedule affected appointments first.
-   Service-duration changes do not silently alter existing
    appointments.
-   Server-side validation and transactional database operations enforce
    these rules; frontend warnings alone are insufficient.

## 9.6 Double-booking protection

The database/transaction design must ensure that two concurrent requests
cannot confirm overlapping appointments for the same salon.

Required checks: 1. Validate service ownership, status and duration. 2.
Validate that the requested appointment fits within an open availability
interval. 3. Atomically coordinate availability validation and booking
confirmation. 4. Prevent overlapping confirmed appointments, including
under concurrent requests. 5. Preserve timezone semantics: appointment
timestamps represent instants, while the organization's IANA timezone
controls local scheduling/display.

A PostgreSQL range/exclusion constraint or a carefully designed
transactional locking strategy may be used. The exact mechanism must be
selected during implementation; it is not yet implemented.

## 9.7 Cross-module dependencies

-   Module 2: reuse `Organization.timezone` and `BusinessHours`.
-   Module 4: reference `SalonService`; duration must be configured.
-   Module 5: future attachments can reuse `MediaAsset`.
-   Module 6: optional lead relationship; general enquiries remain
    separate.
-   Module 9: booking confirmation, cancellation and reminder delivery.
-   Module 11: backend enforcement of online-booking and slot-management
    entitlements.
-   Module 14: relevant booking changes and administrative actions must
    be auditable.

## 9.8 Remaining implementation/operational decisions

These do not block logical approval: - Exact PostgreSQL constraint or
locking strategy for appointment overlap. - Adjacent availability
interval behavior. - Maximum advance booking horizon. - Customer
verification and anti-abuse checks for public booking. - Notification
timing and retry behavior. - Retention policy for customer contact data
and historical bookings.

------------------------------------------------------------------------

# 10. Shared relationships overview

The following summarizes key relationships across the approved and
consolidated modules:

-   `User` → owns at most one `Organization`.
-   `Organization` → has one `BusinessProfile`.
-   `Organization` → has multiple `BusinessHours` intervals.
-   `Organization` → has one `Website`, with drafts, published versions
    and domain records.
-   `Organization` → owns catalogue categories, products and services.
-   `Product` → optionally has variants and has product-image
    associations.
-   `SalonService` → has service-image associations and may be bookable
    when duration is configured and entitlements allow it.
-   `Organization` → owns media assets and their variants.
-   `Lead` → has multiple follow-ups, notes, recordings and activity
    entries.
-   `Booking` → belongs to an organization and references one salon
    service and an availability interval.
-   `Booking` → may optionally link to a lead.
-   `Booking` → has multiple activity entries.
-   Custom Super Admin access is separate from merchant ownership.

Exact foreign-key actions, indexes, unique constraints and
database-level enforcement details will be finalized during schema
implementation after remaining logical sign-offs.

------------------------------------------------------------------------

# 11. Important product decisions outside individual modules

## Category-specific merchant experience

-   Clothing merchants see Leads & CRM as their primary workflow.
-   Salon/Spa/Wellness merchants see Appointments & Bookings as their
    primary workflow.
-   Shared navigation---Home, Website, Catalogue, Insights,
    Settings/Plan---remains common.
-   Salons still need a separate way to handle general enquiries. The
    booking calendar must not be used as a substitute for the general
    enquiry CRM.
-   Category-specific navigation is a product/UI rule, not a reason to
    remove CRM entities for salons.
-   Category changes require an authorized, audited support/admin
    workflow.
-   Category alone does not grant features; subscription entitlements
    also apply.

## Website content and catalogue updates

Recommended, pending explicit Module 3 sign-off: - Website layout,
appearance and editorial content are draft/published-version
controlled. - Catalogue records can update live without republishing the
whole website. - Website template structure remains
developer-controlled.

## Plans and pricing context

Three proposed plans: - Free Forever: ₹0. - Growth: ₹1,999/month. - Pro:
₹3,999/month.

These are proposed prices and have not been market-validated in this
design record. Managed Services are separately charged add-ons across
plans. Exact quotas and feature limits are to be finalized in Module 11.

------------------------------------------------------------------------

# 12. Approval status and next steps

## 12.1 Module status

  -----------------------------------------------------------------------
  Module                              Status
  ----------------------------------- -----------------------------------
  1\. Authentication & Access Control Logical design approved

  2\. Organizations & Business        Logical design approved
  Profiles                            

  3\. Websites & Publishing           Consolidated design; explicit final
                                      sign-off pending

  4\. Catalogue & Category-Specific   Logical design finalized
  Data                                

  5\. Media & File Assets             Logical design finalized

  6\. Leads & CRM                     Logical design approved

  7\. Salon Availability & Bookings   Logical design approved
  -----------------------------------------------------------------------

## 12.2 Before implementation

1.  Explicitly sign off Module 3, including whether catalogue updates
    appear live independently from website publishing.
2.  Continue with Module 8 --- AI Studio & Content Management.
3.  Design remaining modules in sequence.
4.  Run a cross-module review after all logical modules have been
    designed.
5.  Resolve naming, foreign-key, index, uniqueness, retention and
    constraint details.
6.  Only after complete design sign-off, begin writing Prisma models and
    migrations.

**Current implementation status:** No Prisma models or migrations have
been written as part of this logical design process.
