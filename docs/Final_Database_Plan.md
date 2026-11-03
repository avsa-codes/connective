# Connective — Final Database Plan (Modules 1–14)

**Document purpose:** The consolidated source of truth for Connective’s logical database design across all 14 modules, listing the tables and fields decided so far and classifying each as MVP or Later.

**Status:** Consolidated logical design based on the original module documents and subsequent decisions made during module-by-module tutoring. This is the reference document for the final cross-module review before Prisma models and migrations. It is not Prisma schema code.

## Status and intended use

This document supersedes the older working drafts wherever it records a later decision made during the 14-module learning process. Use it as the single reference for the next cross-module review and subsequent Prisma implementation. “Final” means consolidated logical plan; it does not remove the listed implementation decisions that still require confirmation.

## How to read this document

- **MVP** means implement for the first usable launch, subject to the feature being part of the launch offering.
- **Later** means keep in the logical blueprint but do not create until the corresponding feature is scheduled.
- **MVP — conditional/category-specific** means required only when that capability is enabled (for example, salon booking is a Pro salon feature).
- **Later** means the table remains in the long-term logical design but should not be implemented until its feature is scheduled.
- This plan incorporates later decisions that supersede older source-document drafts, especially Module 6, Module 8, Module 9, Module 10, and Module 12.
- Field names below preserve the agreed logical design. Optional fields are marked “optional” or “nullable” where that was specified. Field types, exact nullability, indexes, constraints and provider-specific authentication fields must be confirmed during implementation.
- Better Auth owns its core authentication tables. The exact fields shown for those records are indicative and must be checked against the installed Better Auth version before schema generation.
- “Later” does not mean delete the entity from the design. Do not create all planned tables on day one simply because they are listed here.

## Recommended launch scope at a glance

| Module | MVP focus | Later focus |
|---|---|---|
| 1. Authentication & Access Control | Better Auth `User`, Better Auth `Session`, Better Auth `Account`, Better Auth `Verification`, `PlatformAdminAccess` | — |
| 2. Organizations & Business Profiles | `Organization`, `BusinessProfile`, `BusinessHours` | — |
| 3. Websites & Publishing | `Website`, `WebsiteTemplate`, `WebsiteTemplateRelease`, `WebsiteDraft`, `WebsiteVersion`, `WebsiteDomain` | `WebsitePreviewSession` |
| 4. Catalogue & Category-Specific Data | `CatalogueCategory`, `Product`, `ProductVariant`, `SalonService`, `ProductImage`, `ServiceImage` | — |
| 5. Media & File Assets | `MediaAsset`, `MediaVariant` | — |
| 6. Leads & CRM | `Lead`, `LeadFollowUp`, `LeadNote` | `LeadActivity` (deferred), `LeadRecording` |
| 7. Salon Availability & Bookings | `AvailabilitySlot`, `Booking`, `BookingActivity` | — |
| 8. AI Studio & Content Management | `AIContentGeneration` | `AIConversation`/`AIMessage` (only if needed for durable multi-turn chat), `ContentItem`, `ContentRevision`, `ContentMedia`, `ContentPublication` |
| 9. Notifications & Devices | `Notification`, `NotificationDelivery`, `OutboxEvent` | `PushDevice`, `NotificationPreference` |
| 10. Integrations & Social Hub | Conditional: `IntegrationAccount`, `IntegrationCredential`, `IntegrationResource`, `IntegrationSyncJob`, `IntegrationMetricSnapshot`; WhatsApp shared inbox tables | `IntegrationActivity` and any integration capability not included in launch |
| 11. Plans, Subscriptions, Entitlements & Usage | `Plan`, `PlanPrice`, `PlanEntitlement`, `Subscription`, `UsageRecord` | `UsageAdjustment` |
| 12. Payments & Billing Records | `Payment`, `Invoice` (basic admin dashboard); full Razorpay integration: `PaymentCustomer`, `InvoiceLine`, `PaymentAllocation`, `PaymentProviderEvent` | `Refund` unless in-product refund tracking is required at launch |
| 13. Managed Services Inquiry Form | `ServiceInquiry` | — |
| 14. Analytics, Audit & Operational History | `AuditLog` | No dedicated analytics table in V1 |

