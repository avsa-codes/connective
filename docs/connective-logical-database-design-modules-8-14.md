# Connective --- Logical Database Design (Modules 8--14)

**Status:** Logical design draft finalized from the decisions made so
far\
**Scope:** Modules 8 through 14 only\
**Architecture:** Modular monolith, shared PostgreSQL database,
Node.js/Express/TypeScript API, Prisma 7.10.1\
**Important:** This document describes the logical data model. It does
not contain Prisma models or migrations. Implementation begins only
after the complete 14-module design has been reviewed and approved.

------------------------------------------------------------------------

## Design principles applying to these modules

-   All organization-owned records must be tenant-scoped and authorized
    server-side.
-   Cross-module relationships must verify that referenced records
    belong to the same organization where applicable.
-   Store timestamps consistently as actual instants (UTC; PostgreSQL
    `timestamptz` where appropriate). Use `Organization.timezone` for
    local display and recurring business-time rules.
-   Keep secrets, access tokens, passwords, OTPs, payment-card data, and
    other sensitive credentials out of ordinary JSON details, activity
    logs, and audit records.
-   Prefer immutable snapshots/history for approvals, publication,
    payments, and important state transitions.
-   Use transactions and idempotency where concurrent requests or
    external provider callbacks could otherwise create inconsistent
    records.
-   These are logical groupings inside one modular monolith, not
    separate databases or microservices.
-   No Prisma schema or migrations should be written until all 14
    modules pass the final cross-module review.

# Module 8 --- AI Studio & Content Management

## Purpose and scope

Supports AI-assisted website content generation and marketing/social
content creation. Website drafts and published website versions remain
owned by Module 3. Marketing content is owned by this module.

V1 requires human approval before publication. A reusable draft can be
adapted for different platforms. Content scheduling and a content
calendar are deferred.

## Entities

### 8.1 `AIContentJob`

Represents a single AI generation or rewriting request.

  -----------------------------------------------------------------------
  Field                               Purpose
  ----------------------------------- -----------------------------------
  `id`                                Unique job ID

  `organizationId`                    Owning organization

  `requestedByUserId`                 User who requested the job

  `jobType`                           Generation, rewrite, adaptation, or
                                      other supported job type

  `contentType`                       Website content or marketing
                                      content type

  `targetType`                        Website draft or marketing content
                                      target

  `websiteDraftId`                    Optional reference when the target
                                      is a website draft

  `contentItemId`                     Optional reference when the target
                                      is a marketing content item

  `inputInstructions`                 User's instructions and relevant
                                      generation inputs

  `status`                            Job lifecycle state

  `errorCode`                         Optional safe diagnostic code

  `createdAt`, `updatedAt`            Record timestamps

  `completedAt`                       Optional completion timestamp
  -----------------------------------------------------------------------

Exactly one applicable target must be set, and it must belong to the
same organization. Retain job records under a defined retention policy;
do not store secrets in prompts or error details.

**Statuses:** `PENDING`, `PROCESSING`, `COMPLETED`, `FAILED`,
`CANCELLED`.

### 8.2 `ContentItem`

Represents a marketing content item independent of a particular
revision.

  -----------------------------------------------------------------------
  Field                               Purpose
  ----------------------------------- -----------------------------------
  `id`                                Unique content item ID

  `organizationId`                    Owning organization

  `createdByUserId`                   Creator

  `contentType`                       Post, caption, campaign asset, or
                                      another supported type

  `title`                             Optional title

  `status`                            Current workflow status

  `currentRevisionId`                 Reference to the current revision

  `approvedRevisionId`                Optional reference to the exact
                                      approved revision

  `approvedByUserId`, `approvedAt`    Approval actor and timestamp

  `createdAt`, `updatedAt`            Record timestamps

  `archivedAt`                        Optional archive timestamp
  -----------------------------------------------------------------------

### 8.3 `ContentRevision`

Immutable version of a marketing content item.

  -----------------------------------------------------------------------
  Field                               Purpose
  ----------------------------------- -----------------------------------
  `id`                                Unique revision ID

  `organizationId`                    Owning organization

  `contentItemId`                     Parent content item

  `revisionNumber`                    Incrementing revision number per
                                      item

  `contentDocument`                   Structured JSONB content and
                                      platform adaptations

  `createdByUserId`                   User or authorized process that
                                      created the revision

  `creationSource`                    Manual, AI-generated, or adapted

  `createdAt`                         Creation timestamp
  -----------------------------------------------------------------------

Revision numbers must be unique within each content item. Editing
creates a new revision; existing revisions are not overwritten.

