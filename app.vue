<script setup lang="ts">
const nuxtApp = useNuxtApp()
const loading = ref(true)

nuxtApp.hook('page:start', () => {
  loading.value = true
})

nuxtApp.hook('page:finish', () => {
  setTimeout(() => {
    loading.value = false
  }, 800) // Small delay to let the animation play and feel smooth
})

onMounted(() => {
  setTimeout(() => {
    loading.value = false
  }, 1000) // Initial load delay
})
</script>

<template>
  <div>
    <GlobalLoader :loading="loading" />
    <NuxtLayout>
      <NuxtPage />
    </NuxtLayout>
  </div>
</template>