---

# Module 1 — Authentication & Access Control

## MVP: `Better Auth `User``

**Implementation classification:** MVP.

**Fields:**

`id`, `name`, `email`, `emailVerified`, `image`, `createdAt`, `updatedAt`; phone/phone-verification fields only through the supported Better Auth extension required for phone OTP.

## MVP: `Better Auth `Session``

**Implementation classification:** MVP.

**Fields:**

`id`, `userId`, `token`, `expiresAt`, `ipAddress`, `userAgent`, `createdAt`, `updatedAt` (confirm exact fields against installed Better Auth version).

## MVP: `Better Auth `Account``

**Implementation classification:** MVP.

**Fields:**

`id`, `userId`, `accountId`, `providerId`, `accessToken`, `refreshToken`, `idToken`, `accessTokenExpiresAt`, `refreshTokenExpiresAt`, `scope`, `password`, `createdAt`, `updatedAt` (exact provider-specific fields depend on Better Auth).

## MVP: `Better Auth `Verification``

**Implementation classification:** MVP.

**Fields:**

`id`, `identifier`, `value`, `expiresAt`, `createdAt`, `updatedAt` (confirm exact fields and supported flows against installed version).

## MVP: ``PlatformAdminAccess``

**Implementation classification:** MVP.

**Fields:**

`id`, `userId`, `status`/active-revoked state, `grantedAt`, `revokedAt`, `grantedByUserId`, `revokedByUserId`, `reason`, timestamps as finalized during implementation.

**Module notes**
- No custom `Membership` table in V1: each organization has one owner, and no merchant staff roles are planned.
- OTP/email delivery providers, account-linking rules, admin provisioning and exact Better Auth compatibility are implementation decisions.

# Module 2 — Organizations & Business Profiles

## MVP: ``Organization``

**Implementation classification:** MVP.

**Fields:**

`id`, `ownerUserId`, `businessName`, `businessCategory`, `status`, `onboardingStatus`, `timezone`, `createdAt`, `updatedAt`.

## MVP: ``BusinessProfile``

**Implementation classification:** MVP.

**Fields:**

`id` or `organizationId` as primary key, `organizationId` (unique), `displayName`, `description`, `logoAssetId`, `contactEmail`, `contactPhone`, `addressLine1`, `addressLine2`, `city`, `state`, `postalCode`, `countryCode`, `createdAt`, `updatedAt`.

## MVP: ``BusinessHours``

**Implementation classification:** MVP.

**Fields:**

`id`, `organizationId`, `dayOfWeek`, `opensAt`, `closesAt`.

# Module 3 — Websites & Publishing

## MVP: ``Website``

**Implementation classification:** MVP.

**Fields:**

`id`, `organizationId` (unique), `selectedTemplateReleaseId`, `status`, `currentPublishedVersionId` (nullable), `createdAt`, `updatedAt`.

## MVP: ``WebsiteTemplate``

**Implementation classification:** MVP.

**Fields:**

`id`, `name`, `slug`, `businessCategory`, `status`, `createdAt`, `updatedAt`.

## MVP: ``WebsiteTemplateRelease``

**Implementation classification:** MVP.

**Fields:**

`id`, `templateId`, `versionNumber`, `status`, `createdAt`, release metadata.

## MVP: ``WebsiteDraft``

**Implementation classification:** MVP.

**Fields:**

`id`, `websiteId` (unique), `templateReleaseId`, `contentDocument` (structured content/appearance, likely JSONB), `revisionNumber`, `updatedByUserId`, `updatedAt`.

## MVP: ``WebsiteVersion``

**Implementation classification:** MVP.

**Fields:**

`id`, `websiteId`, `versionNumber`, `templateReleaseId`, `contentSnapshot`, `publishedAt`, `publishedByUserId`, `sourceVersionId` (optional).

## MVP: ``WebsiteDomain``

**Implementation classification:** MVP.

**Fields:**

