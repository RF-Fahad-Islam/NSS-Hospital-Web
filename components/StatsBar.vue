<script setup lang="ts">
import { Clock, Users, FlaskConical, Award } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'
import CountUp from '@/components/ui/CountUp.vue'

interface StatItem {
  icon: any
  value: string
  label: string
  isAnimated: boolean
  numberValue?: number
  suffix?: string
  locale?: string
}

const { data: doctorCount } = await useAsyncData('stats-doctor-count', async () => {
  const { count } = await supabase
    .from('doctors')
    .select('*', { count: 'exact', head: true })
  return count || 0
})

const stats = computed<StatItem[]>(() => [
  {
    icon: Clock,
    value: '২৪/৭',
    label: 'জরুরী সেবা',
    isAnimated: false,
  },
  {
    icon: Users,
    value: doctorCount.value ? `${doctorCount.value}+` : '০+',
    label: 'ডাক্তার ও স্টাফ',
    isAnimated: true,
    numberValue: doctorCount.value || 0,
    suffix: '+',
    locale: 'bn-BD'
  },
  {
    icon: FlaskConical,
    value: 'আধুনিক',
    label: 'ল্যাবরেটরি',
    isAnimated: false,
  },
  {
    icon: Award,
    value: '২৪',
    label: 'বছরের অভিজ্ঞতা',
    isAnimated: true,
    numberValue: 24,
    suffix: '+',
    locale: 'bn-BD'
  },
])
</script>

<template>
  <section class="stats-bar relative overflow-hidden">
    <!-- Background Pattern -->
    <div class="absolute inset-0 opacity-10">
      <div class="absolute inset-0" :style="{
        backgroundImage: 'radial-gradient(circle at 2px 2px, currentColor 1px, transparent 0)',
        backgroundSize: '24px 24px'
      }"></div>
    </div>

    <div class="section-container relative">
      <div class="grid grid-cols-2 md:grid-cols-4 gap-6 md:gap-8">
        <div
          v-for="(stat, index) in stats"
          :key="stat.label"
          class="flex items-center gap-4 justify-center md:justify-start"
          data-aos="fade-up"
          :data-aos-delay="index * 100"
        >
          <div class="w-12 h-12 rounded-xl bg-primary-foreground/10 flex items-center justify-center shrink-0">
            <component :is="stat.icon" class="w-6 h-6 text-primary-foreground" />
          </div>
          <div>
            <p class="text-xl md:text-2xl font-bold text-primary-foreground flex items-center">
              <template v-if="stat.isAnimated">
                 <CountUp :end="stat.numberValue ?? 0" :suffix="stat.suffix" :locale="stat.locale" />
              </template>
              <template v-else>
                 {{ stat.value }}
              </template>
            </p>
            <p class="text-sm text-primary-foreground/70">{{ stat.label }}</p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
