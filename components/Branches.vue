<script setup lang="ts">
import { MapPin, Phone, ArrowRight, Users } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'

interface Branch {
  id: string
  name: string
  address: string
  phone: string
  email: string
  map_url: string
  image: string
}

const { data: branches } = await useAsyncData<Branch[]>('branches-home', async () => {
  const { data } = await supabase
    .from('branches')
    .select('*')
    .order('address', { ascending: true })
  return (data as Branch[]) || []
})

// Fetch all doctors for counts and images
const { data: doctors } = await useAsyncData('doctors-home', async () => {
  const { data } = await supabase
    .from('doctors')
    .select('id, name, image, branch_id')
    .eq('role', 'doctor')
  return (data as any[]) || []
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
  <section id="branches" class="section-padding bg-muted/30">
    <div class="section-container">
      <!-- Section Header -->
      <!-- Section Header -->
      <div class="text-center max-w-2xl mx-auto mb-16">
        <span class="text-secondary font-semibold tracking-wide uppercase text-sm">
          আমাদের অবস্থান
        </span>
        <h2 class="heading-lg text-foreground mt-3 mb-4">
          হাসপাতাল শাখাসমূহ
        </h2>
        <p class="text-muted-foreground text-lg">
          আপনার নিকটস্থ এনএসএস মা স্বাস্থ্য সেবা কেন্দ্র শাখা খুঁজুন। সুবিধাজনক একাধিক স্থানে মানসম্মত স্বাস্থ্যসেবা উপলব্ধ।
        </p>
      </div>

      <!-- Branches Grid -->
      <div class="grid md:grid-cols-2 gap-6 lg:gap-8">
        <div
          v-for="branch in branches"
          :key="branch.id"
          class="card-hover overflow-hidden group"
        >
          <!-- Image -->
          <div class="relative h-48 overflow-hidden">
            <img
              :src="branch.image"
              :alt="branch.name"
              loading="lazy"
              class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
            />
            <div class="absolute inset-0 bg-gradient-to-t from-foreground/60 via-transparent to-transparent" />
            
            <!-- Doctor Count Badge -->
            <div class="absolute top-4 right-4 bg-white/95 backdrop-blur-md px-3 py-1.5 rounded-full flex items-center gap-1.5 shadow-sm z-10">
              <Users class="w-3.5 h-3.5 text-primary" />
              <span class="text-xs font-bold text-foreground uppercase tracking-wide">{{ getDoctorCount(branch.id) }} ডাক্তার</span>
            </div>

            <div class="absolute bottom-4 left-4 right-4">
              <h3 class="text-xl font-semibold text-primary-foreground">
                {{ branch.name }}
              </h3>
            </div>
          </div>

          <!-- Content -->
          <div class="p-6">
            <div class="space-y-3 mb-6">
              <div class="flex items-start gap-3">
                <MapPin class="w-5 h-5 text-primary mt-0.5 flex-shrink-0" />
                <span class="text-muted-foreground text-sm">{{ branch.address }}</span>
              </div>
              <div class="flex items-center gap-3">
                <Phone class="w-5 h-5 text-primary" />
                <a 
                  :href="`tel:${branch.phone}`" 
                  class="text-muted-foreground text-sm hover:text-primary transition-colors"
                >
                  {{ branch.phone }}
                </a>
              </div>
              <!-- Doctor count section removed -->
            </div>

            <NuxtLink 
              :to="`/doctors?branch=${branch.address}`"
              class="inline-flex items-center gap-2 text-primary font-medium text-sm group-hover:gap-3 transition-all"
            >
              এই শাখার ডাক্তারদের দেখুন
              <ArrowRight class="w-4 h-4" />
            </NuxtLink>
          </div>
        </div>
      </div>

      <!-- CTA -->
      <div class="text-center mt-12">
        <NuxtLink to="/branches" class="btn-primary">
          সকল শাখা দেখুন
        </NuxtLink>
      </div>
    </div>
  </section>
</template>