`id`, `websiteId`, `domainName`, `domainType`, `verificationStatus`, `activationStatus`, `verifiedAt`, `createdAt`, `updatedAt`.

## Later phase: ``WebsitePreviewSession``

**Implementation classification:** Later.

**Fields:**

Optional `id`, `websiteId`, preview-token/session metadata, expiry and creation fields if shareable previews are introduced. Not required for MVP; authenticated preview is sufficient.

**Module notes**
- One website per organization; one master template per initial business category.
- Published versions are immutable snapshots. Editing a draft does not alter the live site until publication.
- Custom-domain support is a paid-plan capability; verify the plan entitlement before allowing domain management.
- Catalogue data is recommended to update independently from versioned website content/layout/SEO. Final page names and path/redirect behavior still need confirmation.

# Module 4 — Catalogue & Category-Specific Data

## MVP: ``CatalogueCategory``

**Implementation classification:** MVP.

**Fields:**

`id`, `organizationId`, `name`, `slug`, `catalogueType`, `sortOrder`, `status`, `createdAt`, `updatedAt`.

## MVP: ``Product``

**Implementation classification:** MVP.

**Fields:**

`id`, `organizationId`, `categoryId` (optional), `name`, `slug`, `description`, `pricingType`, `basePrice`, `minimumPrice`, `maximumPrice`, `availabilityStatus`, `sortOrder`, `createdAt`, `updatedAt`, `archivedAt`.

## MVP: ``ProductVariant``

**Implementation classification:** MVP.

**Fields:**

`id`, `productId`, `size` (optional), `colour` (optional), `sku` (optional), `priceOverride` (optional), `availabilityStatus`, `createdAt`, `updatedAt`, `archivedAt`.

## MVP: ``SalonService``

**Implementation classification:** MVP.

**Fields:**

`id`, `organizationId`, `categoryId` (optional), `name`, `slug`, `description`, `pricingType`, `basePrice`, `minimumPrice`, `maximumPrice`, `durationMinutes` (optional until booking enabled), `availabilityStatus`, `sortOrder`, `createdAt`, `updatedAt`, `archivedAt`.

## MVP: ``ProductImage``

**Implementation classification:** MVP.

**Fields:**

`id`, `productId`, `mediaAssetId`, `sortOrder`, `role` (optional, e.g. primary/gallery).

## MVP: ``ServiceImage``

**Implementation classification:** MVP.

**Fields:**

`id`, `serviceId`, `mediaAssetId`, `sortOrder`, `role` (optional, e.g. primary/gallery).

**Module notes**
- Clothing products and salon services share catalogue-category support but use separate `Product` and `SalonService` entities.
- No cart, checkout, orders or inventory in V1. Pricing modes are `FIXED`, `STARTING_AT`, and `RANGE`; values must be nonnegative and minimum must not exceed maximum.

# Module 5 — Media & File Assets

## MVP: ``MediaAsset``

**Implementation classification:** MVP.

**Fields:**

`id`, `organizationId`, `uploadedByUserId` (where applicable), `storageKey`, `originalFileName`, `mimeType`, `fileSizeBytes`, `mediaType`, `width` (optional), `height` (optional), `processingStatus`, `accessLevel`, `createdAt`, `updatedAt`, `deletedAt` (nullable).

## MVP: ``MediaVariant``

**Implementation classification:** MVP.

**Fields:**

`id`, `mediaAssetId`, `variantType`, `storageKey`, `mimeType`, `fileSizeBytes`, `width`, `height`, `createdAt`.

**Module notes**
- Store file bytes in object storage; PostgreSQL stores metadata and internal storage keys. Only validated, ready assets can be attached.
- Call recordings are optional and may be deferred even though the logical entity is preserved.

# Module 6 — Leads & CRM

## MVP: ``Lead``

**Implementation classification:** MVP.

**Fields:**

`id`, `organizationId`, `customerName` (optional), `phone` (optional), `email` (optional), `message`, `source`, `contactChannel`, `status`, `createdByUserId` (where applicable), `createdAt`, `updatedAt`, `archivedAt` (optional).

## MVP: ``LeadFollowUp``

