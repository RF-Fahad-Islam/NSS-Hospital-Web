<script setup lang="ts">
import { computed } from 'vue'
import { 
  Users, Activity, TrendingUp, ArrowUpRight, ArrowDownRight, Globe
} from 'lucide-vue-next'

const props = defineProps<{
  totalVisits: number
  todayVisits: number
  weeklyVisits: { date: string; count: number; label: string }[]
  topPages: { path: string; count: number }[]
}>()

// --- Computed Metrics ---

// 1. Visit Growth vs Last Week (Simple approximation from data)
// In a real app, we'd fetch previous period comparison
const avgVisits = computed(() => {
  if (props.weeklyVisits.length === 0) return 0
  const sum = props.weeklyVisits.reduce((acc, curr) => acc + curr.count, 0)
  return Math.round(sum / props.weeklyVisits.length)
})

// SVG Polyline points for chart
const chartPoints = computed(() => {
  const data = props.weeklyVisits
  if (!data || data.length === 0) return ''
  
  const width = 100 // viewbox width
  const height = 40 // viewbox height
  const max = Math.max(...data.map(d => d.count)) || 1
  
  return data.map((d, i) => {
    const x = (i / (data.length - 1)) * width
    const y = height - (d.count / max) * height
    return `${x},${y}`
  }).join(' ')
})

const chartAreaPath = computed(() => {
  if (!props.weeklyVisits || props.weeklyVisits.length === 0) return ''
  return `M0,40 L${chartPoints.value} L100,40 Z`
})

const topPagePercentage = (count: number) => {
    const max = props.topPages[0]?.count || 1
    return Math.round((count / max) * 100)
}
</script>

