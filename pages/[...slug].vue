<script setup lang="ts">
const route = useRoute()

onMounted(() => {
  console.error("404 Error: User attempted to access non-existent route:", route.path)
})

useHead({
  title: 'পাতা পাওয়া যায়নি - এনএসএস'
})
</script>

<template>
  <div class="flex min-h-screen items-center justify-center bg-muted">
    <div class="text-center">
      <h1 class="mb-4 text-4xl font-bold">৪০৪</h1>
      <p class="mb-4 text-xl text-muted-foreground">দুঃখিত! পাতাটি পাওয়া যায়নি</p>
      <NuxtLink to="/" class="text-primary underline hover:text-primary/90">
        হোম পেজে ফিরে যান
      </NuxtLink>
    </div>
  </div>
</template>