### 8.4 `ContentMedia`

Associates media assets with a specific content revision.

  Field                 Purpose
  --------------------- -------------------------------------------
  `id`                  Unique association ID
  `organizationId`      Owning organization
  `contentRevisionId`   Content revision
  `mediaAssetId`        Module 5 media asset
  `sortOrder`           Display order
  `role`                Media purpose, such as image or thumbnail
  `createdAt`           Creation timestamp

The revision and media asset must belong to the same organization. Only
eligible, ready media may be attached.

### 8.5 `ContentPublication`

Tracks a publication attempt for a specific approved revision to an
external platform.

  Field                      Purpose
  -------------------------- ---------------------------------------
  `id`                       Unique publication ID
  `organizationId`           Owning organization
  `contentItemId`            Content item
  `contentRevisionId`        Exact revision to publish
  `integrationAccountId`     Module 10 integration account
  `status`                   Publication lifecycle state
  `externalPostId`           Optional external platform identifier
  `publishedAt`              Optional publication timestamp
  `failureCode`              Optional safe error code
  `createdAt`, `updatedAt`   Record timestamps

**Statuses:** `QUEUED`, `PUBLISHING`, `PUBLISHED`, `FAILED`,
`CANCELLED`.

## Business rules

-   Content workflow states: `DRAFT`, `IN_REVIEW`, `APPROVED`,
    `PUBLISHED`.
-   Approval applies to an exact revision. Any edit creates a new
    revision and the new revision must be approved before publication.
-   Restoring old content creates a new revision rather than rewriting
    history.
-   Completing an AI job does not approve or publish content.
-   A publication references the exact approved revision. Recheck
    approval and entitlements before sending it to an external platform.
-   Publication retries must be idempotent where supported to avoid
    duplicate posts.
-   V1 supports manual publication only; no scheduled posting or content
    calendar.
-   Website draft/version content remains in Module 3. This module may
    create AI jobs targeting a website draft but does not own website
    publication.
-   AI usage and credits are accounted for in Module 11.
-   Notifications and retries use Module 9 patterns; media comes from
    Module 5; external accounts come from Module 10; broader
    administrative auditing uses Module 14.

# Module 9 --- Notifications & Devices

## Purpose and scope

Supports in-app notifications, push notifications, and email. SMS is not
a default channel and must be justified separately. Important business
changes use a transactional outbox so the database change and event
record can be committed together.

## Entities

### 9.1 `Notification`

An in-app notification shown to a user.

  -----------------------------------------------------------------------
  Field                               Purpose
  ----------------------------------- -----------------------------------
  `id`                                Unique notification ID

  `organizationId`                    Optional related organization

  `recipientUserId`                   Intended recipient

  `notificationType`                  Type/code of notification

  `title`, `body`                     User-facing text

  `relatedEntityType`,                Optional link to a relevant record
  `relatedEntityId`                   

  `readAt`                            Null until read

  `createdAt`                         Creation timestamp

  `expiresAt`                         Optional expiration timestamp
  -----------------------------------------------------------------------

Read state is separate from delivery state.

### 9.2 `PushDevice`

Represents a user's registered mobile push endpoint.

  Field                      Purpose
  -------------------------- -----------------------------------------
  `id`                       Unique device record
  `userId`                   Better Auth user
  `platform`                 `ANDROID` or `IOS`
  `pushToken`                Provider token, protected appropriately
  `status`                   Active or inactive state
  `lastSeenAt`               Last observed activity
  `createdAt`, `updatedAt`   Record timestamps
  `deactivatedAt`            Optional deactivation timestamp

Tokens must be protected, and invalid tokens must be deactivated.

### 9.3 `NotificationPreference`

Stores a user's global channel preferences.

  Field                      Purpose
  -------------------------- -----------------------------------------
  `id`                       Unique preference ID
  `userId`                   Better Auth user
  `channel`                  In-app, push, or email
  `enabled`                  Whether the optional channel is enabled
  `createdAt`, `updatedAt`   Record timestamps

Unique constraint: one preference per user and channel. Essential
security/account communications may be handled separately from optional
preferences.

### 9.4 `NotificationDelivery`

Tracks an attempt to deliver a notification through a channel.

  Field                      Purpose
  -------------------------- ------------------------------
  `id`                       Unique delivery ID
  `notificationId`           Related notification
  `channel`                  Delivery channel
  `status`                   Delivery lifecycle state
  `attemptCount`             Number of attempts
  `nextAttemptAt`            Optional retry time
  `sentAt`, `deliveredAt`    Optional delivery timestamps
  `providerMessageId`        Optional provider reference
  `failureCode`              Optional safe failure code
  `createdAt`, `updatedAt`   Record timestamps

