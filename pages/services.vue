<script setup lang="ts">
import { ArrowRight, CheckCircle } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'
import { 
  Heart, Baby, Brain, Bone, Eye, Stethoscope, Ambulance,
  Activity, Pill, Microscope, Syringe
} from 'lucide-vue-next'

const iconMap: Record<string, any> = {
  Heart, Baby, Brain, Bone, Eye, Stethoscope, Ambulance,
  Activity, Pill, Microscope, Syringe
}

// Fallback color map matching hospitalData.ts
const colorMap: Record<string, { color: string, bg: string }> = {
  'Activity': { color: 'text-red-500', bg: 'bg-red-50' },
  'Baby': { color: 'text-pink-500', bg: 'bg-pink-50' },
  'Pill': { color: 'text-blue-500', bg: 'bg-blue-50' },
  'Stethoscope': { color: 'text-teal-500', bg: 'bg-teal-50' },
  'Microscope': { color: 'text-indigo-500', bg: 'bg-indigo-50' },
  'Syringe': { color: 'text-purple-500', bg: 'bg-purple-50' },
  'Heart': { color: 'text-rose-500', bg: 'bg-rose-50' },
  'Brain': { color: 'text-violet-500', bg: 'bg-violet-50' },
  'Bone': { color: 'text-slate-500', bg: 'bg-slate-50' },
  'Eye': { color: 'text-sky-500', bg: 'bg-sky-50' },
  'Ambulance': { color: 'text-emerald-500', bg: 'bg-emerald-50' },
}

interface Service {
  id: string
  title: string
  description: string
  full_description: string
  icon_name: string
  bg_color?: string
  color?: string
  features: string[]
}

useHead({
  title: 'আমাদের সেবাসমূহ - এনএসএস মা স্বাস্থ্য সেবা কেন্দ্র',
  meta: [
    { name: 'description', content: 'নিরাপদ এমআর, মাতৃত্ব এবং পরিবার পরিকল্পনা সহ আমাদের ব্যাপক চিকিৎসা সেবা অন্বেষণ করুন।' }
  ]
})

const { data: services } = await useAsyncData<Service[]>('services-page', async () => {
  const { data } = await supabase
    .from('services')
    .select('*')
  return (data as any) || []
})

const { data: doctors } = await useAsyncData('doctors-all', async () => {
  const { data } = await supabase
    .from('doctors')
    .select('*')
  return (data as any[]) || []
})

const getIcon = (name: string) => {
  return iconMap[name] || Stethoscope
}

const getServiceColors = (service: any) => {
  // Try DB columns (snake_case or camelCase)
  // Logic to handle different casing from DB vs potential old data
  const dbBg = service.bg_color || service.bgColor
  const dbColor = service.color
  
  if (dbBg && dbColor) {
    return { bg: dbBg, color: dbColor }
  }
  
  // Fallback to map based on icon
  const mapped = colorMap[service.icon_name]
  if (mapped) {
    return mapped
  }
  
  // Default fallback
  return { bg: 'bg-primary/10', color: 'text-primary' }
}

const getImageUrl = (path: string) => {
  if (!path) return ''
  if (path.startsWith('http')) return path
  const { data } = supabase.storage.from('doctors').getPublicUrl(path)
  return data.publicUrl
}

const getDoctorsForService = (service: Service) => {
  const list = doctors.value || []
  if (!list.length) return []

  // Mapping logic
  // 1. Matrology/Baby -> Pediatrician
  // 2. Heart -> Cardiologist
  // 3. Brain -> Neurologist
  // 4. Bone -> Orthopedic
  // 5. Eye -> Ophthalmologist
  
  return list.filter(d => {
    // Check if doctor specialty is loosely related to service title or icon
    const specialty = (d.specialty || '').toLowerCase()
    const title = (service.title || '').toLowerCase()
    const icon = (service.icon_name || '').toLowerCase()
    
    // Explicit mapping for known demo data types
    if (icon.includes('baby') && specialty.includes('pedia')) return true
    if (icon.includes('heart') && (specialty.includes('cardio') || specialty.includes('heart'))) return true
    if (icon.includes('brain') && (specialty.includes('neuro') || specialty.includes('brain'))) return true
    if (icon.includes('bone') && (specialty.includes('ortho') || specialty.includes('bone'))) return true
    if (icon.includes('eye') && (specialty.includes('ophth') || specialty.includes('eye'))) return true
    if (title.includes('maternity') && (specialty.includes('obs') || specialty.includes('gyn') || specialty.includes('maternity'))) return true
    
    // Fallback: simple text match
    if (title.includes(specialty) || specialty.includes(title)) return true
    
    // Fallback 2: Check if doctor has a 'service_id' or similar if we added it (we haven't yet, but good for future)
    // For now, let's keep it simple.
    
    return false
  })
}
</script>

