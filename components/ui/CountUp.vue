<script setup lang="ts">
import { ref, watch, onMounted, computed } from 'vue'

const props = defineProps<{
  end: number
  duration?: number
  prefix?: string
  suffix?: string
  locale?: string
}>()

const displayedValue = ref(0)
const duration = props.duration || 2000
const target = ref<HTMLElement | null>(null)

// Formatter to handle localization (e.g., Bangla digits)
const formatter = computed(() => {
  if (props.locale) {
    try {
      return new Intl.NumberFormat(props.locale)
    } catch (e) {
      console.warn('Invalid locale', props.locale)
      return null
    }
  }
  return null
})

const formattedValue = computed(() => {
  if (formatter.value) {
    return formatter.value.format(displayedValue.value)
  }
  return displayedValue.value
})

function animateValue() {
  const start = displayedValue.value
  const end = props.end
  let startTimestamp: number | null = null;
  
  const step = (timestamp: number) => {
    if (!startTimestamp) startTimestamp = timestamp;
    const progress = Math.min((timestamp - startTimestamp) / duration, 1);
    
    // Ease out quart
    const ease = 1 - Math.pow(1 - progress, 4);
    
    displayedValue.value = Math.floor(progress * (end - start) + start);
    
    if (progress < 1) {
      window.requestAnimationFrame(step);
    } else {
        displayedValue.value = end
    }
  };
  window.requestAnimationFrame(step);
}

onMounted(() => {
  const observer = new IntersectionObserver((entries) => {
    if (entries?.[0]?.isIntersecting) {
      animateValue()
      observer.disconnect()
    }
  }, { threshold: 0.1 })
  
  if (target.value) {
    observer.observe(target.value)
  }
})

watch(() => props.end, () => {
   animateValue()
})
</script>

<template>
  <span ref="target">
    {{ prefix }}{{ formattedValue }}{{ suffix }}
  </span>
</template>
