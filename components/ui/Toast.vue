<script setup lang="ts">
import { X, CheckCircle, AlertCircle, Info } from 'lucide-vue-next'
import { cn } from '@/lib/utils'
import { onMounted, onUnmounted } from 'vue'

const props = defineProps<{
  id: string
  title?: string
  description?: string
  variant?: 'default' | 'destructive' | 'success'
}>()

const emit = defineEmits(['close'])
</script>

<template>
  <div
    :class="cn(
      'pointer-events-auto relative flex w-full items-start gap-4 overflow-hidden rounded-xl border p-4 shadow-lg transition-all data-[swipe=cancel]:translate-x-0 data-[swipe=end]:translate-x-[var(--radix-toast-swipe-end-x)] data-[swipe=move]:translate-x-[var(--radix-toast-swipe-move-x)] data-[swipe=move]:transition-none',
      'bg-background/95 backdrop-blur-md dark:bg-zinc-900/95 text-foreground',
      variant === 'destructive' && 'border-destructive/30 bg-destructive/10 text-destructive',
      variant === 'success' && 'border-green-500/30 bg-green-500/10 text-green-600 dark:text-green-400',
      variant === 'default' && 'border-border/50',
    )"
    role="alert"
  >
    <!-- Icon based on variant -->
    <div v-if="variant === 'success'" class="shrink-0">
      <CheckCircle class="h-5 w-5" />
    </div>
    <div v-else-if="variant === 'destructive'" class="shrink-0">
      <AlertCircle class="h-5 w-5" />
    </div>
    <div v-else class="shrink-0">
      <Info class="h-5 w-5 text-primary" />
    </div>

    <!-- Content -->
    <div class="flex-1 grid gap-1">
      <div v-if="title" class="text-sm font-semibold leading-none tracking-tight">
        {{ title }}
      </div>
      <div v-if="description" class="text-sm opacity-90 leading-relaxed">
        {{ description }}
      </div>
    </div>

    <!-- Close Button -->
    <button
      @click="emit('close')"
      class="shrink-0 rounded-md p-1 opacity-50 ring-offset-background hover:opacity-100 hover:bg-foreground/5 focus:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2"
    >
      <X class="h-4 w-4" />
    </button>
  </div>
</template>