**Statuses:** `PENDING`, `PROCESSING`, `SENT`, `DELIVERED`, `FAILED`,
`CANCELLED`.

### 9.5 `OutboxEvent`

Durable record of an important event to be processed asynchronously.

  Field                            Purpose
  -------------------------------- ------------------------------------------
  `id`                             Unique event ID
  `eventType`                      Event code
  `organizationId`                 Optional related organization
  `aggregateType`, `aggregateId`   Business record that changed
  `payload`                        Structured event payload
  `status`                         Processing state
  `attemptCount`                   Number of attempts
  `createdAt`                      Creation timestamp
  `processedAt`                    Optional successful processing timestamp
  `nextAttemptAt`                  Optional retry timestamp
  `lastErrorCode`                  Optional safe diagnostic code

Outbox lifecycle includes `PENDING`, `PROCESSING`, and `PROCESSED`;
retryable/permanent failure handling may be represented by additional
states or implementation metadata.

## Business rules

-   Insert the outbox event in the same database transaction as the
    important business change.
-   Process events asynchronously; do not call external providers inside
    the business database transaction.
-   Use idempotent processing, safe worker claiming, bounded retries,
    and backoff.
-   Notification history and delivery attempts have separate retention
    policies.
-   Lead follow-up reminders originate from Module 6; booking events
    from Module 7; AI/publication events from Module 8; integration
    events from Module 10; subscription/payment events from Modules
    11--12.
-   Use the organization's IANA timezone for user-facing local time,
    while storing instants consistently.
-   Provider choice, retry limits, and exact retention periods remain
    implementation/policy decisions.

# Module 10 --- Integrations & Social Hub

## Purpose and scope

Manages third-party account connections, credentials references,
resources, sync jobs, normalized metrics, and integration activity.

V1 targets Google Business Profile, Instagram Professional, and Google
Analytics 4, subject to actual provider eligibility, API permissions,
scopes, and supported operations. Facebook integration is not included
in V1.

## Entities

### 10.1 `IntegrationAccount`

Represents an external provider account connected for an organization.

  Field                        Purpose
  ---------------------------- -------------------------------------
  `id`                         Unique integration account ID
  `organizationId`             Owning organization
  `provider`                   External provider
  `externalAccountId`          Provider account identifier
  `displayName`                Optional display name
  `status`                     Connection state
  `connectedByUserId`          User who connected it
  `connectedAt`, `updatedAt`   Timestamps
  `disconnectedAt`             Optional disconnection timestamp
  `lastValidatedAt`            Optional last successful validation

**Statuses:** `CONNECTED`, `REAUTH_REQUIRED`, `ERROR`, `DISCONNECTED`.

### 10.2 `IntegrationCredential`

Stores a reference to secure credential storage, not plaintext tokens.

  -----------------------------------------------------------------------
  Field                               Purpose
  ----------------------------------- -----------------------------------
  `id`                                Unique credential record

  `integrationAccountId`              Related integration account

  `credentialReference`               Reference to secret store or
                                      encrypted credential record

  `tokenExpiresAt`                    Optional expiry timestamp

  `grantedScopes`                     Granted permission scopes

  `lastRefreshedAt`                   Optional refresh timestamp

  `createdAt`, `updatedAt`            Record timestamps

  `revokedAt`                         Optional revocation timestamp
  -----------------------------------------------------------------------

Credentials must remain server-side and be stored in a secure secret
store or appropriately encrypted system.

### 10.3 `IntegrationResource`

Represents a resource within a connected provider account, such as a
property or professional profile.

  Field                      Purpose
  -------------------------- -----------------------
  `id`                       Unique resource ID
  `organizationId`           Owning organization
  `integrationAccountId`     Parent integration
  `resourceType`             Resource type
  `externalResourceId`       Provider identifier
  `displayName`              Optional display name
  `status`                   Resource state
  `createdAt`, `updatedAt`   Record timestamps

### 10.4 `IntegrationSyncJob`

Tracks background or manually requested sync work.

  Field                        Purpose
  ---------------------------- -----------------------------------
  `id`                         Unique job ID
  `organizationId`             Owning organization
  `integrationAccountId`       Related integration
  `integrationResourceId`      Optional specific resource
  `jobType`                    Sync or other supported operation
  `status`                     Job state
  `attemptCount`               Retry count
  `createdAt`, `updatedAt`     Record timestamps
  `startedAt`, `completedAt`   Optional lifecycle timestamps
  `nextAttemptAt`              Optional retry timestamp
  `errorCode`                  Optional safe diagnostic code

