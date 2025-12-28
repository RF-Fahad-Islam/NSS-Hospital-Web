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


</script>

<template>
  <section id="branches" class="section-padding bg-muted/30">
    <div class="section-container">
      <!-- Section Header -->
      <div class="text-center max-w-2xl mx-auto mb-16 animate-fade-up opacity-0">
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
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 lg:gap-8 animate-fade-up opacity-0 stagger-1">
        <div
          v-for="branch in branches"
          :key="branch.id"
          class="h-full"
        >
          <LazyBranchCard :branch="branch" :doctors="doctors || []" />
        </div>
      </div>

      <!-- CTA -->
      <div class="text-center mt-12 animate-fade-up opacity-0 stagger-2">
        <NuxtLink to="/branches" class="btn-ghost group">
          সকল শাখা দেখুন <ArrowRight class="w-4 h-4 ml-2 transition-transform group-hover:translate-x-1" />
        </NuxtLink>
      </div>
    </div>
  </section>
</template>
