<script setup lang="ts">
import { MapPin, Phone, Mail, Clock, Users, ArrowRight, UserCheck } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'
import { computed } from 'vue'

const props = withDefaults(defineProps<{
  branch: {
    id: string
    name: string
    image: string
    address: string
    phone: string
    email: string
    map_url: string
  }
  doctors: any[]
  layout?: 'vertical' | 'horizontal'
  flipped?: boolean
}>(), {
  layout: 'vertical',
  flipped: false
})

const getImageUrl = (path: string) => {
  if (!path) return ''
  if (path.startsWith('http')) return path
  const { data } = supabase.storage.from('images').getPublicUrl(path)
  return data.publicUrl
}

const getDoctorImageUrl = (path: string) => {
  if (!path) return ''
  if (path.startsWith('http')) return path
  const { data } = supabase.storage.from('doctors').getPublicUrl(path)
  return data.publicUrl
}

const getDoctorCount = computed(() => {
  return (props.doctors || []).filter((d) => d.branch_id === props.branch.address && d.role === 'doctor').length
})

const getManager = computed(() => {
  return (props.doctors || []).find((d) => d.branch_id === props.branch.address && d.role === 'management')
})

const getBranchDoctors = computed(() => {
  return (props.doctors || []).filter((d) => d.branch_id === props.branch.address && d.role === 'doctor').slice(0, 3)
})

const getManagerImageUrl = computed(() => {
  const manager = getManager.value
  if (!manager?.image) return ''
  return getDoctorImageUrl(manager.image)
})

// Number animation
const displayedCount = ref(0)
const countDuration = 2000

watch(getDoctorCount, (newVal) => {
  animateValue(newVal)
}, { immediate: true })

function animateValue(end: number) {
  if (process.server) {
    displayedCount.value = end
    return
  }
  
  let startTimestamp: number | null = null;
  const start = displayedCount.value
  const step = (timestamp: number) => {
    if (!startTimestamp) startTimestamp = timestamp;
    const progress = Math.min((timestamp - startTimestamp) / countDuration, 1);
    
    // Ease out quart
    const ease = 1 - Math.pow(1 - progress, 4);
    
    displayedCount.value = Math.floor(progress * (end - start) + start);
    if (progress < 1) {
      window.requestAnimationFrame(step);
    } else {
        displayedCount.value = end
    }
  };
  window.requestAnimationFrame(step);
}

</script>