**Statuses:** `PENDING`, `PROCESSING`, `COMPLETED`, `FAILED`,
`CANCELLED`.

### 10.5 `IntegrationMetricSnapshot`

Stores normalized metric observations for reporting.

  Field                                  Purpose
  -------------------------------------- -------------------------------------
  `id`                                   Unique snapshot ID
  `organizationId`                       Owning organization
  `integrationResourceId`                Related resource
  `metricType`                           Normalized metric code
  `periodStart`, `periodEnd`             Metric period
  `value` or normalized metric payload   Metric value
  `retrievedAt`                          Retrieval timestamp
  `sourceMetadata`                       Optional non-secret source metadata

`periodStart` must precede `periodEnd`. Define metric units and
aggregation semantics. Prevent duplicates using an appropriate
resource/metric/period/source uniqueness key. Show data freshness to
users. Provider corrections require documented update/versioning
behavior.

### 10.6 `IntegrationActivity`

Append-oriented history of integration events.

  Field                    Purpose
  ------------------------ ----------------------------------------------------
  `id`                     Unique activity ID
  `organizationId`         Owning organization
  `integrationAccountId`   Related integration
  `actorUserId`            Optional acting user
  `activityType`           Connection, disconnection, sync, or other activity
  `details`                Structured non-secret details
  `createdAt`              Event timestamp

## Business rules

-   Use OAuth wherever supported; manual configuration is allowed only
    when justified.
-   Support scheduled/background sync and manual refresh.
-   On disconnect, revoke or invalidate credentials where possible, stop
    future syncs, and cancel jobs that can no longer run. Preserve
    historical metrics/activity subject to retention policy.
-   Provider APIs and granted scopes determine actual available
    capabilities; do not promise unsupported operations.
-   Module 11 controls plan entitlements. Module 8 uses integration
    accounts for external publishing. Module 9 can notify merchants
    about failures or reconnection requirements. Module 14 handles
    broader administrative audit.
-   Exact scopes, metric definitions, API operations, retention, and
    retry behavior are implementation-time validation items.

# Module 11 --- Plans, Subscriptions, Entitlements & Usage

## Purpose and scope

Controls plan definitions, historical prices, feature access,
subscription lifecycle, usage measurement, and administrative
adjustments.

## Commercial decisions

Proposed prices, not yet market-validated:

-   **Free Forever:** ₹0
-   **Growth:** ₹1,999/month
-   **Pro:** ₹3,999/month

The same base pricing applies across clothing and salon/spa/wellness
categories. Billing is monthly at launch. Free is permanent. Managed
Services are separately charged and are not bundled into these plan
prices by default.

## Entities

### 11.1 `Plan`

  Field                      Purpose
  -------------------------- -------------------------------
  `id`                       Unique plan ID
  `code`                     `FREE`, `GROWTH`, or `PRO`
  `name`, `description`      Display details
  `status`                   Whether the plan is available
  `createdAt`, `updatedAt`   Record timestamps

### 11.2 `PlanPrice`

Preserves price history rather than overwriting prior prices.

  Field                               Purpose
  ----------------------------------- ------------------------
  `id`                                Unique price ID
  `planId`                            Related plan
  `amount`                            Price amount
  `currency`                          INR
  `billingInterval`                   Monthly for paid plans
  `effectiveFrom`, `effectiveUntil`   Effective period
  `status`                            Price state
  `createdAt`                         Creation timestamp

### 11.3 `PlanEntitlement`

Defines a feature or quota included in a plan.

  Field                      Purpose
  -------------------------- ----------------------------------
  `id`                       Unique entitlement ID
  `planId`                   Related plan
  `featureCode`              Stable feature identifier
  `enabled`                  Whether the feature is available
  `limitValue`               Optional quota limit
  `limitUnit`                Optional quota unit
  `createdAt`, `updatedAt`   Record timestamps

Unique constraint: one entitlement per plan and feature code.

Feature codes include `CUSTOM_DOMAIN`, `CATALOGUE_CAPACITY`,
`CRM_ADVANCED`, `AI_CONTENT_GENERATION`, `AI_CREDITS`, `INTEGRATIONS`,
`ANALYTICS_LEVEL`, `CALL_RECORDING_UPLOAD`, `SALON_BOOKING`,
`SALON_AVAILABILITY_MANAGEMENT`, and `MEDIA_STORAGE`.

### 11.4 `Subscription`

