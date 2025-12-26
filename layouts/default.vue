<script setup lang="ts">
// Default layout
</script>

<template>
  <div class="min-h-screen bg-background flex flex-col">
    <Header />
    <main class="flex-1">
      <slot />
    </main>
    <Footer />
  </div>
</template>
