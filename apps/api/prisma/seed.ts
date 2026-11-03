import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from '../generated/prisma/client';
import { Pool } from 'pg';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

const templates = [
  {
    name: 'Clothing — Minimal',
    slug: 'clothing-minimal',
    businessCategory: 'CLOTHING' as const,
    releaseNotes: 'Initial minimal clothing storefront template.',
  },
  {
    name: 'Clothing — Editorial',
    slug: 'clothing-editorial',
    businessCategory: 'CLOTHING' as const,
    releaseNotes: 'Initial editorial-style clothing storefront template.',
  },
  {
    name: 'Clothing — Boutique',
    slug: 'clothing-boutique',
    businessCategory: 'CLOTHING' as const,
    releaseNotes: 'Initial boutique-style clothing storefront template.',
  },
  {
    name: 'Salon — Elegant',
    slug: 'salon-elegant',
    businessCategory: 'SALON_SPA_WELLNESS' as const,
    releaseNotes: 'Initial elegant salon and wellness template.',
  },
  {
    name: 'Salon — Modern',
    slug: 'salon-modern',
    businessCategory: 'SALON_SPA_WELLNESS' as const,
    releaseNotes: 'Initial modern salon and wellness template.',
  },
  {
    name: 'Salon — Luxury',
    slug: 'salon-luxury',
    businessCategory: 'SALON_SPA_WELLNESS' as const,
    releaseNotes: 'Initial premium salon and wellness template.',
  },
];

async function main() {
  for (const templateData of templates) {
    const { releaseNotes, ...templateFields } = templateData;

    const template = await prisma.websiteTemplate.upsert({
      where: { slug: templateFields.slug },
      update: {
        name: templateFields.name,
        businessCategory: templateFields.businessCategory,
        status: 'ACTIVE',
      },
      create: {
        ...templateFields,
        status: 'ACTIVE',
      },
    });

    await prisma.websiteTemplateRelease.upsert({
      where: {
        templateId_versionNumber: {
          templateId: template.id,
          versionNumber: 1,
        },
      },
      update: {
        releaseNotes,
        status: 'RELEASED',
        releasedAt: new Date(),
      },
      create: {
        templateId: template.id,
        versionNumber: 1,
        status: 'RELEASED',
        releaseNotes,
        releasedAt: new Date(),
      },
    });

    console.log(`Seeded template: ${template.name}`);
  }

  console.log('Website template seeding completed.');
}

main()
  .catch((error) => {
    console.error('Seed failed:', error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