<template>
  <div class="min-h-screen bg-background">
    <!-- Hero Section -->
    <section class="pt-32 pb-16 bg-gradient-to-br from-primary/5 via-background to-secondary/5">
      <div class="section-container text-center">
        <span class="text-secondary font-semibold tracking-wide uppercase text-sm">
          আমরা যা অফার করি
        </span>
        <h1 class="heading-xl text-foreground mt-3 mb-6">
          আমাদের চিকিৎসা সেবাসমূহ
        </h1>
        <p class="text-muted-foreground text-lg max-w-2xl mx-auto">
          অত্যাধুনিক প্রযুক্তি এবং সহানুভূতিশীল যত্নের সাথে আপনার সমস্ত চিকিৎসা চাহিদা মেটাতে নকশা করা ব্যাপক স্বাস্থ্যসেবা।
        </p>
      </div>
    </section>

    <!-- Services List -->
    <section class="section-padding">
      <div class="section-container">
        <div class="space-y-16">
          <div 
            v-for="(service, index) in services"
            :key="service.id"
            :id="service.id"
            class="flex flex-col lg:flex-row gap-8 lg:gap-16 items-center"
            :class="{ 'lg:flex-row-reverse': index % 2 === 1 }"
          >
            <!-- Icon/Visual Side -->
            <div class="w-full lg:w-1/3">
              <div 
                class="aspect-square max-w-sm mx-auto rounded-3xl flex items-center justify-center shadow-lg transition-all duration-300 hover:scale-105"
                :class="getServiceColors(service).bg"
              >
                <component 
                  :is="getIcon(service.icon_name)" 
                  class="w-32 h-32" 
                  :class="getServiceColors(service).color"
                />
              </div>
            </div>

            <!-- Content Side -->
            <div class="w-full lg:w-2/3">
              <div class="flex items-start justify-between mb-4">
                <h2 class="heading-lg text-foreground">{{ service.title }}</h2>
              </div>


              <p class="text-muted-foreground text-lg mb-6 leading-relaxed">
                {{ service.full_description }}
              </p>
              
              <!-- Features Grid -->
              <div class="grid sm:grid-cols-2 gap-3 mb-8">
                <div v-for="feature in service.features" :key="feature" class="flex items-center gap-3">
                  <CheckCircle class="w-5 h-5 text-secondary flex-shrink-0" />
                  <span class="text-foreground">{{ feature }}</span>
                </div>
              </div>

              <NuxtLink 
                to="/#appointment" 
                class="btn-primary inline-flex items-center gap-2"
              >
                অ্যাপয়েন্টমেন্ট নিন
                <ArrowRight class="w-4 h-4" />
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="section-padding bg-primary">
      <div class="section-container text-center">
        <h2 class="heading-lg text-primary-foreground mb-4">
          সেবা নির্বাচনে সাহায্য প্রয়োজন?
        </h2>
        <p class="text-primary-foreground/80 text-lg mb-8 max-w-2xl mx-auto">
          আমাদের মেডিকেল উপদেষ্টারা আপনার প্রয়োজনের জন্য সঠিক সেবা খুঁজে পেতে ২৪/৭ উপলব্ধ।
        </p>
        <div class="flex flex-col sm:flex-row gap-4 justify-center">
          <a href="tel:+1234567890" class="inline-flex items-center justify-center px-6 py-3 bg-transparent border-2 border-emerald-400 text-emerald-400 font-semibold rounded-lg transition-all duration-300 hover:bg-emerald-400 hover:text-emerald-950 hover:-translate-y-0.5">
            এখনই কল করুন
          </a>
          <NuxtLink to="/#appointment" class="btn-secondary">
            পরামর্শের সময়সূচী করুন
          </NuxtLink>
        </div>
      </div>
    </section>
  </div>
</template>
