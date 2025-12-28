<script setup lang="ts">
import { MapPin, Phone, ArrowRight, Users, Mail, Clock, UserCheck } from 'lucide-vue-next'
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
    .order('sequence', { ascending: true, nullsFirst: false })
  return (data as Branch[]) || []
})

// Fetch all doctors for counts and images and management
const { data: doctors } = await useAsyncData('doctors-home', async () => {
  const { data } = await supabase
    .from('doctors')
    .select('id, name, image, branch_id, role')
    .order('sequence', { ascending: true, nullsFirst: false })
  return (data as any[]) || []
})

const getDoctorCount = (branchId: string) => {
  return (doctors.value || []).filter((d) => d.branch_id === branchId && d.role === 'doctor').length
}

const getBranchDoctors = (branchId: string) => {
  // Filter only doctors (not staff/management) for the avatar list
  return (doctors.value || []).filter((d) => d.branch_id === branchId && d.role === 'doctor').slice(0, 3)
}

const getManager = (branchId: string) => {
  return (doctors.value || []).find((d) => d.branch_id === branchId && d.role === 'management')
}

const getImageUrl = (path: string) => {
  if (!path) return ''
  if (path.startsWith('http')) return path
  const { data } = supabase.storage.from('images').getPublicUrl(path)
  return data.publicUrl
}

const getManagerImageUrl = (manager: any) => {
  if (!manager?.image) return ''
  return getImageUrl(manager.image)
}
</script>

<template>
  <section id="branches" class="section-padding bg-muted/30">
    <div class="section-container">
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
          class="card-hover overflow-hidden group flex flex-col h-full bg-card border-border border"
        >
          <!-- Image -->
          <div class="relative h-64 overflow-hidden">
            <img
              :src="getImageUrl(branch.image)"
              :alt="branch.name"
              loading="lazy"
              class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
            />
            <div class="absolute inset-0 bg-gradient-to-t from-black/20 via-transparent to-transparent" />
            
            <!-- Doctor Count Badge (Top-Left, Primary Style) -->
            <div class="absolute top-4 left-4 bg-primary text-primary-foreground px-3 py-1.5 rounded-full flex items-center gap-2 shadow-lg z-10 transition-transform group-hover:scale-105">
              <Users class="w-3.5 h-3.5" />
              <span class="text-xs font-bold tracking-wide">{{ getDoctorCount(branch.id) }} ডাক্তার</span>
            </div>

            <!-- Manager Badge Overlay (Bottom-Right, Rectangular Style) -->
             <div v-if="getManager(branch.id)" class="absolute bottom-4 right-4 z-10 max-w-[65%]">
                <div class="bg-white/95 backdrop-blur-sm rounded-lg pl-2 pr-3 py-1.5 flex items-center gap-2 shadow-lg border border-primary/20 transition-transform group-hover:scale-105">
                  <img 
                    v-if="getManagerImageUrl(getManager(branch.id))"
                    :src="getManagerImageUrl(getManager(branch.id))"
                    :alt="getManager(branch.id)?.name || 'Manager'"
                    class="w-8 h-8 rounded-full object-cover border-2 border-primary flex-shrink-0"
                  />
                  <div class="text-left overflow-hidden min-w-0">
                    <div class="text-[9px] text-muted-foreground uppercase tracking-wide leading-none truncate block">Manager</div>
                    <div class="text-xs font-bold text-foreground leading-tight truncate block">{{ getManager(branch.id)?.name }}</div>
                  </div>
                </div>
              </div>

          </div>

          <!-- Content -->
          <div class="p-6 flex flex-col flex-grow">
            <!-- Title Moved to Body to avoid conflict with badges -->
            <h3 class="heading-md text-foreground mb-4">
               {{ branch.name }}
            </h3>

            <div class="space-y-3 mb-6 flex-grow">
              <div class="flex items-start gap-3">
                <MapPin class="w-5 h-5 text-primary mt-0.5 flex-shrink-0" />
                <span class="text-muted-foreground text-sm">{{ branch.address }}</span>
              </div>
              <div class="flex items-center gap-3">
                <Phone class="w-5 h-5 text-primary flex-shrink-0" />
                <a 
                  :href="`tel:${branch.phone}`" 
                  class="text-muted-foreground text-sm hover:text-primary transition-colors"
                >
                  {{ branch.phone }}
                </a>
              </div>
               <div class="flex items-center gap-3" v-if="branch.email">
                  <Mail class="w-5 h-5 text-primary flex-shrink-0" />
                  <a :href="`mailto:${branch.email}`" class="text-muted-foreground text-sm hover:text-primary transition-colors">
                    {{ branch.email }}
                  </a>
                </div>
                 <div class="flex items-center gap-3">
                   <Clock class="w-5 h-5 text-primary flex-shrink-0" />
                   <span class="text-muted-foreground text-sm">২৪/৭ খোলা</span>
                 </div>
            </div>

            <!-- Doctors at this branch avatar list -->
             <div class="border-t border-border pt-4 mb-5" v-if="getBranchDoctors(branch.id).length > 0">
                <div class="flex items-center gap-2 mb-3">
                  <span class="text-xs font-medium text-muted-foreground uppercase tracking-wide">
                    এই শাখার ডাক্তারগণ
                  </span>
                </div>
                <div class="flex -space-x-3">
                    <img
                    v-for="doctor in getBranchDoctors(branch.id)"
                    :key="doctor.id"
                    :src="getImageUrl(doctor.image)"
                    :alt="doctor.name"
                    loading="lazy"
                    class="w-10 h-10 rounded-full border-2 border-background object-cover"
                    :title="doctor.name"
                  />
                  <div v-if="getDoctorCount(branch.id) > 3" class="w-10 h-10 rounded-full border-2 border-background bg-muted flex items-center justify-center text-xs font-medium text-muted-foreground">
                    +{{ getDoctorCount(branch.id) - 3 }}
                  </div>
                </div>
              </div>

            <div class="flex gap-3">
               <NuxtLink 
                :to="`/doctors?branch=${encodeURIComponent(branch.address)}`"
                class="flex-1 btn-primary text-center justify-center text-sm py-2.5"
              >
                ডাক্তারদের দেখুন
              </NuxtLink>
              
               <a 
                  :href="branch.map_url"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="btn-ghost px-3"
                  title="অবস্থান দেখুন"
                >
                  <MapPin class="w-5 h-5" />
                </a>
            </div>
          </div>
        </div>
      </div>

      <!-- CTA -->
      <div class="text-center mt-12">
        <NuxtLink to="/branches" class="btn-ghost">
          সকল শাখা দেখুন <ArrowRight class="w-4 h-4 ml-2" />
        </NuxtLink>
      </div>
    </div>
  </section>
</template>