Tracks an organization's current and historical plan periods.

  Field                                      Purpose
  ------------------------------------------ -----------------------------------
  `id`                                       Unique subscription ID
  `organizationId`                           Owning organization
  `planId`                                   Selected plan
  `planPriceId`                              Applicable price record
  `status`                                   Subscription state
  `startedAt`                                Start timestamp
  `currentPeriodStart`, `currentPeriodEnd`   Current billing period
  `gracePeriodEndsAt`                        Optional grace deadline
  `cancelAtPeriodEnd`                        Whether cancellation is scheduled
  `cancelledAt`                              Optional cancellation timestamp
  `createdAt`, `updatedAt`                   Record timestamps

Only one effective subscription should exist per organization at a time;
historical subscriptions are retained.

### 11.5 `UsageRecord`

Records metered usage for quotas and billing/plan enforcement.

  Field                        Purpose
  ---------------------------- -----------------------------------
  `id`                         Unique usage record
  `organizationId`             Owning organization
  `featureCode`                Metered feature
  `quantity`                   Usage quantity
  `unit`                       Unit of measurement
  `occurredAt`                 Actual usage time
  `periodStart`, `periodEnd`   Applicable usage period
  `sourceType`, `sourceId`     Optional originating record
  `idempotencyKey`             Optional duplicate-prevention key

### 11.6 `UsageAdjustment`

Allows controlled corrections or administrative adjustments.

  Field               Purpose
  ------------------- ---------------------------------
  `id`                Unique adjustment ID
  `organizationId`    Owning organization
  `featureCode`       Affected feature
  `quantityDelta`     Positive or negative adjustment
  `reason`            Explanation
  `createdByUserId`   Optional administrator
  `createdAt`         Timestamp

## Business rules

-   Evaluate entitlements centrally on the server. Feature availability
    and quota accounting are separate checks.
-   Usage resets by calendar month; unused allowance does not roll over.
-   When a quota is reached, block the next metered operation and
    explain why.
-   Failed renewal receives a seven-day grace period, after which paid
    features are restricted according to defined policy.
-   Voluntary cancellation preserves paid access until the end of the
    paid period.
-   After paid access ends, a published site remains live, while
    paid-only changes and domain management are restricted.
-   Downgrades preserve data; paid-only actions are restricted rather
    than silently deleting data.
-   Notify existing subscribers about price changes and apply the new
    price at renewal.
-   Exact quotas and units, mid-cycle upgrade/proration behavior, notice
    period, grace cutoff/retries, and behavior of existing paid-only
    functionality after downgrade remain implementation decisions.
-   Quota reservation must be concurrency-safe. Payment processing and
    billing records are handled in Module 12; Managed Services are
    handled in Module 13.

# Module 12 --- Payments & Billing Records

## Purpose and scope

Tracks invoices, payment attempts, allocations, refunds, customer
references, and verified provider events. Razorpay is the initial
payment provider. Do not store CVV or raw card details.

## Decisions

-   Create billing obligations/invoices when charges become due.
-   Use provider-supported recurring payments where available and only
    with required customer authorization.
-   Refunds require admin review in V1.
-   Managed Services charges use the same invoice/payment system with
    distinct invoice line items.
-   Invoice payments are full-payment only in V1; partial refunds are
    permitted.
-   Module 11's seven-day renewal grace period must be coordinated with
    payment/subscription state.

## Entities

### 12.1 `PaymentCustomer`

  Field                      Purpose
  -------------------------- ----------------------------
  `id`                       Unique customer mapping ID
  `organizationId`           Owning organization
  `provider`                 Payment provider
  `externalCustomerId`       Provider customer ID
  `status`                   Mapping state
  `createdAt`, `updatedAt`   Record timestamps

### 12.2 `Payment`

  -----------------------------------------------------------------------
  Field                               Purpose
  ----------------------------------- -----------------------------------
  `id`                                Unique payment ID

  `organizationId`                    Owning organization

  `paymentCustomerId`                 Optional provider customer mapping

  `provider`                          Provider name

  `externalPaymentId`                 Optional provider payment ID

  `purpose`                           Subscription, Managed Service, or
                                      another supported purpose

  `amount`, `currency`                Amount and currency

  `status`                            Payment lifecycle state

  `idempotencyKey`                    Optional duplicate-prevention key

  `initiatedAt`                       Start timestamp

  `succeededAt`                       Optional success timestamp

  `failureCode`                       Optional safe failure code

  `createdAt`, `updatedAt`            Record timestamps
  -----------------------------------------------------------------------