<template>
  <div class="space-y-6 animate-in fade-in duration-500">
    
    <!-- Top Stats Row -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <!-- Total Visits -->
      <div 
        class="bg-card rounded-xl border border-border p-6 shadow-sm hover:shadow-md transition-all hover:scale-[1.02] duration-300"
        data-aos="zoom-in-up"
        data-aos-delay="0"
      >
        <div class="flex items-center justify-between mb-4">
          <div class="w-10 h-10 rounded-lg bg-blue-100 flex items-center justify-center">
            <Activity class="w-5 h-5 text-blue-600" />
          </div>
          <span class="text-xs font-medium px-2 py-1 rounded-full bg-blue-50 text-blue-600">
            All Time
          </span>
        </div>
        <p class="text-2xl font-bold text-foreground">{{ totalVisits }}</p>
        <p class="text-sm text-muted-foreground">Total Page Visits</p>
      </div>

      <!-- Today's Visits -->
      <div 
        class="bg-card rounded-xl border border-border p-6 shadow-sm hover:shadow-md transition-all hover:scale-[1.02] duration-300"
        data-aos="zoom-in-up"
        data-aos-delay="100"
      >
        <div class="flex items-center justify-between mb-4">
          <div class="w-10 h-10 rounded-lg bg-green-100 flex items-center justify-center">
            <Users class="w-5 h-5 text-green-600" />
          </div>
          <span class="text-green-600 bg-green-50 text-xs font-medium px-2 py-1 rounded-full flex items-center gap-1">
            <ArrowUpRight class="w-3 h-3" />
            Active
          </span>
        </div>
        <p class="text-2xl font-bold text-foreground">{{ todayVisits }}</p>
        <p class="text-sm text-muted-foreground">Visits Today</p>
      </div>

      <!-- Weekly Avg -->
      <div 
        class="bg-card rounded-xl border border-border p-6 shadow-sm hover:shadow-md transition-all hover:scale-[1.02] duration-300"
        data-aos="zoom-in-up"
        data-aos-delay="200"
      >
         <div class="flex items-center justify-between mb-4">
          <div class="w-10 h-10 rounded-lg bg-purple-100 flex items-center justify-center">
            <TrendingUp class="w-5 h-5 text-purple-600" />
          </div>
          <span class="text-purple-600 bg-purple-50 text-xs font-medium px-2 py-1 rounded-full">
            Last 7 Days
          </span>
        </div>
        <p class="text-2xl font-bold text-foreground">{{ avgVisits }}</p>
        <p class="text-sm text-muted-foreground">Daily Average</p>
      </div>
    </div>

    <!-- Charts Row -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      
      <!-- Visitor Trends Chart (Large) -->
      <div class="lg:col-span-2 bg-card rounded-xl border border-border p-6 shadow-sm">
        <div class="flex items-center justify-between mb-6">
          <div>
            <h3 class="font-semibold text-lg text-foreground">Visitor Trends</h3>
            <p class="text-sm text-muted-foreground">Last 7 days of site activity</p>
          </div>
          <div class="px-3 py-1 bg-muted rounded-md text-xs font-medium text-muted-foreground">
            7 Days
          </div>
        </div>
        
        <div class="h-64 w-full relative group">
          <!-- Custom SVG Chart -->
          <svg viewBox="0 0 100 40" class="w-full h-full overflow-visible" preserveAspectRatio="none">
             <!-- Gradient Defs -->
            <defs>
              <linearGradient id="chartGradient" x1="0" x2="0" y1="0" y2="1">
                <stop offset="0%" stop-color="rgb(59, 130, 246)" stop-opacity="0.2"/>
                <stop offset="100%" stop-color="rgb(59, 130, 246)" stop-opacity="0"/>
              </linearGradient>
            </defs>

            <!-- Guidelines -->
            <line x1="0" y1="0" x2="100" y2="0" stroke="currentColor" stroke-opacity="0.05" stroke-width="0.5" />
            <line x1="0" y1="20" x2="100" y2="20" stroke="currentColor" stroke-opacity="0.05" stroke-width="0.5" />
            <line x1="0" y1="40" x2="100" y2="40" stroke="currentColor" stroke-opacity="0.05" stroke-width="0.5" />

            <!-- Area -->
            <path :d="chartAreaPath" fill="url(#chartGradient)" />
            
            <!-- Line -->
            <polyline 
              :points="chartPoints" 
              fill="none" 
              stroke="rgb(59, 130, 246)" 
              stroke-width="1.5"
              vector-effect="non-scaling-stroke"
              stroke-linecap="round"
              stroke-linejoin="round"
            />
          </svg>

          <!-- Simple hovered overlay could go here if implemented -->
          <div class="absolute inset-x-0 bottom-0 flex justify-between text-xs text-muted-foreground mt-2 px-2">
            <span v-for="(day, index) in weeklyVisits" :key="index">
                {{ day.label }}
            </span>
          </div>
        </div>
      </div>

      <!-- Top Pages -->
      <div class="bg-card rounded-xl border border-border p-6 shadow-sm flex flex-col">
        <h3 class="font-semibold text-lg text-foreground mb-1">Top Pages</h3>
        <p class="text-sm text-muted-foreground mb-6">Most visited pages this week</p>
        
        <div class="space-y-4 overflow-y-auto max-h-[300px] pr-2 custom-scrollbar">
            <div v-for="(page, i) in topPages" :key="page.path" class="space-y-1">
                <div class="flex justify-between text-sm">
                    <span class="font-medium text-foreground flex items-center gap-2">
                         <Globe class="w-3 h-3 text-muted-foreground" />
                         {{ page.path === '/' ? 'Home' : page.path }}
                    </span>
                    <span class="text-muted-foreground font-mono">{{ page.count }}</span>
                </div>
                <div class="h-1.5 w-full bg-muted rounded-full overflow-hidden">
                    <div 
                        class="h-full bg-primary rounded-full transition-all duration-1000"
                        :style="{ width: `${topPagePercentage(page.count)}%`, transitionDelay: `${i * 100}ms` }"
                    ></div>
                </div>
            </div>
            <div v-if="topPages.length === 0" class="text-center py-8 text-muted-foreground">
                No data available yet.
            </div>
        </div>
      </div>
    </div>

  </div>
</template>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
    width: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
    background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
    background: hsl(var(--muted-foreground) / 0.3);
    border-radius: 4px;
}
</style>
