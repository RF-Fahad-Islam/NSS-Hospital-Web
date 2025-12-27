<script setup lang="ts">
import { ref } from 'vue'
import { supabase } from '@/lib/supabase'
import { doctors, branches, services, galleryImages } from '@/data/hospitalData'
import { Database, Upload, CheckCircle, AlertCircle, Loader2 } from 'lucide-vue-next'

definePageMeta({
  layout: 'default'
})

const loading = ref(false)
const status = ref('')
const error = ref('')
const logs = ref<string[]>([])

const log = (message: string) => {
  logs.value.push(`${new Date().toLocaleTimeString()} - ${message}`)
}

const seedDatabase = async () => {
  loading.value = true
  status.value = 'Starting seed process...'
  error.value = ''
  logs.value = []

  try {
    // Seed Branches
    log('Seeding Branches...')
    const { error: branchError } = await supabase
      .from('branches')
      .upsert(branches.map(b => ({
        id: b.id,
        name: b.name,
        address: b.address,
        phone: b.phone,
        email: b.email,
        map_url: b.mapUrl,
        image: b.image
      })))
    
    if (branchError) throw branchError
    log('Branches seeded successfully.')

    // Seed Services
    log('Seeding Services...')
    // Note: Services in hospitalData use Icon components directly. 
    // We need to map them to strings for the DB if we haven't already.
    // However, the SQL schema expects 'icon_name'.
    // We'll perform a basic mapping based on ID or manual check.
    
    const getIconName = (id: string) => {
      const map: Record<string, string> = {
        'cardiology': 'Heart',
        'pediatrics': 'Baby',
        'neurology': 'Brain',
        'orthopedics': 'Bone',
        'ophthalmology': 'Eye',
        'general-medicine': 'Stethoscope',
        'emergency': 'Ambulance',
        'diagnostics': 'Scan'
      }
      return map[id] || 'Activity'
    }

    const { error: serviceError } = await supabase
      .from('services')
      .upsert(services.map(s => ({
        id: s.id,
        title: s.title,
        description: s.description,
        full_description: s.fullDescription,
        color: s.color,
        bg_color: s.bgColor,
        features: s.features,
        icon_name: getIconName(s.id)
      })))

    if (serviceError) throw serviceError
    log('Services seeded successfully.')

    // Seed Doctors
    log('Seeding Doctors...')
    const { error: doctorError } = await supabase
      .from('doctors')
      .upsert(doctors.map(d => ({
        id: d.id,
        name: d.name,
        specialty: d.specialty,
        experience: d.experience,
        rating: d.rating,
        image: typeof d.image === 'string' ? d.image : '/images/placeholder-doctor.jpg', // Handle imported images if necessary
        branch_id: d.branchId,
        education: d.education,
        bio: d.bio,
        languages: d.languages,
        available_days: d.availableDays,
        role: d.isDoctor ? 'doctor' : 'staff'
      })))

    if (doctorError) throw doctorError
    log('Doctors seeded successfully.')

    // Seed Gallery
    log('Seeding Gallery...')
    const { error: galleryError } = await supabase
      .from('gallery_items')
      .upsert(galleryImages.map(g => ({
        id: g.id,
        src: g.src,
        alt: g.alt,
        category: g.category
      })))

    if (galleryError) throw galleryError
    log('Gallery seeded successfully.')

    status.value = 'Database seeded successfully!'

  } catch (err: any) {
    console.error(err)
    error.value = err.message || 'An error occurred during seeding.'
    log(`ERROR: ${error.value}`)
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="min-h-screen pt-24 pb-12 px-4 sm:px-6 lg:px-8 bg-muted/30">
    <div class="max-w-3xl mx-auto">
      <div class="bg-card rounded-2xl shadow-medical border border-border overflow-hidden">
        <div class="p-8 border-b border-border">
          <div class="flex items-center gap-4 mb-4">
            <div class="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center">
              <Database class="w-6 h-6 text-primary" />
            </div>
            <div>
              <h1 class="heading-md">Database Seeder</h1>
              <p class="text-muted-foreground">Populate your Supabase database with initial data</p>
            </div>
          </div>

          <div class="bg-blue-50 text-blue-800 p-4 rounded-lg flex gap-3 text-sm">
            <AlertCircle class="w-5 h-5 shrink-0" />
            <p>
              Warning: This will overwrite existing data with the same IDs in your Supabase tables. 
              Ensure your tables are created according to the <code>supabase_schema.sql</code> file before running.
            </p>
          </div>
        </div>

        <div class="p-8">
          <button
            @click="seedDatabase"
            :disabled="loading"
            class="btn-primary w-full py-4 flex items-center justify-center gap-2 mb-8"
          >
            <Loader2 v-if="loading" class="w-5 h-5 animate-spin" />
            <Upload v-else class="w-5 h-5" />
            {{ loading ? 'Seeding Database...' : 'Seed Database Now' }}
          </button>

          <div v-if="logs.length > 0" class="bg-black/90 rounded-lg p-4 font-mono text-sm h-64 overflow-y-auto">
            <div v-for="(log, index) in logs" :key="index" class="mb-1" :class="log.includes('ERROR') ? 'text-red-400' : 'text-green-400'">
              {{ log }}
            </div>
          </div>
          
          
          <div v-if="status && !loading && !error" class="mt-6 flex items-center justify-center gap-2 text-green-600 font-medium">
            <CheckCircle class="w-5 h-5" />
            {{ status }}
          </div>
          
          <!-- Admin Helper -->
          <div class="mt-12 pt-8 border-t border-border">
            <h3 class="heading-sm mb-4">Admin Setup Helper</h3>
            <p class="text-sm text-muted-foreground mb-4">
              To access the Admin Dashboard, you need to be a registered user with the 'admin' role.
              <br>1. Go to <NuxtLink to="/admin" class="text-primary underline">/admin</NuxtLink> and sign up.
              <br>2. Copy your User ID (UUID) from the Supabase Authentication dashboard (or see below if logged in).
              <br>3. Run the following SQL in your Supabase SQL Editor:
            </p>
            <div class="bg-muted p-4 rounded-lg font-mono text-xs overflow-x-auto">
              INSERT INTO user_roles (user_id, role) VALUES ('YOUR_USER_ID_HERE', 'admin');
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
