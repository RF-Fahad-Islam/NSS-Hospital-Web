<script setup lang="ts">
import { ArrowRight, Star, MapPin } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'
import { Swiper, SwiperSlide } from 'swiper/vue';
import { Autoplay, Grid } from 'swiper/modules';
import 'swiper/css';
import 'swiper/css/grid';

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

const { data: doctors } = await useAsyncData('doctors-home', async () => {
  const { data } = await supabase
    .from('doctors')
    .select('*, branches(name, address)')
    .limit(18) // Increased limit to fill the grid
  
  return data as Doctor[]
})

const displayedDoctors = computed(() => doctors.value || [])

const getImageUrl = (path: string) => {
  if (!path) return ''
  if (path.startsWith('http')) return path
  const { data } = supabase.storage.from('doctors').getPublicUrl(path)
  return data.publicUrl
}
</script>

<template>
  <section id="doctors" class="section-padding">
    <div class="section-container">
      <!-- Section Header -->
      <div class="text-center max-w-2xl mx-auto mb-16">
        <span class="text-secondary font-semibold tracking-wide uppercase text-sm">
          Our Team
        </span>
        <h2 class="heading-lg text-foreground mt-3 mb-4">
          Meet Our Medical Team
        </h2>
        <p class="text-muted-foreground text-lg">
          Our team of highly qualified physicians brings decades of experience 
          and a genuine commitment to your well-being.
        </p>
      </div>

      <!-- Doctors Slider -->
      <div class="w-full">
        <ClientOnly>
          <swiper
            :modules="[Autoplay, Grid]"
            :slides-per-view="1.2"
            :space-between="20"
            :loop="true"
            :autoplay="{
              delay: 3000,
              disableOnInteraction: false,
            }"
            :breakpoints="{
              '640': {
                slidesPerView: 2,
                spaceBetween: 20,
              },
              '768': {
                slidesPerView: 3,
                spaceBetween: 24,
              },
              '1280': {
                slidesPerView: 3,
                grid: {
                  rows: 2,
                  fill: 'row'
                },
                spaceBetween: 24,
              }
            }"
            class="doctors-swiper !pb-12"
          >
            <swiper-slide
              v-for="(doctor, index) in displayedDoctors"
              :key="doctor.id"
              class="h-auto"
            >
              <div class="doctor-card group h-full flex flex-col border border-border/40 rounded-xl overflow-hidden bg-card/50 hover:bg-card transition-colors">
                <!-- Image Container -->
                <div class="relative overflow-hidden aspect-[4/4]">
                  <img
                    :src="getImageUrl(doctor.image)"
                    :alt="doctor.name"
                    loading="lazy"
                    class="w-full h-full object-cover object-center transition-transform duration-500 group-hover:scale-105"
                  />
                  <div class="absolute inset-0 bg-gradient-to-t from-foreground/60 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                  
                  <!-- Hover Overlay Content -->
                  <div class="absolute bottom-0 left-0 right-0 p-4 translate-y-full group-hover:translate-y-0 transition-transform duration-300">
                    <NuxtLink
                      :to="`/doctors`"
                      class="btn-primary w-full justify-center text-sm py-2.5"
                    >
                      View Profile
                      <ArrowRight class="w-4 h-4 ml-2" />
                    </NuxtLink>
                  </div>
                </div>

                <!-- Info -->
                <div class="p-4 flex-grow flex flex-col justify-between">
                  <div>
                    <div class="flex items-center gap-1 mb-2">
                      <Star class="w-4 h-4 fill-yellow-400 text-yellow-400" />
                      <span class="text-sm font-medium text-foreground">{{ doctor.rating }}</span>
                      <span class="text-sm text-muted-foreground">• {{ doctor.experience }}</span>
                    </div>
                    <h3 class="font-semibold text-foreground mb-1 group-hover:text-primary transition-colors line-clamp-1" :title="doctor.name">
                      {{ doctor.name }}
                    </h3>
                    <p class="text-sm text-secondary font-medium line-clamp-1" :title="doctor.specialty">{{ doctor.specialty }}</p>
                  </div>

                  <!-- Footer: Branch Info -->
                  <div v-if="doctor.branches" class="mt-4 pt-3 border-t border-border/50 flex items-start gap-2">
                     <MapPin class="w-3.5 h-3.5 text-muted-foreground mt-0.5" />
                     <div class="text-xs text-muted-foreground">
                        <p class="font-medium text-foreground/80 line-clamp-1">{{ doctor.branches.name }}</p>
                        <p class="line-clamp-1 opacity-80" :title="doctor.branches.address">{{ doctor.branches.address }}</p>
                     </div>
                  </div>
                </div>
              </div>
            </swiper-slide>
          </swiper>
          <template #fallback>
             <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Simple Skeleton/Loading State -->
                <div v-for="i in 3" :key="i" class="h-[400px] bg-muted/20 animate-pulse rounded-xl"></div>
             </div>
          </template>
        </ClientOnly>
      </div>

      <!-- CTA -->
      <div class="text-center mt-4">
        <NuxtLink to="/doctors" class="btn-secondary">
          View Full Team
        </NuxtLink>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* Ensure slides have equal height */
:deep(.swiper-wrapper) {
  height: auto;
}
</style>


