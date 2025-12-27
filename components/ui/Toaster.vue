<script setup lang="ts">
const { toasts, dismiss } = useToast()
</script>

<template>
  <div
    class="fixed top-0 z-[100] flex max-h-screen w-full flex-col-reverse p-4 sm:bottom-0 sm:right-0 sm:top-auto sm:flex-col md:max-w-[420px]"
  >
    <TransitionGroup
      name="toast"
      tag="div"
      class="flex flex-col gap-3"
      enter-active-class="transition duration-300 ease-out"
      enter-from-class="transform translate-y-full opacity-0 sm:translate-y-0 sm:translate-x-full"
      enter-to-class="transform translate-y-0 opacity-100 sm:translate-x-0"
      leave-active-class="transition duration-200 ease-in absolute w-full"
      leave-from-class="transform translate-x-0 opacity-100"
      leave-to-class="transform translate-x-full opacity-0"
      move-class="transition duration-300 ease-in-out"
    >
      <UiToast
        v-for="toast in toasts"
        :key="toast.id"
        v-bind="toast"
        @close="dismiss(toast.id)"
      />
    </TransitionGroup>
  </div>
</template>
