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
  role?: 'doctor' | 'staff' | 'management'
}

useHead({
  title: 'আমাদের টিম - এনএসএস',
  meta: [
    { name: 'description', content: 'আমাদের বিশেষজ্ঞ ডাক্তার এবং বিশেষজ্ঞদের দলের সাথে পরিচিত হোন।' }
  ]
})

const route = useRoute()
const router = useRouter()
const branchParam = route.query.branch as string
const selectedBranch = ref<string>(branchParam || 'all')
const selectedCategory = ref<'all' | 'doctors' | 'staff' | 'management'>('all')
const searchQuery = ref('')
const showBranchModal = ref(false)

interface Branch {
  id: string
  name: string
  address: string
  phone: string
}

// Fetch branches for filter
const { data: branches } = await useAsyncData<Branch[]>('branches-list', async () => {
  const { data } = await supabase
    .from('branches')
    .select('*')
    .order('sequence', { ascending: true, nullsFirst: false })
  return (data as Branch[]) || []
})

// Function to dial a branch phone number
const dialBranch = (phone: string) => {
  window.location.href = `tel:${phone}`
  showBranchModal.value = false
}

// Fetch doctors with branch details
const { data: doctors } = await useAsyncData<Doctor[]>('doctors-list', async () => {
  const { data } = await supabase
    .from('doctors')
    .select('*, branches(name, address)')
    .order('sequence', { ascending: true, nullsFirst: false })
  return (data as Doctor[]) || []
})


