### 8.6 `GenerationContextSnapshot`

Represents a snapshot of the relevant business information, source data, and generation settings used for an AI content-generation request.

The snapshot preserves the context used at generation time so that changes to a business profile, catalogue item, or brand settings do not silently change the historical basis of previously generated content.

| Field | Purpose |
|---|---|
| `id` | Unique context snapshot ID |
| `organizationId` | Owning organization |
| `snapshotType` | Type of context captured, such as business profile, product/service, or combined generation context |
| `sourceReferences` | Structured references to the source records used, including source type, record identifier, and version where available |
| `contextData` | Snapshot of the relevant resolved business facts, product/service details, brand settings, user-provided details, and other generation inputs |
| `createdAt` | Snapshot creation timestamp |

**Business rules**

- Each snapshot belongs to one organization and must be accessible only to authorized users and processes within that organization.
- Capture only the information relevant to the generation request; do not copy the entire business database into every snapshot.
- Source references should identify the records and versions used where versioning is available. If a source has no version history, retain the relevant resolved values in `contextData`.
- A snapshot associated with a completed or failed generation attempt must remain unchanged for historical traceability.
- A new generation request that uses materially different source data or settings should use a new snapshot.
- Do not include access tokens, passwords, payment credentials, or unnecessary personal/customer information in the snapshot.
- Retention and deletion must follow the platform's data-retention and privacy requirements.

### 8.7 `ReelTemplate`

Represents a reusable, versioned video template used to assemble short-form vertical videos from images, text, animation, transitions, and other supported media.

Templates define the visual structure and rendering configuration for generated Reels. They are reusable across eligible organizations and are separate from individual content items and generation jobs.

| Field | Purpose |
|---|---|
| `id` | Unique Reel template ID |
| `name` | Display name of the template |
| `description` | Optional explanation of the template's style or intended use |
| `version` | Template version identifier |
| `templateConfiguration` | Structured configuration defining scene/layout structure, text placement, animation, transitions, timing, and other rendering settings |
| `aspectRatio` | Intended video aspect ratio, such as 9:16 |
| `exportSettings` | Default output settings, such as resolution and frame rate |
| `status` | Template availability status |
| `createdAt`, `updatedAt` | Record creation and update timestamps |

**Business rules**

- Templates should be reusable rather than duplicated for each organization or content item.
- Template versions must be identifiable so a previously generated Reel can be associated with the template configuration used at generation time.
- Changes to a published or actively used template should create a new version rather than silently changing the configuration associated with historical generations.
- Only active and compatible templates may be selected for new generation requests.
- Template configuration must be validated before rendering to prevent invalid layouts, unsupported settings, or malformed output instructions.
- The template defines the rendering structure; generated scripts, captions, content revisions, and media assets remain managed by their existing entities.
- This entity is intended for the planned template-based Reel-generation capability. It does not imply that Reel generation or video rendering must be implemented in the first Connective release.