**Statuses:** `PENDING`, `REQUIRES_ACTION`, `SUCCEEDED`, `FAILED`,
`CANCELLED`.

### 12.3 `Invoice`

  -----------------------------------------------------------------------
  Field                               Purpose
  ----------------------------------- -----------------------------------
  `id`                                Unique invoice ID

  `organizationId`                    Owning organization

  `invoiceNumber`                     Unique human-readable invoice
                                      number

  `status`                            Invoice lifecycle state

  `currency`                          Currency

  `subtotalAmount`, `taxAmount`,      Preserved invoice totals
  `totalAmount`                       

  `issuedAt`                          Issue timestamp

  `dueAt`                             Optional due timestamp

  `paidAt`                            Optional paid timestamp

  `voidedAt`                          Optional void timestamp

  `createdAt`, `updatedAt`            Record timestamps
  -----------------------------------------------------------------------

**Statuses:** `DRAFT`, `ISSUED`, `PARTIALLY_PAID`, `PAID`, `OVERDUE`,
`VOID`. Partial payments are not enabled in V1, but the status is
retained for flexibility.

### 12.4 `InvoiceLine`

  Field                     Purpose
  ------------------------- --------------------------------------------------------
  `id`                      Unique line ID
  `invoiceId`               Parent invoice
  `description`             Historical description snapshot
  `itemType`                Subscription, Managed Service, or other supported type
  `quantity`                Quantity
  `unitAmount`              Unit amount
  `taxAmount`               Tax amount
  `lineTotal`               Line total
  `relatedSubscriptionId`   Optional Module 11 reference
  `relatedServiceId`        Optional Module 13 reference
  `createdAt`               Creation timestamp

Issued invoice amounts and descriptions are snapshots; later changes to
plans or service descriptions must not rewrite issued invoices.

### 12.5 `PaymentAllocation`

Associates a successful or otherwise eligible payment with an invoice.

  Field               Purpose
  ------------------- ----------------------
  `id`                Unique allocation ID
  `paymentId`         Related payment
  `invoiceId`         Related invoice
  `allocatedAmount`   Amount allocated
  `createdAt`         Creation timestamp

### 12.6 `Refund`

  Field                      Purpose
  -------------------------- -------------------------------
  `id`                       Unique refund ID
  `paymentId`                Related payment
  `organizationId`           Owning organization
  `providerRefundId`         Optional provider refund ID
  `amount`, `currency`       Refund amount and currency
  `status`                   Refund lifecycle state
  `reason`                   Optional reason
  `requestedAt`              Request timestamp
  `completedAt`              Optional completion timestamp
  `failureCode`              Optional safe failure code
  `createdAt`, `updatedAt`   Record timestamps

**Statuses:** `PENDING`, `SUCCEEDED`, `FAILED`, `CANCELLED`.

### 12.7 `PaymentProviderEvent`

Stores received provider webhook/event records for deduplication and
reconciliation.

  Field                Purpose
  -------------------- -------------------------------
  `id`                 Unique event record
  `provider`           Provider name
  `externalEventId`    Provider event identifier
  `eventType`          Event type
  `receivedAt`         Receipt timestamp
  `processedAt`        Optional processing timestamp
  `processingStatus`   Processing state
  `attemptCount`       Processing attempts
  `relatedPaymentId`   Optional related payment
  `relatedRefundId`    Optional related refund
  `failureCode`        Optional safe diagnostic code

Unique provider/event ID constraint prevents duplicate event processing.

## Business rules

-   Payment, invoice, refund, and subscription statuses are independent;
    reconcile them rather than assuming one implies another.
-   Verify provider signatures and make webhook processing idempotent.
    Handle duplicate, out-of-order, and missing events through
    reconciliation.
-   A refund does not erase the original payment or automatically void
    an invoice. Define the applicable credit-note/accounting correction
    process.
-   Validate amounts, currencies, tenant relationships, and allocation
    totals.
-   Provider credentials remain protected. Never store raw card details
    or CVV.
-   Confirm Razorpay recurring-payment authorization/API behavior, tax
    and invoice requirements, webhook retention, refund limits, renewal
    scheduling, reconciliation cadence, and event mapping to Module 11
    before implementation.
-   Module 9 may notify users about payment outcomes. Module 14 audits
    important administrative and payment actions.

# Module 13 --- Managed Services Inquiry Form

## Purpose and scope

This module is intentionally simple. Connective may offer services such
as website setup/management, content creation, social media management,
and other agreed digital services. Prospective merchants submit a public
form; Connective handles contact, quotations, pricing, negotiation,
payment coordination, and service delivery manually.

