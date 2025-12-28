<script setup lang="ts">
import { MapPin, Phone, Mail, Clock, Users, ArrowRight, UserCheck } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'

useHead({
  title: 'Branches & Locations | Maa Health Service Center',
  meta: [
    { name: 'description', content: 'Find your nearest NSS Maa Health Service Center branch. Convenient healthcare locations in Barguna and Patuakhali.' }
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
  const { data } = await supabase.from('branches').select('*').order('sequence', { ascending: true, nullsFirst: false })
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
    .order('sequence', { ascending: true, nullsFirst: false })
  return (data as any) || []
})

const getDoctorCount = (branchId: string) => {
  return (doctors.value || []).filter((d) => d.branch_id === branchId && d.role === 'doctor').length
}

const getManager = (branchAddress: string) => {
  return (doctors.value || []).find((d) => d.branch_id === branchAddress && d.role === 'management')
}

const getBranchDoctors = (branchId: string) => {
  return (doctors.value || []).filter((d) => d.branch_id === branchId && d.role === 'doctor').slice(0, 3)
}

const getImageUrl = (path: string) => {
  if (!path) return ''
  if (path.startsWith('http')) return path
  const { data } = supabase.storage.from('images').getPublicUrl(path)
  return data.publicUrl
}

const getManagerImageUrl = (branchAddress: string) => {
  const manager = getManager(branchAddress)
  if (!manager?.image) return ''
  return getImageUrl(manager.image)
}

</script>

<template>
  <div class="min-h-screen bg-background">
    <!-- Hero Section -->
    <section class="pt-32 pb-16 bg-gradient-to-br from-primary/5 via-background to-secondary/5">
      <div class="section-container text-center">
        <span class="text-secondary font-semibold tracking-wide uppercase text-sm" data-aos="fade-down" data-aos-delay="0">
          আমাদের অবস্থান
        </span>
        <h1 class="heading-xl text-foreground mt-3 mb-6" data-aos="fade-down" data-aos-delay="100">
          হাসপাতাল শাখাসমূহ
        </h1>
        <p class="text-muted-foreground text-lg max-w-2xl mx-auto" data-aos="fade-down" data-aos-delay="200">
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
            class="h-full"
            data-aos="fade-up"
            data-aos-offset="100"
          >
            <!-- Pass doctors array; component handles filtering -->
             <LazyBranchCard 
              :branch="branch" 
              :doctors="doctors || []"
              layout="horizontal"
              :flipped="index % 2 !== 0"
             />
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
