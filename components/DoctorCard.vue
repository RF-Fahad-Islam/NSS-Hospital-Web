<script setup lang="ts">
import { Star, MapPin, Calendar, ArrowRight, Stethoscope, Briefcase, Users } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'
import { computed } from 'vue'

export interface Doctor {
  id: string
  name: string
  specialty: string
  experience: string
  rating: number
  image: string
  branch_id?: string
  available_days?: string[]
  bio?: string
  role?: string
  branches?: {
    name?: string
    address?: string
    phone?: string
  } | null
}

const props = defineProps<{
  doctor: Doctor
  showAvailability?: boolean
}>()

const {
  doctor,
  showAvailability = true
} = props

const getImageUrl = (path: string) => {
  if (!path) return ''
  if (path.startsWith('http')) return path
  const { data } = supabase.storage.from('doctors').getPublicUrl(path)
  return data.publicUrl
}

const badgeIcon = computed(() => {
  const role = props.doctor.role || 'ডাক্তার'
  if (role === 'ম্যানেজমেন্ট' || role === 'management') return Briefcase
  if (role === 'স্টাফ' || role === 'staff') return Users
  return Stethoscope
})
</script>

<template>
  <div class="doctor-card group h-full flex flex-col border border-border/40 rounded-[1.5rem] overflow-hidden bg-card/50 hover:bg-card transition-all duration-500 ease-[cubic-bezier(0.34,1.56,0.64,1)] hover:-translate-y-2 hover:shadow-xl hover:scale-[1.02]">
    <!-- Image Container -->
    <div class="relative overflow-hidden aspect-[4/5]">
      <img
        :src="getImageUrl(doctor.image)"
        :alt="doctor.name"
        loading="lazy"
        class="w-full h-full object-cover object-center transition-transform duration-700 ease-[cubic-bezier(0.34,1.56,0.64,1)] group-hover:scale-110"
      />
      
      <!-- Badges (Stethoscope) -->
      <div class="absolute top-4 left-4 z-20 flex flex-col gap-2">
        <div class="bg-primary/95 backdrop-blur-md text-primary-foreground px-3 py-1.5 rounded-full flex items-center gap-1.5 shadow-lg transform transition-transform group-hover:scale-105 animate-float">
          <component :is="badgeIcon" class="w-3.5 h-3.5" />
          <span class="text-xs font-bold tracking-wide line-clamp-1 max-w-[150px]">{{ doctor.specialty }}</span>
        </div>
      </div>

      <!-- Gradient Overlay -->
      <div class="absolute inset-0 bg-gradient-to-t from-foreground/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500 pointer-events-none"></div>

      <!-- Hover Overlay Content / Button -->
      <div class="absolute bottom-0 left-0 right-0 p-4 translate-y-full group-hover:translate-y-0 transition-transform duration-500 ease-[cubic-bezier(0.34,1.56,0.64,1)]">
        <NuxtLink
          :to="`/doctors/${doctor.id}`"
          class="btn-primary w-full justify-center text-sm py-3 rounded-xl shadow-lg"
        >
          প্রোফাইল দেখুন
          <ArrowRight class="w-4 h-4 ml-2" />
        </NuxtLink>
      </div>
    </div>

    <!-- Info -->
    <div class="p-5 flex-grow flex flex-col justify-between relative z-10 bg-card/50 backdrop-blur-sm group-hover:bg-card transition-colors duration-300">
      <div>
        <div class="flex items-center gap-1 mb-2">
          <Star class="w-4 h-4 fill-yellow-400 text-yellow-400 animate-pulse" />
          <span class="text-sm font-medium text-foreground">{{ doctor.rating }}</span>
          <span class="text-sm text-muted-foreground">• {{ doctor.experience }}</span>
        </div>
        
        <h3 class="font-semibold text-lg text-foreground mb-1 group-hover:text-primary transition-colors line-clamp-1" :title="doctor.name">
          {{ doctor.name }}
        </h3>
        <p class="text-sm text-secondary font-medium line-clamp-1 mb-2" :title="doctor.specialty">{{ doctor.specialty }}</p>

        <!-- Available Days -->
        <div v-if="showAvailability && doctor.available_days && doctor.available_days.length > 0" class="flex items-center gap-2 text-xs text-muted-foreground mb-2">
           <Calendar class="w-3 h-3" />
           <span class="line-clamp-1">{{ doctor.available_days.join(', ') }}</span>
        </div>

        <!-- Optional Bio or Days (Desktop/Detailed view mainly) -->

      </div>

      <!-- Footer: Branch Info -->
      <div v-if="doctor.branches" class="mt-4 pt-3 border-t border-border/50 flex items-start gap-2 group-hover:border-primary/20 transition-colors">
          <MapPin class="w-3.5 h-3.5 text-muted-foreground mt-0.5 group-hover:text-primary transition-colors" />
          <div class="text-xs text-muted-foreground group-hover:text-foreground transition-colors">
            <p class="font-medium line-clamp-1">{{ doctor.branches.name }}</p>
            <p class="line-clamp-1 opacity-80" :title="doctor.branches.address">{{ doctor.branches.address }}</p>
          </div>
      </div>
    </div>
  </div>
</template>