**Implementation classification:** MVP.

**Fields:**

`id`, `organizationId`, `leadId`, `title`, `dueAt`, `status`, `completedAt`, `createdByUserId`, `createdAt`, `updatedAt`.

## MVP: ``LeadNote``

**Implementation classification:** MVP.

**Fields:**

`id`, `organizationId`, `leadId`, `createdByUserId`, `content`, `createdAt`, `updatedAt`, `deletedAt` (optional).

## Later phase: ``LeadActivity``

**Implementation classification:** Later — deferred after the MVP simplification decision.

**Fields (if/when implemented):**

`id`, `organizationId`, `leadId`, `actorUserId` (nullable for system events), `activityType`, `details` (structured), `createdAt`.

The initial MVP will not use this separate activity table. Preserve current lead status and timestamps on `Lead`; revisit whether historical status transitions require an event/history table before final Prisma implementation.

## Later phase: ``LeadRecording``

**Implementation classification:** Later.

**Fields:**

`id`, `organizationId`, `leadId`, `mediaAssetId`, `uploadedByUserId`, `createdAt`, `deletedAt` (optional). Pro-only manual call-recording uploads can be deferred if not essential at launch.

**Module notes**
- Five fixed statuses: `NEW`, `CONTACTED`, `FOLLOW_UP`, `CONVERTED`, `LOST`. Leads are archived rather than hard-deleted.
- Each enquiry creates a separate lead; no automatic merging by phone/email. At least one contact method is required for merchant-entered leads.

# Module 7 — Salon Availability & Bookings

## MVP: ``AvailabilitySlot``

**Implementation classification:** MVP — Salon Pro feature.

**Fields:**

`id`, `organizationId`, `startsAt`, `endsAt`, `status`, `createdByUserId`, `createdAt`, `updatedAt`.

## MVP: ``Booking``

**Implementation classification:** MVP — Salon Pro feature.

**Fields:**

`id`, `organizationId`, `serviceId`, `availabilitySlotId`, `customerName`, `customerPhone`, `customerEmail` (optional), `startsAt`, `endsAt`, `status`, `customerMessage` (optional), optional `leadId` relationship, `createdAt`, `updatedAt`.

## MVP: ``BookingActivity``

**Implementation classification:** MVP — Salon Pro feature.

**Fields:**

`id`, `organizationId`, `bookingId`, `actorUserId` (optional), `activityType`, `details` (structured), `createdAt`.

**Module notes**
- Booking tables are needed at launch only if online booking is offered from launch; recommendation is to include for Pro salons.
- Booking confirmation must be transactionally safe against concurrent double-booking. Confirmed bookings must be resolved before changing availability in a way that invalidates them.

# Module 8 — AI Studio & Content Management

## MVP: `AIContentGeneration`

**Implementation classification:** MVP.

**Purpose:** Store generated text, captions, ideas and image-generation results in the merchant’s AI Studio gallery/history. The actual image bytes live in object storage; Module 5 `MediaAsset` stores their metadata. This table replaces the older `AIContentJob`-only draft because the agreed V1 experience is a ChatGPT-like generation interface with saved results, not a formal approval/publication workflow.

**Fields:**

`id`, `organizationId`, `createdByUserId`, `conversationId` (optional), `contentType` (e.g. `TEXT`, `IMAGE`), `prompt`, `responseText` (optional), `mediaAssetId` (optional; references generated image in Module 5), `status` (`PENDING`, `PROCESSING`, `COMPLETED`, `FAILED`), `errorCode` (optional), `isSaved`, `createdAt`, `completedAt` (optional).

## Later: `AIConversation` and `AIMessage` (conditional)

These are **not approved MVP tables**. Add them only if a durable multi-turn chat history cannot be represented adequately by `conversationId` and generation records. The exact fields have not been finalized.

## Later: `ContentItem`, `ContentRevision`, `ContentMedia`, `ContentPublication`

These formal marketing-content, revision, media-association and publication workflow tables remain deferred. Their earlier proposed fields are preserved below for future design reference; do not implement them for the current MVP.

