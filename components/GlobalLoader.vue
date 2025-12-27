<script setup lang="ts">
import logoImg from '@/assets/logo.png'

// Props to control visibility
defineProps<{
  loading: boolean
}>()
</script>

<template>
  <Transition name="fade">
    <div 
      v-if="loading" 
      class="fixed inset-0 z-[100] flex flex-col items-center justify-center bg-background/80 backdrop-blur-md"
    >
      <div class="relative">
        <!-- Pulse Effect -->
        <div class="absolute inset-0 bg-primary/20 rounded-full animate-ping" />
        
        <!-- Logo/Icon Container -->
        <div class="relative w-32 h-32 bg-white rounded-full shadow-medical-lg flex items-center justify-center border-4 border-primary/10 p-4">
          <img :src="logoImg" alt="NSS" class="w-full h-full object-contain animate-pulse-slow" />
        </div>
      </div>
      
      <div class="mt-8 flex flex-col items-center gap-2">
        <h3 class="text-xl font-bold text-primary tracking-tight">NSS</h3>
        <p class="text-sm text-muted-foreground animate-pulse">মা স্বাস্থ্য সেবা কেন্দ্র</p>
      </div>
    </div>
  </Transition>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

@keyframes pulse-slow {
  0%, 100% {
    transform: scale(1);
    opacity: 1;
  }
  50% {
    transform: scale(0.92);
    opacity: 0.8;
  }
}

.animate-pulse-slow {
  animation: pulse-slow 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
</style>
