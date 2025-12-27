<script setup lang="ts">
import { 
  Star, MapPin, Calendar, Clock, ArrowLeft, 
  Stethoscope, GraduationCap, Info,
  Phone, Mail, CalendarCheck
} from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'

const route = useRoute()
const doctorId = route.params.id as string

const { data: doctor, error } = await useAsyncData(`doctor-${doctorId}`, async () => {
  const { data } = await supabase
    .from('doctors')
    .select('*, branches(name, address, phone, email)')
    .eq('id', doctorId)
    .single()
  return data
})

if (error.value || !doctor.value) {
  throw createError({ statusCode: 404, statusMessage: 'ডাক্তার পাওয়া যায়নি' })
}

useHead({
  title: `${doctor.value.name} - এনএসএস মেডিকেল টিম`,
  meta: [
    { name: 'description', content: `${doctor.value.name}, ${doctor.value.specialty}-এর প্রোফাইল দেখুন এবং অ্যাপয়েন্টমেন্ট বুক করুন।` }
  ]
})

const getImageUrl = (path: string) => {
  if (!path) return ''
  if (path.startsWith('http')) return path
  const { data } = supabase.storage.from('doctors').getPublicUrl(path)
  return data.publicUrl
}

const translateDay = (day: string) => {
  const days: Record<string, string> = {
    'Monday': 'সোমবার',
    'Tuesday': 'মঙ্গলবার',
    'Wednesday': 'বুধবার',
    'Thursday': 'বৃহস্পতিবার',
    'Friday': 'শুক্রবার',
    'Saturday': 'শনিবার',
    'Sunday': 'রবিবার'
  }
  return days[day] || day
}
</script>

