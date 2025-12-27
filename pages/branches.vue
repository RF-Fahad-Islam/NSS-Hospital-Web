<script setup lang="ts">
import { MapPin, Phone, Mail, Clock, Users, ArrowRight, UserCheck } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'

useHead({
  title: 'আমাদের অবস্থান - এনএসএস মা স্বাস্থ্য সেবা কেন্দ্র',
  meta: [
    { name: 'description', content: 'আপনার নিকটস্থ এনএসএস মা স্বাস্থ্য সেবা কেন্দ্রের শাখা খুঁজুন।' }
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
  manager_name?: string
}

const searchQuery = ref('')

interface Doctor {
  id: string
  name: string
  image: string
  branch_id: string
  role?: 'doctor' | 'staff' | 'management'
}

// Fetch branches
const { data: rawBranches } = await useAsyncData<Branch[]>('branches-page', async () => {
  const { data } = await supabase.from('branches').select('*')
  return (data as any) || []
})

const filteredBranches = computed(() => {
  const list = rawBranches.value || []
  if (!searchQuery.value.trim()) return list
  
  const query = searchQuery.value.toLowerCase().trim()
  return list.filter(branch => 
    branch.name.toLowerCase().includes(query) || 
    branch.address.toLowerCase().includes(query)
  )
})

// Fetch all doctors for counts and management for display
const { data: doctors } = await useAsyncData<Doctor[]>('doctors-all', async () => {
  const { data } = await supabase
    .from('doctors')
    .select('id, name, image, branch_id, role')
  return (data as any) || []
})

const getDoctorCount = (branchId: string) => {
  return (doctors.value || []).filter((d) => d.branch_id === branchId && d.role === 'doctor').length
}

const getManager = (branchAddress: string) => {
  return (doctors.value || []).find((d) => d.branch_id === branchAddress && d.role === 'management')
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
          আমাদের অবস্থান
        </span>
        <h1 class="heading-xl text-foreground mt-3 mb-6">
          হাসপাতাল শাখাসমূহ
        </h1>
        <p class="text-muted-foreground text-lg max-w-2xl mx-auto">
          আপনার নিকটস্থ এনএসএস মা স্বাস্থ্য সেবা কেন্দ্র খুঁজুন। আমাদের প্রতিটি শাখাই একই উচ্চ মানের সেবার সাথে ব্যাপক চিকিৎসা সেবা প্রদান করে।
        </p>
      </div>
    </section>

    <!-- Search Section -->
    <section class="py-12 border-b border-border bg-card/50">
      <div class="section-container max-w-2xl">
        <div class="relative">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="শাখার নাম বা অবস্থান দ্বারা অনুসন্ধান করুন..."
            class="w-full pl-12 pr-4 py-4 rounded-2xl border border-border bg-background focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all shadow-sm"
          />
          <svg
            class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
            />
          </svg>
        </div>
      </div>
    </section>

    <section class="section-padding">
      <div class="section-container">
        <div v-if="filteredBranches.length === 0" class="text-center py-20">
          <MapPin class="w-12 h-12 text-muted-foreground mx-auto mb-4 opacity-20" />
          <p class="text-muted-foreground text-lg">আপনার অনুসন্ধানের সাথে মিল রেখে কোনও শাখা পাওয়া যায়নি।</p>
        </div>
        <div v-else class="space-y-12">
          <div 
            v-for="(branch, index) in filteredBranches"
            :key="branch.address"
            class="flex flex-col lg:flex-row gap-8 items-stretch card-hover p-0 overflow-hidden"
            :class="{ 'lg:flex-row-reverse': index % 2 === 1 }"
          >
            <!-- Image -->
            <div class="w-full lg:w-2/5 relative group">
              <img
                :src="getImageUrl(branch.image)"
                :alt="branch.name"
                loading="lazy"
                class="w-full h-64 lg:h-full object-cover transition-transform duration-500 group-hover:scale-105"
              />
              <div class="absolute top-6 left-6 bg-primary text-primary-foreground px-4 py-2 rounded-full flex items-center gap-2 shadow-lg z-10">
                <Users class="w-4 h-4" />
                <span class="text-sm font-bold tracking-wide">{{ getDoctorCount(branch.address) }} ডাক্তার</span>
              </div>
              
              <!-- Manager Badge -->
              <div v-if="getManager(branch.address)" class="absolute bottom-6 right-6 bg-white/95 backdrop-blur-sm rounded-lg px-3 py-2 flex items-center gap-2 shadow-lg z-10 border border-primary/20">
                <img 
                  :src="getManager(branch.address)?.image || '/images/placeholder-doctor.jpg'" 
                  :alt="getManager(branch.address)?.name"
                  class="w-8 h-8 rounded-full object-cover border-2 border-primary"
                />
                <div class="text-left">
                  <div class="text-[10px] text-muted-foreground uppercase tracking-wide">Manager</div>
                  <div class="text-sm font-semibold text-foreground leading-tight">{{ getManager(branch.address)?.name }}</div>
                </div>
              </div>
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
                 <div v-if="branch.manager_name" class="flex items-center gap-3">
                  <UserCheck class="w-5 h-5 text-primary" />
                  <span class="text-muted-foreground">Manager: {{ branch.manager_name }}</span>
                </div>
                <div class="flex items-center gap-3">
                  <Clock class="w-5 h-5 text-primary" />
                  <span class="text-muted-foreground">২৪/৭ খোলা</span>
                </div>
              </div>

              <!-- Doctors at this branch -->
              <div class="border-t border-border pt-6 mb-6">
                <div class="flex items-center gap-2 mb-4">
                  <Users class="w-5 h-5 text-secondary" />
                  <span class="font-medium text-foreground">
                    {{ getDoctorCount(branch.address) }} ডাক্তার এই শাখায় আছেন
                  </span>
                </div>
                
                <div class="flex -space-x-3 mb-4">
                    <img
                    v-for="doctor in getBranchDoctors(branch.address)"
                    :key="doctor.id"
                    :src="getImageUrl(doctor.image)"
                    :alt="doctor.name"
                    loading="lazy"
                    class="w-12 h-12 rounded-full border-2 border-background object-cover"
                    :title="doctor.name"
                  />
                  <div v-if="getDoctorCount(branch.address) > 3" class="w-12 h-12 rounded-full border-2 border-background bg-muted flex items-center justify-center text-sm font-medium text-muted-foreground">
                    +{{ getDoctorCount(branch.address) - 3 }}
                  </div>
                </div>
              </div>

              <div class="flex flex-wrap gap-4">
                <NuxtLink 
                  :to="`/doctors?branch=${branch.address}`"
                  class="btn-primary inline-flex items-center gap-2"
                >
                  ডাক্তারদের দেখুন
                  <ArrowRight class="w-4 h-4" />
                </NuxtLink>
                <a 
                  :href="branch.map_url"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="btn-ghost"
                >
                  দিকের নির্দেশনা পান
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
          <h2 class="heading-lg text-foreground mb-4">মানচিত্রে আমাদের খুঁজুন</h2>
          <p class="text-muted-foreground text-lg">
            আমাদের সমস্ত শাখা সহজ অ্যাক্সেসের জন্য সুবিধাজনকভাবে অবস্থিত।
          </p>
        </div>
        <div class="aspect-[16/9] max-h-[500px] rounded-2xl overflow-hidden bg-muted flex items-center justify-center">
          <div class="text-center">
            <MapPin class="w-16 h-16 text-muted-foreground mx-auto mb-4" />
            <p class="text-muted-foreground">ইন্টারঅ্যাক্টিভ ম্যাপ শীঘ্রই আসছে</p>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>