### `ContentItem` — Later
`id`, `organizationId`, `createdByUserId`, `contentType`, `title` (optional), `status`, `currentRevisionId`, `approvedRevisionId` (optional), `approvedByUserId` (optional), `approvedAt` (optional), `createdAt`, `updatedAt`, `archivedAt` (optional).

### `ContentRevision` — Later
`id`, `organizationId`, `contentItemId`, `revisionNumber`, `contentDocument` (JSONB), `createdByUserId`, `creationSource`, `createdAt`.

### `ContentMedia` — Later
`id`, `organizationId`, `contentRevisionId`, `mediaAssetId`, `sortOrder`, `role`, `createdAt`.

### `ContentPublication` — Later
`id`, `organizationId`, `contentItemId`, `contentRevisionId`, `integrationAccountId`, `status`, `externalPostId` (optional), `publishedAt` (optional), `failureCode` (optional), `createdAt`, `updatedAt`.

**Module notes**
- Website drafts and published website versions belong to Module 3, not this module.
- No separate gallery table is needed for V1; saved generations plus linked `MediaAsset` records support the gallery.
- No formal content approval, scheduling, calendar or social publishing workflow in this MVP.

# Module 9 — Notifications & Devices

## MVP: ``Notification``

**Implementation classification:** MVP.

**Fields:**

`id`, `organizationId` (optional), `recipientUserId`, `notificationType`, `title`, `body`, `relatedEntityType` (optional), `relatedEntityId` (optional), `readAt` (nullable), `createdAt`, `expiresAt` (optional).

## MVP: ``NotificationDelivery``

**Implementation classification:** MVP.

**Fields:**

`id`, `notificationId`, `channel`, `status`, `attemptCount`, `nextAttemptAt` (optional), `sentAt` (optional), `deliveredAt` (optional), `providerMessageId` (optional), `failureCode` (optional), `createdAt`, `updatedAt`. Use in-app and WhatsApp delivery in V1; routine email and push notifications are excluded. OTP delivery is handled separately by authentication. WhatsApp uses Connective’s central business number through Meta Cloud API.

## MVP: ``OutboxEvent``

**Implementation classification:** MVP.

**Fields:**

`id`, `eventType`, `organizationId` (optional), `aggregateType`, `aggregateId`, `payload`, `status`, `attemptCount`, `createdAt`, `processedAt` (optional), `nextAttemptAt`, `lastErrorCode` (optional).

## Later phase: ``PushDevice``

**Implementation classification:** Later.

**Fields:**

`id`, `userId`, `platform`, `pushToken`, `status`, `lastSeenAt`, `createdAt`, `updatedAt`, `deactivatedAt` (optional).

## Later phase: ``NotificationPreference``

**Implementation classification:** Later.

**Fields:**

`id`, `userId`, `channel`, `enabled`, `createdAt`, `updatedAt`. Add when merchant-level channel preferences are exposed; essential security/account messages remain separately controlled.

**Module notes**
- Use a transactional outbox for important events; provider calls occur outside the business transaction. WhatsApp messages are sent from Connective’s central business number. Push devices and granular notification preferences are deferred. Keep the WhatsApp shared inbox (Module 10) separate from notification delivery.

# Module 10 — Integrations & Social Hub

**Scope decision:** Keep the integration entities in the logical design. V1 targets Google Business Profile, Instagram Professional, and WhatsApp. Google Analytics 4 integration is excluded from V1; Connective may use its own first-party website tracking for Connective-hosted websites. Provider eligibility, API permissions and review requirements must be confirmed before implementation.

## MVP — conditional: `IntegrationAccount`
`id`, `organizationId`, `provider`, `externalAccountId`, `displayName` (optional), `status`, `connectedByUserId`, `connectedAt`, `updatedAt`, `disconnectedAt` (optional), `lastValidatedAt` (optional). Statuses: `CONNECTED`, `REAUTH_REQUIRED`, `ERROR`, `DISCONNECTED`.

