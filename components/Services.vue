<script setup lang="ts">
import { supabase } from '@/lib/supabase'
import { 
  Heart, Baby, Brain, Bone, Eye, Stethoscope, ArrowRight, Ambulance,
  Activity, Pill, Microscope, Syringe, CheckCircle
} from 'lucide-vue-next'
import { Swiper, SwiperSlide } from 'swiper/vue'
import { Autoplay, Pagination } from 'swiper/modules'
import 'swiper/css'
import 'swiper/css/pagination'

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
  icon_name: string
  bg_color?: string
  color?: string
  bgColor?: string
  features?: string[]
}

const { data: services } = await useAsyncData<Service[]>('services-home', async () => {
  const { data } = await supabase
    .from('services')
    .select('*')
    .limit(10) // Increased limit for slider
  
  return (data as any) || []
})

const getIcon = (name: string) => {
  return iconMap[name] || Stethoscope
}

const getServiceColors = (service: any) => {
  // Try DB columns (snake_case or camelCase)
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
</script>

<template>
  <section id="services" class="section-padding bg-muted/30">
    <div class="section-container">
      <!-- Section Header -->
      <div class="text-center max-w-2xl mx-auto mb-16">
        <span class="text-secondary font-semibold tracking-wide uppercase text-sm">
          Our Specialties
        </span>
        <h2 class="heading-lg text-foreground mt-3 mb-4">
          Comprehensive Medical Services
        </h2>
        <p class="text-muted-foreground text-lg">
          We offer a wide range of medical services to meet all your healthcare needs 
          under one roof with the latest technology and expert care.
        </p>
      </div>

      <!-- Services Slider -->
      <div class="relative">
        <Swiper
          :modules="[Autoplay, Pagination]"
          :slides-per-view="1"
          :space-between="24"
          :loop="true"
          :autoplay="{
            delay: 3000,
            disableOnInteraction: false,
          }"
          :pagination="{
            clickable: true,
            el: '.swiper-pagination',
            bulletActiveClass: 'swiper-pagination-bullet-active !bg-primary !w-6',
            bulletClass: 'swiper-pagination-bullet !bg-primary/30 !opacity-100 !w-2.5 !h-2.5 !rounded-full !transition-all !duration-300'
          }"
          :breakpoints="{
            640: {
              slidesPerView: 2,
            },
            1024: {
              slidesPerView: 3,
            },
          }"
          class="!pb-16"
        >
          <SwiperSlide
            v-for="service in services"
            :key="service.title"
            class="h-auto"
          >
            <div 
              class="service-card group cursor-pointer h-full"
            >
              <div 
                class="w-14 h-14 rounded-xl flex items-center justify-center transition-all duration-300 mb-5 group-hover:bg-primary group-hover:text-primary-foreground"
                :class="[
                  getServiceColors(service).bg,
                  getServiceColors(service).color
                ]"
              >
                <component :is="getIcon(service.icon_name)" class="w-7 h-7" />
              </div>
              
              <h3 class="heading-sm text-foreground mb-3 group-hover:text-primary transition-colors">
                {{ service.title }}
              </h3>
              
              <p class="text-muted-foreground mb-4 leading-relaxed line-clamp-3">
                {{ service.description }}
              </p>

              <!-- Features List (Matching Services Page) -->
              <div v-if="service.features && service.features.length" class="space-y-2 mb-6">
                <div v-for="feature in service.features.slice(0, 3)" :key="feature" class="flex items-center gap-2">
                  <CheckCircle class="w-4 h-4 text-secondary flex-shrink-0" />
                  <span class="text-sm text-foreground/80">{{ feature }}</span>
                </div>
              </div>
              
            </div>
          </SwiperSlide>
        </Swiper>
        
        <!-- Custom Pagination Container -->
        <div class="swiper-pagination !bottom-0"></div>
      </div>

      <!-- CTA -->
      <div class="text-center mt-8">
        <NuxtLink to="/services" class="btn-primary">
          View All Services
        </NuxtLink>
      </div>
    </div>
  </section>
</template>