There is no customer account, portal, online quotation acceptance,
engagement workflow, or automated service-delivery system in this
module.

## Single entity: `ServiceInquiry`

  Field                      Purpose
  -------------------------- ------------------------------------
  `id`                       Unique inquiry ID
  `merchantName`             Person submitting the inquiry
  `businessName`             Business name, if different
  `phone`                    Contact phone number
  `email`                    Optional email address
  `serviceInterestedIn`      Requested service or category
  `message`                  Requirements or additional details
  `status`                   Inquiry handling state
  `createdAt`, `updatedAt`   Record timestamps

**Statuses:** `NEW`, `CONTACTED`, `CLOSED`.

## Business rules

-   A public form submission creates one `ServiceInquiry`.
-   The Super Admin can review submissions and update their status.
-   This is not the same as a customer enquiry submitted to a merchant's
    own website. Those belong to Module 6 (`Lead`).
-   Quotation and delivery management remain manual; do not create
    quotation, service engagement, or service activity tables for V1.
-   If Connective later charges for a service, billing may be recorded
    through Module 12 independently. This module does not automate
    invoicing.
-   Apply server-side validation, rate limiting, and anti-bot
    verification to the public form. Use the security approach
    established for public forms elsewhere in the design.

# Module 14 --- Analytics, Audit & Operational History

## Purpose and scope

Separates three concepts: 1. Audit history for accountability and
investigation. 2. Analytics dashboards for Super Admin and merchant
owners. 3. Operational troubleshooting using existing job/event records
and application logs.

The design intentionally avoids a separate analytics table for every
metric or a separate generic platform-event table in V1.

## Entity: `AuditLog`

Records important security, administrative, and business actions.

  -----------------------------------------------------------------------
  Field                               Purpose
  ----------------------------------- -----------------------------------
  `id`                                Unique audit record ID

  `organizationId`                    Optional related organization

  `actorUserId`                       Optional acting user

  `actorType`                         `USER` or `SYSTEM`

  `action`                            Stable action code, e.g. website
                                      published or organization suspended

  `entityType`                        Type of affected record

  `entityId`                          Identifier of affected record

  `details`                           Optional structured JSONB change
                                      details

  `ipAddress`                         Optional request IP for security
                                      investigations

  `createdAt`                         Action timestamp
  -----------------------------------------------------------------------

## Audit rules

-   Capture important security, administrative, and business
    changes---not every routine read by default.
-   Audit records are append-only through the application. Ordinary
    users and admins must not be able to casually rewrite the history
    they are meant to preserve.
-   Never record passwords, OTPs, access tokens, provider secrets,
    payment-card data, or full private notes/recording content in audit
    details.
-   Access to audit history must be restricted and itself appropriately
    monitored.
-   Retention must be defined based on security, legal, and operational
    requirements before launch; indefinite retention is not assumed.
-   Include the relevant organization where applicable. Platform-level
    actions may have no organization.
-   Audit logging should cover high-value events such as organization
    suspension/category changes, platform-admin access changes, website
    publication, subscription/entitlement changes, payment/refund
    administration, and sensitive media access/deletion where
    appropriate.

## Analytics dashboards

Connective has two distinct analytics experiences, but they do not
require separate analytics tables in V1.

### Super Admin analytics

Platform-wide view, with authorized drill-down when required. Potential
metrics include: - Total, active, and newly registered organizations. -
Organizations by business category. - Free/Growth/Pro subscription
distribution. - Revenue, invoices, successful payments, failed
renewals. - Platform-wide lead and booking counts. - Published websites
and AI usage. - Integration failures and operational issues.

### Merchant-owner analytics

An organization-scoped view. A merchant must only see their own
organization's data. Potential metrics include: - Website visits and
traffic trends when a measurement source is configured. - Enquiries and
lead sources. - Lead status distribution and conversion rates. - Tracked
WhatsApp/call-button clicks. - Catalogue/service interest where
measurable. - Salon booking counts, completion rates, and no-shows. -
Social and Google Business Profile metrics when supported integrations
provide them.

### Data sources

  -----------------------------------------------------------------------
  Metric category                     Existing source
  ----------------------------------- -----------------------------------
  Organizations and categories        Module 2: `Organization`

  Leads and conversion                Module 6: `Lead` and related
                                      records

  Salon bookings                      Module 7: `Booking`

  AI usage                            Module 11: `UsageRecord` and Module
                                      8 job records

  Subscriptions and entitlements      Module 11

  Payments and invoices               Module 12

  Website traffic                     Configured analytics provider or
                                      explicit event measurement

  Social/provider metrics             Module 10:
                                      `IntegrationMetricSnapshot`

  Important action history            Module 14: `AuditLog`
  -----------------------------------------------------------------------