## MVP — conditional: `IntegrationCredential`
`id`, `integrationAccountId`, `credentialReference`, `tokenExpiresAt` (optional), `grantedScopes`, `lastRefreshedAt` (optional), `createdAt`, `updatedAt`, `revokedAt` (optional). Store a reference to secure secret storage; never store provider tokens as plaintext.

## MVP — conditional: `IntegrationResource`
`id`, `organizationId`, `integrationAccountId`, `resourceType`, `externalResourceId`, `displayName` (optional), `status`, `createdAt`, `updatedAt`.

## MVP — conditional: `IntegrationSyncJob`
`id`, `organizationId`, `integrationAccountId`, `integrationResourceId` (optional), `jobType`, `status`, `attemptCount`, `createdAt`, `updatedAt`, `startedAt` (optional), `completedAt` (optional), `nextAttemptAt` (optional), `errorCode` (optional). Statuses: `PENDING`, `PROCESSING`, `COMPLETED`, `FAILED`, `CANCELLED`.

## MVP — conditional: `IntegrationMetricSnapshot`
`id`, `organizationId`, `integrationResourceId`, `metricType`, `periodStart`, `periodEnd`, `value` or normalized metric payload, `retrievedAt`, `sourceMetadata` (optional). Include only for provider metrics actually fetched and shown.

## Later: `IntegrationActivity`
`id`, `organizationId`, `integrationAccountId`, `actorUserId` (optional), `activityType`, `details` (structured and non-secret), `createdAt`.

## MVP — conditional: `WhatsAppConversation`

Represents a customer conversation routed to an organization through Connective’s shared WhatsApp number. Proposed logical fields to confirm during cross-module review: `id`, `organizationId`, `customerPhone`, `customerName` (optional), `leadId` (optional), `status`, `lastMessageAt` (optional), `createdAt`, `updatedAt`. The central-number routing design must reliably map incoming customer messages to the correct business; use a merchant-specific click-to-WhatsApp routing identifier or a selection step where needed.

## MVP — conditional: `WhatsAppMessage`

Represents an incoming or outgoing message in a conversation. Proposed logical fields to confirm during cross-module review: `id`, `conversationId`, `direction`, `contentType`, `body` (optional), `mediaAssetId` (optional), `providerMessageId` (optional), `status`, `sentAt` (optional), `deliveredAt` (optional), `readAt` (optional), `failureCode` (optional), `createdAt`. Do not store provider credentials or unnecessary sensitive content in logs.

**V1 feature scope**
- Google Business Profile: connect/disconnect, profile and hours, supported performance metrics, reviews and replies, create/manage posts.
- Instagram Professional: connect/disconnect eligible professional accounts, profile information and supported insights, publish supported image posts and Reels. Exclude DMs, comment management, Stories and advanced publishing from initial scope.
- WhatsApp: notifications, incoming customer messages, merchant replies in Connective, message status, associate conversations with the business and, where possible, a lead.
- Exclude standalone GA4 integration in V1. Do not display unsupported metrics.

# Module 11 — Plans, Subscriptions, Entitlements & Usage

## MVP: ``Plan``

**Implementation classification:** MVP.

**Fields:**

`id`, `code`, `name`, `description`, `status`, `createdAt`, `updatedAt`.

## MVP: ``PlanPrice``

**Implementation classification:** MVP.

**Fields:**

`id`, `planId`, `amount`, `currency`, `billingInterval`, `effectiveFrom`, `effectiveUntil` (optional), `status`, `createdAt`.

## MVP: ``PlanEntitlement``

**Implementation classification:** MVP.

**Fields:**

`id`, `planId`, `featureCode`, `enabled`, `limitValue` (optional), `limitUnit` (optional), `createdAt`, `updatedAt`.

## MVP: ``Subscription``

**Implementation classification:** MVP.

**Fields:**

`id`, `organizationId`, `planId`, `planPriceId`, `status`, `startedAt`, `currentPeriodStart`, `currentPeriodEnd`, `gracePeriodEndsAt` (optional), `cancelAtPeriodEnd`, `cancelledAt` (optional), `createdAt`, `updatedAt`.

## MVP: ``UsageRecord``

**Implementation classification:** MVP.

