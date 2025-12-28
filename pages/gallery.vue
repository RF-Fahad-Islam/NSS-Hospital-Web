<script setup lang="ts">
import { ref, computed } from 'vue'
import { X } from 'lucide-vue-next'
// import { galleryImages } from '@/data/hospitalData' // Replaced with Supabase
import { supabase } from '@/lib/supabase'

useHead({
  title: 'Hospital Gallery | Maa Health Service Center',
  meta: [
    { name: 'description', content: 'Take a virtual tour of the modern facilities, equipment, and patient areas at NSS Maa Health Service Center and Mary Clinic.' }
  ]
})

interface GalleryItem {
  id: number
  src: string
  alt: string
  category: string
}

const { data: galleryImages } = await useAsyncData('gallery-page', async () => {
  const { data } = await supabase.from('gallery_items').select('*')
  return (data || []) as GalleryItem[]
})

const selectedImage = ref<GalleryItem | null>(null)
const activeCategory = ref('সব')

const categories = ['সব', 'সফলতা', 'মেডিকেল টিম', 'কার্যক্রম']

const filteredImages = computed(() => {
  const images = galleryImages.value || []
  return activeCategory.value === 'সব' 
    ? images 
    : images.filter(img => img.category === activeCategory.value)
})

const openLightbox = (image: GalleryItem) => {
  selectedImage.value = image
}

const closeLightbox = () => {
  selectedImage.value = null
}

const getImageUrl = (path: string) => {
  if (!path) return ''
  if (path.startsWith('http')) return path
  const { data } = supabase.storage.from('images').getPublicUrl(path)
  return data.publicUrl
}
</script>

<template>
  <div class="min-h-screen bg-background">
    <!-- Hero Section -->
    <section class="pt-32 pb-16 bg-gradient-to-br from-primary/5 via-background to-secondary/5">
      <div class="section-container text-center" data-aos="zoom-in-up">
        <span class="text-secondary font-semibold tracking-wide uppercase text-sm">
          আমাদের সুবিধাসমূহ
        </span>
        <h1 class="heading-xl text-foreground mt-3 mb-6">
          হাসপাতাল গ্যালারি
        </h1>
        <p class="text-muted-foreground text-lg max-w-2xl mx-auto">
          আমাদের অত্যাধুনিক চিকিৎসা সুবিধা, আধুনিক সরঞ্জাম এবং আরামদায়ক রোগীর এলাকার একটি ভার্চুয়াল ট্যুর নিন।
        </p>
      </div>
    </section>

    <!-- Filter Tabs -->
    <section class="py-8 border-b border-border">
      <div class="section-container">
        <div class="flex flex-wrap justify-center gap-3" data-aos="zoom-in-up" data-aos-delay="100">
          <button
            v-for="category in categories"
            :key="category"
            @click="activeCategory = category"
            class="px-6 py-2.5 rounded-full text-sm font-medium transition-all hover:scale-[1.05]"
            :class="activeCategory === category ? 'bg-primary text-primary-foreground shadow-md' : 'bg-muted text-muted-foreground hover:bg-muted/80'"
          >
            {{ category }}
          </button>
        </div>
      </div>
    </section>

    <!-- Gallery Grid -->
    <section class="section-padding">
      <div class="section-container">
        <div class="grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          <div
            v-for="(image, index) in filteredImages"
            :key="image.id"
            @click="openLightbox(image)"
            class="group cursor-pointer overflow-hidden rounded-xl shadow-md hover:shadow-xl transition-all duration-300 hover:scale-[1.02]"
            data-aos="zoom-in-up"
            :data-aos-delay="index * 50"
          >
            <div class="relative aspect-[4/3] overflow-hidden">
              <img
                :src="getImageUrl(image.src)"
                :alt="image.alt"
                loading="lazy"
                class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
              />
              <div class="absolute inset-0 bg-gradient-to-t from-foreground/60 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                <div class="absolute bottom-0 left-0 right-0 p-4">
                  <p class="text-primary-foreground font-medium">{{ image.alt }}</p>
                  <span class="text-primary-foreground/80 text-sm">{{ image.category }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Lightbox -->
    <div 
      v-if="selectedImage"
      class="fixed inset-0 z-50 bg-foreground/90 flex items-center justify-center p-4 animate-in fade-in zoom-in duration-300"
      @click="closeLightbox"
    >
      <button
        @click="closeLightbox"
        class="absolute top-6 right-6 p-2 rounded-full bg-background/20 hover:bg-background/40 transition-colors"
      >
        <X class="w-6 h-6 text-primary-foreground" />
      </button>
      <div 
        class="max-w-4xl max-h-[80vh] overflow-hidden rounded-2xl animate-in zoom-in-95 duration-300"
        @click.stop
      >
        <img
          :src="getImageUrl(selectedImage.src)"
          :alt="selectedImage.alt"
          class="w-full h-full object-contain"
        />
        <div class="bg-card p-4">
          <p class="text-foreground font-semibold">{{ selectedImage.alt }}</p>
          <span class="text-muted-foreground text-sm">{{ selectedImage.category }}</span>
        </div>
      </div>
    </div>

    <!-- CTA Section -->
    <section class="section-padding bg-primary">
      <div class="section-container text-center" data-aos="zoom-in-up">
        <h2 class="heading-lg text-primary-foreground mb-4">
          সরাসরি আমাদের সুবিধাগুলো অভিজ্ঞতা নিন
        </h2>
        <p class="text-primary-foreground/80 text-lg mb-8 max-w-2xl mx-auto">
          বিশ্বমানের সুযোগ-সুবিধাগুলি সরাসরি দেখতে আমাদের হাসপাতালে একটি ট্যুরের সময়সূচী করুন।
        </p>
        <a href="tel:+1234567890" class="btn-outline hover:scale-105 transition-transform duration-300 inline-block">
          ট্যুরের সময়সূচী করুন
        </a>
      </div>
    </section>
  </div>
</template>