Do not display metrics that cannot be measured reliably. Website traffic
requires a measurement source such as GA4 or explicit traffic
measurement. Button clicks need explicit tracking. External metrics
depend on provider API permissions and availability.

## Operational history

No separate `PlatformEvent` table is required in V1. Use existing
records for AI jobs, notification deliveries/outbox events, integration
sync jobs, and payment-provider events, alongside application/worker
logs. A dedicated operational event table or analytics snapshots may be
introduced later if a demonstrated requirement justifies them.

## Performance and future growth

-   Calculate metrics from existing records for V1.
-   Add aggregate tables or daily/monthly snapshots only if query
    performance, reporting history, or product requirements justify
    them.
-   Enforce tenant isolation in every merchant analytics query.
-   Enforce platform-admin authorization for platform-wide analytics and
    sensitive drill-downs.
-   Plan entitlements may control the depth of merchant analytics
    available.
-   Define retention, aggregation, and provider freshness semantics for
    each metric before production.

------------------------------------------------------------------------

# Cross-module relationships and dependencies

  -----------------------------------------------------------------------
  Module                              Main relationships / dependencies
  ----------------------------------- -----------------------------------
  8 --- AI Studio & Content           Module 3 website drafts; Module 5
                                      media; Module 9
                                      notifications/outbox; Module 10
                                      integrations; Module 11 AI
                                      credits/entitlements; Module 14
                                      audit

  9 --- Notifications & Devices       Better Auth users; organization
                                      timezone from Module 2; lead
                                      follow-ups from Module 6; bookings
                                      from Module 7; AI and publication
                                      jobs from Module 8; integrations
                                      from Module 10;
                                      subscriptions/payments from Modules
                                      11--12

  10 --- Integrations & Social Hub    Module 2 organizations; Module 8
                                      publication; Module 11
                                      entitlements; Module 9
                                      failure/reconnection notifications;
                                      Module 14 audit

  11 --- Plans, Subscriptions & Usage Module 2 organizations; Module 12
                                      payments/invoices; Module 13
                                      services are billed separately
                                      through Module 12; entitlement
                                      enforcement across Modules 3--10

  12 --- Payments & Billing           Module 11 subscriptions/prices;
                                      Module 13 service charges; Module 9
                                      notifications; Module 14 audit

  13 --- Service Inquiry Form         Public Connective website; Super
                                      Admin inquiry view; Module 12 only
                                      if a separate service charge is
                                      later invoiced

  14 --- Analytics, Audit &           Reads relevant data from Modules
  Operations                          2--13; merchant analytics is
                                      organization-scoped; Super Admin
                                      analytics is platform-scoped
  -----------------------------------------------------------------------

# Decisions and implementation items still requiring validation

These are not reasons to create Prisma models early. Resolve them during
the final cross-module review and implementation planning.

1.  **AI and publication:** Exact provider APIs, supported platform
    operations, retry/idempotency behavior, and retention.
2.  **Notifications:** Providers, delivery retry/backoff, retention
    periods, and treatment of essential security/account communications.
3.  **Integrations:** Exact scopes, account eligibility, metrics, API
    limits, freshness, and credential-storage implementation.
4.  **Plans:** Exact quotas and units; mid-cycle upgrade/proration;
    price-change notice period; grace-period cutoff and retry behavior;
    paid-only feature behavior after downgrade.
5.  **Payments:** Razorpay recurring-payment authorization and APIs;
    tax/invoice requirements; reconciliation; refund limits;
    credit-note/accounting treatment; webhook retention.
6.  **Managed Services form:** Final field validation and public-form
    anti-bot configuration.
7.  **Audit:** Exact list of auditable events, access permissions, and
    retention policy.
8.  **Analytics:** Exact V1 metric definitions and plan availability;
    configure measurement before promising website traffic or click
    metrics.
9.  **Architecture consistency:** Confirm final workspace names before
    implementation. Earlier options differed between `apps/websites` and
    `apps/web`, and whether `apps/super-admin` is a separate app.

# Implementation boundary

This document covers the logical design for Modules 8--14. It must be
reviewed together with the Modules 1--7 document before implementation.

**No Prisma models or migrations are included or authorized by this
document.** The next step is to combine the module documents, run a full
consistency review across all 14 modules, resolve outstanding decisions,
and obtain explicit approval of the complete logical database design.