**Fields:**

`id`, `organizationId`, `featureCode`, `quantity`, `unit`, `occurredAt`, `periodStart`, `periodEnd`, `sourceType` (optional), `sourceId` (optional), `idempotencyKey` (optional). Use for MVP metered quotas that are actually enforced.

## Later phase: ``UsageAdjustment``

**Implementation classification:** Later.

**Fields:**

`id`, `organizationId`, `featureCode`, `quantityDelta`, `reason`, `createdByUserId` (optional), `createdAt`. Add when manual usage corrections/admin tooling are needed; initial corrections may be handled through controlled operational procedures.

**Module notes**
- Current proposed pricing: Free Forever ₹0, Growth ₹1,999/month and Pro ₹3,999/month; not market-validated. Same base pricing across the two initial business categories.
- Monthly billing, 7-day failed-renewal grace period, calendar-month usage reset, no rollover; voluntary cancellation retains paid access to period end.
- Only meter usage that is actually quota-limited in the MVP; central entitlement checks must be server-side.

# Module 12 — Payments & Billing Records

## MVP — conditional: ``PaymentCustomer``

**Implementation classification:** MVP.

**Fields:**

`id`, `organizationId`, `provider`, `externalCustomerId`, `status`, `createdAt`, `updatedAt`.

## MVP: ``Payment``

**Implementation classification:** MVP.

**Fields:**

`id`, `organizationId`, `paymentCustomerId` (optional), `provider`, `externalPaymentId` (optional), `purpose`, `amount`, `currency`, `status`, `idempotencyKey` (optional), `initiatedAt`, `succeededAt` (optional), `failureCode` (optional), `createdAt`, `updatedAt`.

## MVP — conditional: ``Invoice``

**Implementation classification:** MVP.

**Fields:**

`id`, `organizationId`, `invoiceNumber`, `status`, `currency`, `subtotalAmount`, `taxAmount`, `totalAmount`, `issuedAt`, `dueAt` (optional), `paidAt` (optional), `voidedAt` (optional), `createdAt`, `updatedAt`.

## MVP — conditional: ``InvoiceLine``

**Implementation classification:** MVP.

**Fields:**

`id`, `invoiceId`, `description`, `itemType`, `quantity`, `unitAmount`, `taxAmount`, `lineTotal`, `relatedSubscriptionId` (optional), `relatedServiceId` (optional), `createdAt`.

## MVP — conditional: ``PaymentAllocation``

**Implementation classification:** MVP.

**Fields:**

`id`, `paymentId`, `invoiceId`, `allocatedAmount`, `createdAt`. V1 accepts full invoice payments; no partial invoice payments.

## MVP — conditional: ``PaymentProviderEvent``

**Implementation classification:** MVP.

**Fields:**

`id`, `provider`, `externalEventId`, `eventType`, `receivedAt`, `processedAt` (optional), `processingStatus`, `attemptCount`, `relatedPaymentId` (optional), `relatedRefundId` (optional), `failureCode` (optional). Needed for verified, deduplicated webhook processing.

## Later phase: ``Refund``

**Implementation classification:** Later — conditional.

**Fields:**

`id`, `paymentId`, `organizationId`, `providerRefundId` (optional), `amount`, `currency`, `status`, `reason` (optional), `requestedAt`, `completedAt` (optional), `failureCode` (optional), `createdAt`, `updatedAt`. Include in MVP only if refunds must be initiated and tracked inside Connective at launch; otherwise handle admin-reviewed refunds manually through the provider and add this table with the refund workflow.

**Module notes**
- For the basic Super Admin payment dashboard, `Payment` and `Invoice` are the minimum core records if Connective creates/manages invoices. If the MVP only records payments and does not manage invoices, `Payment` alone may suffice.
- When Razorpay integration is enabled, add `PaymentCustomer`, `PaymentProviderEvent`, and the invoice line/allocation tables needed for complete billing records. Razorpay is the initial provider. Provider events must be verified, deduplicated and idempotently processed. Never store raw card data or CVV.
- Full invoice payments only in V1. Refund table classification depends on whether in-product refund tracking is needed at launch.
- Confirm tax/invoice compliance, recurring-payment authorization and reconciliation behavior before production.

