<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { Star, MapPin, Calendar, ArrowRight } from 'lucide-vue-next'
// import { doctors, branches } from '@/data/hospitalData' // Replaced with Supabase
import { supabase } from '@/lib/supabase'

interface Doctor {
  id: string
  name: string
  specialty: string
  experience: string
  rating: number
  image: string
  branch_id: string
  available_days: string[]
  bio: string
  branches?: {
    address: string
    name: string
  } | null
}

useHead({
  title: 'Our Team - NSS',
  meta: [
    { name: 'description', content: 'Meet our team of expert doctors and specialists.' }
  ]
})

const route = useRoute()
const router = useRouter()
const branchParam = route.query.branch as string
const selectedBranch = ref<string>(branchParam || 'all')

// Fetch branches for filter
const { data: branches } = await useAsyncData('branches-list', async () => {
  const { data } = await supabase
    .from('branches')
    .select('*')
    .order('address', { ascending: true })
  return data || []
})

// Fetch doctors with branch details
const { data: doctors } = await useAsyncData<Doctor[]>('doctors-list', async () => {
  const { data } = await supabase
    .from('doctors')
    .select('*, branches(name, address)')
  return (data as Doctor[]) || []
})


const filteredDoctors = computed(() => {
  const list = doctors.value || []
  if (selectedBranch.value === 'all') return list
  
  // Filter by branch address
  return list.filter(doctor => {
    return doctor.branches?.address === selectedBranch.value
  })
})

const getBranchName = (branchId: string) => {
  const branch = (branches.value || []).find(b => b.id === branchId)
  return branch ? branch.name : branchId
}

const setBranch = (address: string) => {
  selectedBranch.value = address
  router.push({ query: { ...route.query, branch: address } })
}

// Watch route query changes (e.g. back button)
watch(() => route.query.branch, (newBranch) => {
  if (newBranch) {
    selectedBranch.value = newBranch as string
  } else {
    selectedBranch.value = 'all'
  }
})

const getImageUrl = (path: string) => {
  if (!path) return ''
  if (path.startsWith('http')) return path
  const { data } = supabase.storage.from('doctors').getPublicUrl(path)
  return data.publicUrl
}
</script>

<template>
  <div class="min-h-screen bg-background">
    <!-- Hero Section -->
    <section class="pt-32 pb-16 bg-gradient-to-br from-primary/5 via-background to-secondary/5">
      <div class="section-container text-center">
        <span class="text-secondary font-semibold tracking-wide uppercase text-sm">
          Our Medical Team
        </span>
        <h1 class="heading-xl text-foreground mt-3 mb-6">
          Meet Our Medical Staff
        </h1>
        <p class="text-muted-foreground text-lg max-w-2xl mx-auto">
          Our team of highly qualified physicians brings decades of experience 
          and genuine commitment to your well-being.
        </p>
      </div>
    </section>

    <!-- Filter Section -->
    <section class="py-8 border-b border-border">
      <div class="section-container">
        <div class="flex flex-wrap items-center gap-4">
          <span class="text-foreground font-medium">Filter by Branch:</span>
          <div class="flex flex-wrap gap-2">
            <button
              @click="setBranch('all')"
              class="px-4 py-2 rounded-full text-sm font-medium transition-all"
              :class="selectedBranch === 'all' ? 'bg-primary text-primary-foreground' : 'bg-muted text-muted-foreground hover:bg-muted/80'"
            >
              All Branches
            </button>
            <button
              v-for="branch in branches"
              :key="branch.id"
              @click="setBranch(branch.address)"
              class="px-4 py-2 rounded-full text-sm font-medium transition-all"
              :class="selectedBranch === branch.address ? 'bg-primary text-primary-foreground' : 'bg-muted text-muted-foreground hover:bg-muted/80'"
            >
              {{ branch.address }}
            </button>
          </div>
        </div>
      </div>
    </section>

    <section class="section-padding">
      <div class="section-container">
        <div v-if="filteredDoctors.length === 0" class="text-center py-16">
          <p class="text-muted-foreground text-lg">No doctors found for this branch.</p>
        </div>
        <div v-else class="grid sm:grid-cols-2 lg:grid-cols-3 gap-8">
          <div v-for="doctor in filteredDoctors" :key="doctor.id" class="doctor-card group">
            <!-- Image Container -->
            <div class="relative overflow-hidden aspect-[4/5]">
              <img
                :src="getImageUrl(doctor.image)"
                :alt="doctor.name"
                loading="lazy"
                class="w-full h-full object-cover object-center transition-transform duration-500 group-hover:scale-105"
              />
              <div class="absolute inset-0 bg-gradient-to-t from-foreground/60 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
            </div>

            <!-- Info -->
            <div class="p-6">
              <div class="flex items-center gap-1 mb-3">
                <Star class="w-4 h-4 fill-yellow-400 text-yellow-400" />
                <span class="text-sm font-medium text-foreground">{{ doctor.rating }}</span>
                <span class="text-sm text-muted-foreground">• {{ doctor.experience }}</span>
              </div>
              
              <h3 class="text-xl font-semibold text-foreground mb-1 group-hover:text-primary transition-colors">
                {{ doctor.name }}
              </h3>
              <p class="text-secondary font-medium mb-3">{{ doctor.specialty }}</p>
              
              <div class="flex items-center gap-2 text-sm text-muted-foreground mb-4">
                <MapPin class="w-4 h-4" />
                <span>{{ doctor.branches?.address || getBranchName(doctor.branch_id) }}</span>
              </div>

              <div class="flex items-center gap-2 text-sm text-muted-foreground mb-4">
                <Calendar class="w-4 h-4" />
                <span>{{ doctor.available_days ? doctor.available_days.join(', ') : '' }}</span>
              </div>

              <p class="text-muted-foreground text-sm mb-4 line-clamp-2">
                {{ doctor.bio }}
              </p>

              <NuxtLink 
                :to="`/doctors/${doctor.id}`"
                class="inline-flex items-center gap-2 text-primary font-medium text-sm hover:gap-3 transition-all"
              >
                View Full Profile
                <ArrowRight class="w-4 h-4" />
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="section-padding bg-muted/50">
      <div class="section-container text-center">
        <h2 class="heading-lg text-foreground mb-4">
          Ready to Book an Appointment?
        </h2>
        <p class="text-muted-foreground text-lg mb-8 max-w-2xl mx-auto">
          Schedule a consultation with any of our expert physicians today.
        </p>
        <NuxtLink to="/#appointment" class="btn-primary">
          Book Appointment
        </NuxtLink>
      </div>
    </section>
  </div>
</template>
