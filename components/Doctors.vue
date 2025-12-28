<script setup lang="ts">
import { computed } from 'vue'
import { supabase } from '@/lib/supabase'

interface Doctor {
  id: string
  name: string
  specialty: string
  experience: string
  rating: number
  image: string
  branch_id: string
  branches?: {
    name: string
    address: string
  }
}

const { data: doctors } = await useAsyncData('home-doctors-list', async () => {
  const { data } = await supabase
    .from('doctors')
    .select('*, branches(name, address)')
    .eq('role', 'doctor')
    .order('sequence', { ascending: true, nullsFirst: false })
    .limit(18)
  
  return data as Doctor[]
})

const displayedDoctors = computed(() => {
  if (!doctors.value) return []
  return doctors.value.map((d: any) => {
    const branchData = Array.isArray(d.branches) ? d.branches[0] : d.branches
    return {
      ...d,
      branches: branchData
    }
  })
})
</script>

<template>
  <section id="doctors" class="section-padding">
    <div class="section-container">
      <!-- Section Header -->
      <div class="text-center max-w-2xl mx-auto mb-16" data-aos="fade-up">
        <span class="text-secondary font-semibold tracking-wide uppercase text-sm">
          আমাদের টিম
        </span>
        <h2 class="heading-lg text-foreground mt-3 mb-4">
          আমাদের বিশেষজ্ঞ চিকিৎসকদের সাথে পরিচিত হোন
        </h2>
        <p class="text-muted-foreground text-lg">
        আমাদের উচ্চ যোগ্যতাসম্পন্ন ও অভিজ্ঞ চিকিৎসকদের দল নারীদের সুস্থতা ও সম্মানকে সর্বোচ্চ গুরুত্ব দিয়ে আন্তরিকতা, পেশাদারিত্ব এবং নিরবচ্ছিন্ন যত্নের মাধ্যমে সেবা প্রদান করে।
        </p>
      </div>
      <!-- Doctors Grid (3x3) -->
      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 lg:gap-8 min-h-[400px]">
        <DoctorCard 
          v-for="(doctor, index) in displayedDoctors.slice(0, 9)" 
          :key="doctor.id" 
          :doctor="doctor"
          data-aos="fade-up"
          :data-aos-delay="index * 100"
        />
      </div>

      <!-- CTA -->
      <div class="text-center mt-8" data-aos="fade-up" data-aos-delay="400">
        <NuxtLink to="/doctors" class="btn-secondary px-8 py-3 rounded-xl hover:scale-105 active:scale-95 transition-transform duration-300 ease-[cubic-bezier(0.34,1.56,0.64,1)]">
          সম্পূর্ণ টিম দেখুন
        </NuxtLink>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* Scoped styles removed as standard CSS grid is used */
</style>