# Module 13 — Managed Services Inquiry Form

## MVP: ``ServiceInquiry``

**Implementation classification:** MVP.

**Fields:**

`id`, `merchantName`, `businessName` (optional), `phone`, `email` (optional), `serviceInterestedIn`, `message`, `status`, `createdAt`, `updatedAt`.

**Module notes**
- This is a single-table public inquiry form for Connective’s own managed services. Quotations and delivery are handled manually; do not add quotation or engagement workflow tables in V1.

# Module 14 — Analytics, Audit & Operational History

## MVP: ``AuditLog``

**Implementation classification:** MVP.

**Fields:**

`id`, `organizationId` (optional), `actorUserId` (optional), `actorType`, `action`, `entityType`, `entityId`, `details` (optional structured JSONB), `ipAddress` (optional), `createdAt`.

No dedicated analytics table is planned for V1. Dashboard metrics are derived from existing module records. Add aggregate/snapshot tables only if measured query or reporting needs later justify them; no `PlatformEvent` table is planned.

**Module notes**
- `AuditLog` is the only new table in this module. Do not create a separate `PlatformEvent` or analytics table for V1.
- Dashboards must display only metrics supported by existing records/instrumentation; website traffic requires GA4 or explicit tracking, and clicks require event instrumentation.

---

## Cross-cutting implementation rules

1. **Tenant isolation:** Every organization-owned record must be authorized server-side and scoped to the correct organization. Validate that related records belong to the same organization.
2. **Time:** Store actual instants consistently in UTC (`timestamptz` where appropriate); use `Organization.timezone` for local display and recurring schedules.
3. **Public forms:** Validate on the server, rate-limit and verify anti-bot tokens server-side. Only verified submissions enter normal processing.
4. **History:** Preserve payment, publication, booking and important status history. Use archive/soft-delete where specified.
5. **Secrets:** Keep provider secrets and tokens out of logs, audit details and ordinary JSON payloads. Never store payment-card CVV/raw card data.
6. **Concurrency and idempotency:** Protect booking availability, usage quotas, payment webhooks and publication/retry workflows against duplicate or concurrent operations.
7. **Backups and recovery:** Configure production backups, restore testing, access control and monitoring before launch even though these are not separate product tables.
8. **No premature implementation:** Finalize remaining open decisions and cross-module relationships before generating Prisma models or migrations.

## Decisions to confirm before Prisma implementation

- Module 3 was consolidated during tutoring but final cross-module review should confirm page names, path changes/redirects, template migration behavior and independent live catalogue updates.
- Confirm exact Better Auth fields and support for phone OTP plus mandatory email verification in the installed version.
- Confirm which plan tiers and features are actually sold at launch, including whether salon booking and custom domains launch immediately.
- Decide whether refunds need an in-product workflow at launch; this determines whether `Refund` is MVP or later.
- Confirm whether all Module 10 integrations are launch scope or whether some provider capabilities will roll out later.
- Confirm the proposed `WhatsAppConversation` and `WhatsAppMessage` field lists and the central-number routing approach.
- Confirm whether durable AI multi-turn chat requires `AIConversation`/`AIMessage`, or if `conversationId` on `AIContentGeneration` is sufficient.
- Confirm whether historical lead status changes require a future `LeadActivity` table.
- Finalize exact quota values/units, usage reservation behavior and downgrade/grace-period handling.
- Finalize legal/tax invoice requirements and Razorpay recurring authorization/webhook reconciliation.
- Define retention periods for audit, notification delivery, AI job and customer/booking records.
- Resolve repository workspace naming before implementation (`apps/web` vs `apps/websites`, and the location/name of the Super Admin app).

## Important scope note

This document is the final consolidated logical-design reference for the decisions made so far, not a claim that every physical-schema detail is resolved. Where a field list is explicitly marked proposed or conditional, confirm it during the final cross-module review. Do not silently invent types, constraints, indexes or relationships. No Prisma models or migrations have been generated by this document.