<template>
  <div 
    class="branch-card group bg-card border border-border/50 overflow-hidden relative flex transition-all duration-500 hover:scale-[1.02]"
    :class="[
      layout === 'horizontal' ? 'flex-col lg:flex-row h-auto min-h-[320px]' : 'flex-col h-full',
      flipped && layout === 'horizontal' ? 'lg:flex-row-reverse' : ''
    ]"
  >
    <!-- Image -->
    <div 
      class="relative overflow-hidden"
      :class="[
        layout === 'horizontal' ? 'w-full lg:w-5/12 aspect-video lg:aspect-auto' : 'w-full aspect-[4/3]'
      ]"
    >
      <img
        :src="getImageUrl(branch.image)"
        :alt="branch.name"
        loading="lazy"
        class="w-full h-full object-cover transition-transform duration-700 ease-[cubic-bezier(0.34,1.56,0.64,1)] group-hover:scale-110"
      />
      
      <!-- Overlay Gradient -->
      <div class="absolute inset-0 bg-gradient-to-t from-black/40 via-transparent to-transparent opacity-60 group-hover:opacity-40 transition-opacity duration-500"></div>
    </div>

    <!-- Content -->
    <div 
      class="p-6 flex flex-col relative z-10 bg-card/95 backdrop-blur-sm transition-all duration-500 ease-[cubic-bezier(0.34,1.56,0.64,1)]"
      :class="[
        layout === 'horizontal' ? 'w-full lg:w-7/12 lg:p-10 justify-center' : 'flex-grow group-hover:-translate-y-2 group-hover:shadow-xl'
      ]"
    >
      <h2 
        class="heading-md text-foreground mb-4 group-hover:text-primary transition-colors duration-300"
        :class="{ 'heading-lg': layout === 'horizontal' }"
      >{{ branch.name }}</h2>
      
      <div class="space-y-3 mb-6" :class="{ 'flex-grow': layout !== 'horizontal' }">
        <div class="flex items-start gap-3 text-muted-foreground group-hover:text-foreground transition-colors duration-300">
          <MapPin class="w-5 h-5 text-primary mt-0.5 shrink-0" />
          <span class="text-sm leading-relaxed">{{ branch.address }}</span>
        </div>
        <div class="flex items-center gap-3 text-muted-foreground group-hover:text-foreground transition-colors duration-300">
          <Phone class="w-5 h-5 text-primary shrink-0" />
          <a :href="`tel:${branch.phone}`" class="text-sm hover:text-primary transition-colors">
            {{ branch.phone }}
          </a>
        </div>
        <div class="flex items-center gap-3 text-muted-foreground group-hover:text-foreground transition-colors duration-300" v-if="branch.email">
          <Mail class="w-5 h-5 text-primary shrink-0" />
          <a :href="`mailto:${branch.email}`" class="text-sm hover:text-primary transition-colors">
            {{ branch.email }}
          </a>
        </div>
         <template v-if="getManager">
           <div class="flex items-center gap-3">
            <UserCheck class="w-5 h-5 text-primary shrink-0" />
            <div class="flex items-center gap-2 bg-muted/50 rounded-lg px-2 py-1 border border-border/50 group-hover:border-primary/30 transition-colors">
              <img 
                v-if="getManagerImageUrl"
                :src="getManagerImageUrl"
                :alt="getManager?.name || 'Manager'"
                class="w-6 h-6 rounded-full object-cover border border-primary/30"
              />
              <div class="flex flex-col">
                <span class="text-[9px] text-muted-foreground uppercase tracking-wide leading-none">Manager</span>
                <span class="text-xs font-semibold text-foreground leading-tight">{{ getManager?.name }}</span>
              </div>
            </div>
           </div>
         </template>
         <div class="flex items-center gap-3 text-muted-foreground">
           <Clock class="w-5 h-5 text-primary shrink-0" />
           <span class="text-sm">২৪/৭ খোলা</span>
         </div>
       </div>

      <!-- Doctors at this branch -->
      <div class="border-t border-border pt-4 mb-5">
        <div class="flex items-center gap-2 mb-3">
          <Users class="w-4 h-4 text-secondary" />
          <span class="text-sm font-medium text-foreground">
             <span class="inline-block min-w-[1ch] text-primary font-bold">{{ displayedCount }}</span> জন ডাক্তার
          </span>
        </div>
        
        <div class="flex -space-x-2 pl-1 h-10 items-center">
            <img
            v-for="doctor in getBranchDoctors"
            :key="doctor.id"
            :src="getDoctorImageUrl(doctor.image)"
            :alt="doctor.name"
            loading="lazy"
            class="w-9 h-9 rounded-full border-2 border-background object-cover transition-transform duration-300 hover:z-10 hover:scale-125"
            :title="doctor.name"
          />
          <div v-if="getDoctorCount > 3" class="w-9 h-9 rounded-full border-2 border-background bg-muted flex items-center justify-center text-xs font-bold text-muted-foreground">
            +{{ getDoctorCount - 3 }}
          </div>
        </div>
      </div>

      <div class="flex flex-wrap gap-3" :class="{ 'mt-auto': layout !== 'horizontal' }">
        <NuxtLink 
          :to="`/doctors?branch=${branch.address}`"
          class="btn-primary flex-1 justify-center text-sm py-2.5 group-hover:scale-105 transition-transform duration-300 ease-[cubic-bezier(0.34,1.56,0.64,1)] active:scale-95"
        >
          ডাক্তারদের দেখুন
          <ArrowRight class="w-4 h-4 ml-1 transition-transform group-hover:translate-x-1" />
        </NuxtLink>
        <a 
          :href="branch.map_url"
          target="_blank"
          rel="noopener noreferrer"
          class="btn-ghost px-3 group-hover:bg-muted/80"
          title="মানচিত্রে দেখুন"
        >
          <MapPin class="w-5 h-5" />
        </a>
      </div>
    </div>
  </div>
</template>

<style scoped>
.branch-card {
  perspective: 1000px;
  border-radius: 1.5rem; /* More rounded as per "stretchy" feel implies softer UI */
}

/* Custom bounce */
.ease-bounce {
    transition-timing-function: cubic-bezier(0.34, 1.56, 0.64, 1);
}
</style>