<template>
  <div class="min-h-screen bg-muted/30 pt-32 pb-20">
    <div class="section-container">
      <!-- Back Button -->
      <NuxtLink 
        to="/doctors" 
        class="inline-flex items-center gap-2 text-muted-foreground hover:text-primary transition-colors mb-8 group"
      >
        <ArrowLeft class="w-4 h-4 transition-transform group-hover:-translate-x-1" />
        সব ডাক্তারদের তালিকায় ফিরে যান
      </NuxtLink>

      <div class="grid lg:grid-cols-3 gap-8">
        <!-- Profile Sidebar -->
        <div class="lg:col-span-1 space-y-6">
          <div class="bg-card rounded-3xl overflow-hidden border border-border shadow-sm">
            <div class="aspect-[4/5] relative">
              <img
                :src="getImageUrl(doctor.image)"
                :alt="doctor.name"
                class="w-full h-full object-cover"
              />
              <div class="absolute bottom-4 right-4 px-3 py-1.5 bg-background/90 backdrop-blur-md rounded-full flex items-center gap-1.5 shadow-lg border border-border">
                <Star class="w-4 h-4 fill-yellow-400 text-yellow-400" />
                <span class="font-bold text-sm">{{ doctor.rating }}</span>
              </div>
            </div>
            <div class="p-6">
              <h1 class="text-2xl font-bold text-foreground mb-1">{{ doctor.name }}</h1>
              <p class="text-secondary font-medium text-lg mb-4">{{ doctor.specialty }}</p>
              
              <div class="space-y-3 pt-4 border-t border-border">
                <div class="flex items-center gap-3 text-muted-foreground">
                  <Clock class="w-4 h-4 text-primary" />
                  <span class="text-sm">{{ doctor.experience }} অভিজ্ঞতা</span>
                </div>
                <div v-if="doctor.branches" class="flex items-start gap-3 text-muted-foreground">
                  <MapPin class="w-4 h-4 text-primary mt-1" />
                  <div class="text-sm">
                    <p class="text-foreground font-medium">{{ doctor.branches.name }}</p>
                    <p>{{ doctor.branches.address }}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Quick Action -->
          <div class="bg-primary rounded-3xl p-8 text-primary-foreground shadow-lg shadow-primary/20">
            <div class="flex items-center gap-3 mb-4">
              <CalendarCheck class="w-6 h-6" />
              <h3 class="font-bold text-xl">অ্যাপয়েন্টমেন্ট নিতে চান?</h3>
            </div>
            <p class="opacity-90 mb-6 text-sm leading-relaxed">
              বিশেষজ্ঞ চিকিৎসার জন্য আজই {{ doctor.name }}-এর সাথে অ্যাপয়েন্টমেন্ট নিন।
            </p>
            <NuxtLink 
              to="/#appointment" 
              class="w-full py-3 bg-white text-primary font-bold rounded-xl flex items-center justify-center gap-2 hover:bg-opacity-90 transition-all shadow-md group"
            >
              বুক করুন
              <ArrowLeft class="w-4 h-4 rotate-180 transition-transform group-hover:translate-x-1" />
            </NuxtLink>
          </div>
        </div>

        <!-- Details Content -->
        <div class="lg:col-span-2 space-y-8">
          <!-- Bio -->
          <div class="bg-card rounded-3xl p-8 border border-border shadow-sm">
            <div class="flex items-center gap-3 mb-6">
              <div class="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center">
                <Info class="w-5 h-5 text-primary" />
              </div>
              <h2 class="text-xl font-bold text-foreground">ডাক্তার সম্পর্কে</h2>
            </div>
            <p class="text-muted-foreground leading-relaxed">
              {{ doctor.bio }}
            </p>
          </div>

          <div class="grid md:grid-cols-2 gap-8">
            <!-- Education -->
            <div v-if="doctor.education" class="bg-card rounded-3xl p-8 border border-border shadow-sm">
              <div class="flex items-center gap-3 mb-6">
                <div class="w-10 h-10 rounded-xl bg-secondary/10 flex items-center justify-center">
                  <GraduationCap class="w-5 h-5 text-secondary" />
                </div>
                <h2 class="text-xl font-bold text-foreground">শিক্ষা</h2>
              </div>
              <p class="text-muted-foreground leading-relaxed italic">
                {{ doctor.education }}
              </p>
            </div>


          </div>

          <!-- Availability -->
          <div v-if="doctor.available_days" class="bg-card rounded-3xl p-8 border border-border shadow-sm">
            <div class="flex items-center gap-3 mb-6">
              <div class="w-10 h-10 rounded-xl bg-green-100 flex items-center justify-center">
                <Calendar class="w-5 h-5 text-green-600" />
              </div>
              <h2 class="text-xl font-bold text-foreground">সময়সূচী</h2>
            </div>
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-3">
              <div 
                v-for="day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']"
                :key="day"
                class="p-4 rounded-2xl border text-center transition-all"
                :class="doctor.available_days.includes(day) 
                  ? 'bg-primary/5 border-primary/20 text-primary font-bold' 
                  : 'bg-muted/50 border-transparent text-muted-foreground opacity-40'"
              >
                <p class="text-sm">{{ translateDay(day) }}</p>
              </div>
            </div>
          </div>

          <!-- Contact Branch -->
          <div v-if="doctor.branches" class="bg-card rounded-3xl p-8 border border-border shadow-sm">
            <h2 class="text-xl font-bold text-foreground mb-6">যোগাযোগের তথ্য</h2>
            <div class="grid md:grid-cols-2 gap-6">
              <a :href="`tel:${doctor.branches.phone}`" class="flex items-center gap-4 p-4 bg-muted/50 rounded-2xl hover:bg-primary/5 transition-colors group">
                <div class="w-12 h-12 rounded-xl bg-background flex items-center justify-center shadow-sm group-hover:scale-110 transition-transform">
                  <Phone class="w-5 h-5 text-primary" />
                </div>
                <div>
                  <p class="text-xs text-muted-foreground uppercase tracking-wider font-bold">ব্রাঞ্চে কল করুন</p>
                  <p class="text-foreground font-medium">{{ doctor.branches.phone }}</p>
                </div>
              </a>
              <a :href="`mailto:${doctor.branches.email}`" class="flex items-center gap-4 p-4 bg-muted/50 rounded-2xl hover:bg-primary/5 transition-colors group">
                <div class="w-12 h-12 rounded-xl bg-background flex items-center justify-center shadow-sm group-hover:scale-110 transition-transform">
                  <Mail class="w-5 h-5 text-primary" />
                </div>
                <div>
                  <p class="text-xs text-muted-foreground uppercase tracking-wider font-bold">আমাদের ইমেল করুন</p>
                  <p class="text-foreground font-medium">{{ doctor.branches.email }}</p>
                </div>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
