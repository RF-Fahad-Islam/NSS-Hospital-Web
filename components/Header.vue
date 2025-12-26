<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { Menu, X, Phone } from 'lucide-vue-next'

const route = useRoute()
const isScrolled = ref(false)
const isMobileMenuOpen = ref(false)
const isHomePage = computed(() => route.path === '/')

onMounted(() => {
  const handleScroll = () => {
    isScrolled.value = window.scrollY > 20
  }
  window.addEventListener('scroll', handleScroll)
  onUnmounted(() => window.removeEventListener('scroll', handleScroll))
})

const navLinks = [
  { name: 'About', href: '/#about', isAnchor: true },
  { name: 'Services', href: '/services', isAnchor: false },
  { name: 'Doctors & Staff', href: '/doctors', isAnchor: false },
  { name: 'Branches', href: '/branches', isAnchor: false },
  { name: 'Gallery', href: '/gallery', isAnchor: false },
]

// Adjust href based on page if needed, but in Nuxt /#id usually works well globally
</script>

<template>
  <header
    class="fixed top-0 left-0 right-0 z-50 transition-all duration-300"
    :class="[
      isScrolled
        ? 'bg-card/95 backdrop-blur-md shadow-medical'
        : 'bg-transparent'
    ]"
  >
    <div class="section-container">
      <div class="flex items-center justify-between h-20">
        <!-- Logo -->
        <NuxtLink to="/" class="flex items-center gap-3 group">
            <img src="~/assets/logo.png" alt="NSS Logo" class="h-12 w-auto object-contain rounded-lg" />
            <span class="text-xl font-bold text-foreground group-hover:text-primary transition-colors">
              NSS
            </span>
        </NuxtLink>

        <!-- Desktop Navigation -->
        <nav class="hidden lg:flex items-center gap-8">
          <template v-for="link in navLinks" :key="link.name">
            <NuxtLink :to="link.href" class="nav-link">
                {{ link.name }}
            </NuxtLink>
          </template>
        </nav>

        <!-- CTA Buttons -->
        <div class="hidden lg:flex items-center gap-4">
          <a href="tel:+1234567890" class="btn-ghost gap-2">
            <Phone class="w-4 h-4" />
            <span>Emergency</span>
          </a>
          <a href="#appointment" class="btn-primary">
            Book Appointment
          </a>
        </div>

        <!-- Mobile Menu Button -->
        <button
          @click="isMobileMenuOpen = !isMobileMenuOpen"
          class="lg:hidden p-2 hover:bg-muted rounded-lg transition-colors"
          aria-label="Toggle menu"
        >
          <X v-if="isMobileMenuOpen" class="w-6 h-6" />
          <Menu v-else class="w-6 h-6" />
        </button>
      </div>

      <!-- Mobile Menu -->
      <div v-if="isMobileMenuOpen" class="lg:hidden py-4 border-t border-border animate-fade-in">
        <nav class="flex flex-col gap-2">
          <NuxtLink
            v-for="link in navLinks"
            :key="link.name"
            :to="link.href"
            class="px-4 py-3 hover:bg-muted rounded-lg transition-colors font-medium"
            @click="isMobileMenuOpen = false"
          >
            {{ link.name }}
          </NuxtLink>
          
          <div class="pt-4 mt-2 border-t border-border flex flex-col gap-3 px-4">
            <a href="tel:+1234567890" class="btn-ghost justify-center gap-2">
              <Phone class="w-4 h-4" />
              <span>Emergency Call</span>
            </a>
            <a href="#appointment" class="btn-primary justify-center">
              Book Appointment
            </a>
          </div>
        </nav>
      </div>
    </div>
  </header>
</template>