const filteredDoctors = computed(() => {
  let list = doctors.value || []
  
  // Filter by Category (All, Doctor, Staff, Management)
  if (selectedCategory.value !== 'all') {
    const roleMap: Record<string, 'doctor' | 'staff' | 'management'> = {
      'doctors': 'doctor',
      'staff': 'staff',
      'management': 'management'
    }
    list = list.filter(d => d.role === roleMap[selectedCategory.value])
  }

  // Filter by branch address
  if (selectedBranch.value !== 'all') {
    list = list.filter(doctor => {
      // 1. Check if the joined branch address matches
      if (doctor.branches?.address === selectedBranch.value) return true
      
      // 2. Check if the param is actually an ID (backward compatibility)
      if (doctor.branch_id === selectedBranch.value) return true

      // 3. Fallback: Find the branch in our local branches list by ID, and compare addresses
      // This handles cases where the DB Foreign Key join might impede fetching the address
      const branch = (branches.value || []).find(b => b.id === doctor.branch_id)
      return branch?.address === selectedBranch.value
    })
  }

  // Filter by search query (name or specialty)
  if (searchQuery.value.trim()) {
    const query = searchQuery.value.toLowerCase().trim()
    list = list.filter(doctor => 
      doctor.name.toLowerCase().includes(query) || 
      doctor.specialty.toLowerCase().includes(query)
    )
  }
  
  return list
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
          আমাদের মেডিকেল টিম
        </span>
        <h1 class="heading-xl text-foreground mt-3 mb-6">
          আমাদের মেডিকেল স্টাফদের সাথে পরিচিত হোন
        </h1>
        <p class="text-muted-foreground text-lg max-w-2xl mx-auto">
          আমাদের উচ্চ যোগ্যতাসম্পন্ন চিকিৎসকদের দল দীর্ঘদিনের অভিজ্ঞতা এবং আপনার সুস্থতার প্রতি অকৃত্রিম প্রতিশ্রুতি নিয়ে সেবা প্রদান করেন।
        </p>
      </div>
    </section>

    <!-- Filter & Search Section -->
    <section class="py-8 bg-card border-b border-border sticky top-20 z-40 backdrop-blur-md bg-card/80">
      <div class="section-container">
        <div class="flex flex-col gap-6">
          
          <!-- Category Tabs -->
          <div class="flex justify-center md:justify-start">
            <div class="bg-muted p-1 rounded-xl inline-flex">
              <button 
                @click="selectedCategory = 'all'"
                class="px-6 py-2.5 rounded-lg text-sm font-semibold transition-all"
                :class="selectedCategory === 'all' ? 'bg-background text-primary shadow-sm' : 'text-muted-foreground hover:text-foreground'"
              >
                সকল
              </button>
              <button 
                @click="selectedCategory = 'doctors'"
                class="px-6 py-2.5 rounded-lg text-sm font-semibold transition-all"
                :class="selectedCategory === 'doctors' ? 'bg-background text-primary shadow-sm' : 'text-muted-foreground hover:text-foreground'"
              >
                ডাক্তার
              </button>
              <button 
                @click="selectedCategory = 'staff'"
                class="px-6 py-2.5 rounded-lg text-sm font-semibold transition-all"
                :class="selectedCategory === 'staff' ? 'bg-background text-primary shadow-sm' : 'text-muted-foreground hover:text-foreground'"
              >
                স্টাফ
              </button>
              <button 
                @click="selectedCategory = 'management'"
                class="px-6 py-2.5 rounded-lg text-sm font-semibold transition-all"
                :class="selectedCategory === 'management' ? 'bg-background text-primary shadow-sm' : 'text-muted-foreground hover:text-foreground'"
              >
                ম্যানেজমেন্ট
              </button>
            </div>
          </div>

          <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-6">
            <div class="flex flex-wrap items-center gap-4">
              <span class="text-foreground font-medium whitespace-nowrap">শাখা অনুযায়ী ফিল্টার করুন:</span>
            <div class="flex flex-wrap gap-2">
              <button
                @click="setBranch('all')"
                class="px-4 py-2 rounded-full text-sm font-medium transition-all"
                :class="selectedBranch === 'all' ? 'bg-primary text-primary-foreground' : 'bg-muted text-muted-foreground hover:bg-muted/80'"
              >
                সকল শাখা
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

          <div class="relative w-full lg:w-80">
            <ClientOnly>
              <div class="relative">
                <input
                  v-model="searchQuery"
                  type="text"
                  placeholder="ডাক্তার বা বিশেষত্ব অনুসন্ধান করুন..."
                  class="w-full pl-10 pr-4 py-2.5 rounded-xl border border-border bg-background focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all text-sm"
                />
                <svg
                  class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground"
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
            </ClientOnly>
          </div>
        </div>
      </div>
    </div>
    </section>

    <section class="section-padding">
      <div class="section-container">
        <ClientOnly>
          <div v-if="filteredDoctors.length === 0" class="text-center py-16">
            <p class="text-muted-foreground text-lg">আপনার মানদণ্ডের সাথে মিলে এমন কোনও ডাক্তার পাওয়া যায়নি।</p>
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
                  সম্পূর্ণ প্রোফাইল দেখুন
                  <ArrowRight class="w-4 h-4" />
                </NuxtLink>
              </div>
            </div>
          </div>
          <template #fallback>
            <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-8">
              <div v-for="i in 6" :key="i" class="h-[400px] bg-muted/20 animate-pulse rounded-2xl"></div>
            </div>
          </template>
        </ClientOnly>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="section-padding bg-muted/50">
      <div class="section-container text-center">
        <h2 class="heading-lg text-foreground mb-4">
          অ্যাপয়েন্টমেন্ট নিতে প্রস্তুত?
        </h2>
        <p class="text-muted-foreground text-lg mb-8 max-w-2xl mx-auto">
          আজই আমাদের বিশেষজ্ঞ চিকিৎসকদের সাথে পরামর্শের সময়সূচী করুন।
        </p>
        <button @click="showBranchModal = true" class="btn-primary">
          অ্যাপয়েন্টমেন্ট নিন
        </button>
      </div>
    </section>

    <!-- Branch Selection Modal -->
    <ClientOnly>
      <Teleport to="body">
        <Transition name="modal">
          <div 
            v-if="showBranchModal" 
            class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm"
            @click.self="showBranchModal = false"
          >
            <div class="bg-background rounded-2xl shadow-2xl max-w-4xl w-full max-h-[80vh] overflow-hidden">
              <!-- Modal Header -->
              <div class="sticky top-0 bg-gradient-to-br from-primary/10 via-background to-secondary/10 border-b border-border p-6 flex justify-between items-center">
                <div>
                  <h3 class="text-2xl font-bold text-foreground mb-1">শাখা নির্বাচন করুন</h3>
                  <p class="text-sm text-muted-foreground">কল করতে একটি শাখায় ক্লিক করুন</p>
                </div>
                <button 
                  @click="showBranchModal = false"
                  class="text-muted-foreground hover:text-foreground transition-colors p-2 rounded-lg hover:bg-muted"
                >
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>

              <!-- Modal Body -->
              <div class="p-6 overflow-y-auto max-h-[calc(80vh-120px)]">
                <div class="grid sm:grid-cols-2 gap-4">
                  <button
                    v-for="branch in branches"
                    :key="branch.id"
                    @click="dialBranch(branch.phone)"
                    class="group relative bg-gradient-to-br from-card to-card/50 border border-border rounded-xl p-5 text-left transition-all duration-300 hover:shadow-lg hover:scale-[1.02] hover:border-primary/50 overflow-hidden"
                  >
                    <!-- Animated background gradient on hover -->
                    <div class="absolute inset-0 bg-gradient-to-br from-primary/5 to-secondary/5 opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                    
                    <!-- Content -->
                    <div class="relative z-10">
                      <div class="flex items-start justify-between mb-3">
                        <div class="flex-1">
                          <h4 class="text-lg font-semibold text-foreground mb-1 group-hover:text-primary transition-colors">
                            {{ branch.name }}
                          </h4>
                        </div>
                        <div class="bg-primary/10 text-primary p-2 rounded-lg group-hover:bg-primary group-hover:text-primary-foreground transition-all">
                          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                          </svg>
                        </div>
                      </div>
                      
                      <div class="space-y-2 mb-3">
                        <div class="flex items-start gap-2 text-sm text-muted-foreground">
                          <svg class="w-4 h-4 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                          </svg>
                          <span class="flex-1">{{ branch.address }}</span>
                        </div>
                        
                        <div class="flex items-center gap-2 text-sm font-medium text-primary">
                          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                          </svg>
                          <span>{{ branch.phone }}</span>
                        </div>
                      </div>

                      <div class="flex items-center gap-2 text-xs text-muted-foreground group-hover:text-primary transition-colors">
                        <span>কল করতে ক্লিক করুন</span>
                        <svg class="w-3 h-3 transform group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                        </svg>
                      </div>
                    </div>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </Transition>
      </Teleport>
    </ClientOnly>
  </div>
</template>

<style scoped>
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s ease;
}

.modal-enter-active .bg-background,
.modal-leave-active .bg-background {
  transition: transform 0.3s ease, opacity 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-from .bg-background,
.modal-leave-to .bg-background {
  transform: scale(0.95);
  opacity: 0;
}
</style>
