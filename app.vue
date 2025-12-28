<script setup lang="ts">
const nuxtApp = useNuxtApp()
const route = useRoute()
const { trackVisit } = useAnalytics()
const loading = ref(true)

// Track visits on route change
watch(() => route.path, (path) => {
  trackVisit(path)
}, { immediate: true })

nuxtApp.hook('page:start', () => {
  loading.value = true
})

nuxtApp.hook('page:finish', () => {
  setTimeout(() => {
    loading.value = false
  }, 300) // Reduced delay for faster feel
})

onMounted(() => {
  setTimeout(() => {
    loading.value = false
  }, 500) // Reduced initial load delay
})
</script>

<template>
  <div>
    <GlobalLoader :loading="loading" />
    <NuxtLayout>
      <NuxtPage />
    </NuxtLayout>
    <AIChatbot />
    <UiToaster />
  </div>
</template>
