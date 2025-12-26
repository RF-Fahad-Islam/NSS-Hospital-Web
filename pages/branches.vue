<script setup lang="ts">
import { MapPin, Phone, Mail, Clock, Users, ArrowRight } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'

useHead({
  title: 'Our Locations - NSS Ma Shastho Seba Kendra',
  meta: [
    { name: 'description', content: 'Find an NSS Ma Shastho Seba Kendra branch near you.' }
  ]
})

interface Branch {
  id: string
  name: string
  image: string
  address: string
  phone: string
  email: string
  map_url: string
}

interface Doctor {
  id: string
  name: string
  image: string
  branch_id: string
}

// Fetch branches
const { data: branches } = await useAsyncData<Branch[]>('branches-page', async () => {
  const { data } = await supabase.from('branches').select('*')
  return (data as any) || []
})

// Fetch all doctors for counts
const { data: doctors } = await useAsyncData<Doctor[]>('doctors-all', async () => {
  const { data } = await supabase.from('doctors').select('id, name, image, branch_id')
  return (data as any) || []
})

const getDoctorCount = (branchId: string) => {
  return (doctors.value || []).filter((d) => d.branch_id === branchId).length
}

const getBranchDoctors = (branchId: string) => {
  return (doctors.value || []).filter((d) => d.branch_id === branchId).slice(0, 3)
}

const getImageUrl = (path: string) => {
  if (!path) return ''
  if (path.startsWith('http')) return path
  const { data } = supabase.storage.from('images').getPublicUrl(path)
  return data.publicUrl
}
</script>

<template>
  <div class="min-h-screen bg-background">
    <!-- Hero Section -->
    <section class="pt-32 pb-16 bg-gradient-to-br from-primary/5 via-background to-secondary/5">
      <div class="section-container text-center">
        <span class="text-secondary font-semibold tracking-wide uppercase text-sm">
          Our Locations
        </span>
        <h1 class="heading-xl text-foreground mt-3 mb-6">
          Hospital Branches
        </h1>
        <p class="text-muted-foreground text-lg max-w-2xl mx-auto">
          Find an NSS Ma Shastho Seba Kendra location near you. Each of our branches offers 
          comprehensive medical services with the same high standards of care.
        </p>
      </div>
    </section>

    <!-- Branches List -->
    <section class="section-padding">
      <div class="section-container">
        <div class="space-y-12">
          <div 
            v-for="(branch, index) in branches"
            :key="branch.id"
            class="flex flex-col lg:flex-row gap-8 items-stretch card-hover p-0 overflow-hidden"
            :class="{ 'lg:flex-row-reverse': index % 2 === 1 }"
          >
            <!-- Image -->
            <div class="w-full lg:w-2/5">
              <img
                :src="getImageUrl(branch.image)"
                :alt="branch.name"
                loading="lazy"
                class="w-full h-64 lg:h-full object-cover"
              />
            </div>

            <!-- Content -->
            <div class="w-full lg:w-3/5 p-8">
              <h2 class="heading-md text-foreground mb-4">{{ branch.name }}</h2>
              
              <div class="space-y-3 mb-6">
                <div class="flex items-start gap-3">
                  <MapPin class="w-5 h-5 text-primary mt-0.5" />
                  <span class="text-muted-foreground">{{ branch.address }}</span>
                </div>
                <div class="flex items-center gap-3">
                  <Phone class="w-5 h-5 text-primary" />
                  <a :href="`tel:${branch.phone}`" class="text-muted-foreground hover:text-primary transition-colors">
                    {{ branch.phone }}
                  </a>
                </div>
                <div class="flex items-center gap-3">
                  <Mail class="w-5 h-5 text-primary" />
                  <a :href="`mailto:${branch.email}`" class="text-muted-foreground hover:text-primary transition-colors">
                    {{ branch.email }}
                  </a>
                </div>
                <div class="flex items-center gap-3">
                  <Clock class="w-5 h-5 text-primary" />
                  <span class="text-muted-foreground">Open 24/7</span>
                </div>
              </div>

              <!-- Doctors at this branch -->
              <div class="border-t border-border pt-6 mb-6">
                <div class="flex items-center gap-2 mb-4">
                  <Users class="w-5 h-5 text-secondary" />
                  <span class="font-medium text-foreground">
                    {{ getDoctorCount(branch.id) }} Doctors at this branch
                  </span>
                </div>
                
                <div class="flex -space-x-3 mb-4">
                    <img
                    v-for="doctor in getBranchDoctors(branch.id)"
                    :key="doctor.id"
                    :src="getImageUrl(doctor.image)"
                    :alt="doctor.name"
                    loading="lazy"
                    class="w-12 h-12 rounded-full border-2 border-background object-cover"
                    :title="doctor.name"
                  />
                  <div v-if="getDoctorCount(branch.id) > 3" class="w-12 h-12 rounded-full border-2 border-background bg-muted flex items-center justify-center text-sm font-medium text-muted-foreground">
                    +{{ getDoctorCount(branch.id) - 3 }}
                  </div>
                </div>
              </div>

              <div class="flex flex-wrap gap-4">
                <NuxtLink 
                  :to="`/doctors?branch=${branch.id}`"
                  class="btn-primary inline-flex items-center gap-2"
                >
                  View Doctors
                  <ArrowRight class="w-4 h-4" />
                </NuxtLink>
                <a 
                  :href="branch.map_url"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="btn-ghost"
                >
                  Get Directions
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Map Section Placeholder -->
    <section class="section-padding bg-muted/50">
      <div class="section-container">
        <div class="text-center mb-12">
          <h2 class="heading-lg text-foreground mb-4">Find Us on the Map</h2>
          <p class="text-muted-foreground text-lg">
            All our branches are conveniently located for easy access.
          </p>
        </div>
        <div class="aspect-[16/9] max-h-[500px] rounded-2xl overflow-hidden bg-muted flex items-center justify-center">
          <div class="text-center">
            <MapPin class="w-16 h-16 text-muted-foreground mx-auto mb-4" />
            <p class="text-muted-foreground">Interactive Map Coming Soon</p>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>
