<script setup lang="ts">
import { ArrowRight, Phone } from 'lucide-vue-next'
import heroImage from '@/assets/hero-medical.jpg'

const stats = [
  { icon: '🏆', value: '১৫,০০০+', label: 'সফল অস্ত্রোপচার' },
  { icon: '⭐', value: '৪.৯/৫', label: 'রোগীর সন্তুষ্টি' }
]
</script>

<template>
  <section class="relative min-h-[50vh] flex items-center overflow-hidden">
    <!-- Background Image with Overlay -->
    <div class="absolute inset-0">
      <img :src="heroImage" alt="Modern healthcare facility" class="w-full h-full object-cover" />
      <div class="absolute inset-0 bg-gradient-to-r from-primary/90 via-primary/60 to-secondary/30" />
    </div>

    <!-- Content -->
    <div class="relative z-10 section-container section-padding pt-24 md:pt-28">
      <div class="grid lg:grid-cols-2 gap-12 items-center">
        <!-- Left Column: Text -->
        <div class="max-w-3xl">
          <div class="animate-fade-up opacity-0">
            <span class="inline-flex items-center gap-2 px-4 py-2 bg-primary-foreground/10 backdrop-blur-sm rounded-full text-primary-foreground/90 text-sm font-medium mb-6">
              <span class="w-2 h-2 bg-secondary rounded-full animate-pulse-soft" />
              ১৯৮৫ সাল থেকে বিশ্বস্ত স্বাস্থ্যসেবা
            </span>
          </div>

          <h1 class="heading-xl text-primary-foreground mb-6 animate-fade-up opacity-0 stagger-1 text-balance">
            <span class="block text-5xl md:text-7xl font-extrabold tracking-tight mb-2">এনএসএস</span>
            <span class="block text-3xl md:text-5xl font-bold tracking-tight mb-4">মা স্বাস্থ্য সেবা কেন্দ্র</span>
            <span class="text-secondary-foreground/90 text-2xl md:text-3xl font-medium block">সামাজিক পরিবর্তনের জন্য জনগণের অংশগ্রহণ</span>
          </h1>

          <p class="text-lg md:text-xl text-primary-foreground/80 mb-10 max-w-xl animate-fade-up opacity-0 stagger-2 text-balance">
            আমাদের বিশেষজ্ঞ চিকিৎসকদের তত্ত্বাবধানে বিশ্বমানের স্বাস্থ্যসেবার অভিজ্ঞতা নিন। 
            আমরা আপনাকে সুস্থ জীবন যাপনে সহায়তা করতে আধুনিক প্রযুক্তি এবং ব্যক্তিগত যত্ন প্রদান করি।
          </p>

          <div class="flex flex-col sm:flex-row gap-4 animate-fade-up opacity-0 stagger-3">
            <a href="#services" class="btn-secondary gap-2 group">
              আমাদের সেবাসমূহ
              <ArrowRight class="w-4 h-4 transition-transform group-hover:translate-x-1" />
            </a>
            <a href="tel:+880445256054" class="btn-outline gap-2">
              <Phone class="w-4 h-4" />
              জরুরী: +৮৮ ০৪৪৫২ ৫৬০৫৪
            </a>
          </div>
        </div>

        <!-- Right Column: Stats Card -->
        <div class="hidden lg:flex justify-end animate-fade-up opacity-0 stagger-4">
          <div class="bg-card/95 backdrop-blur-sm rounded-2xl p-6 shadow-medical-lg max-w-xs w-full">
            <div class="flex items-center gap-4 mb-4">
               <div class="w-12 h-12 rounded-full bg-secondary/20 flex items-center justify-center">
                  <span class="text-2xl">🏆</span>
               </div>
               <div>
                  <p class="text-2xl font-bold text-foreground">১৫,০০০+</p>
                  <p class="text-sm text-muted-foreground">সফল অস্ত্রোপচার</p>
               </div>
            </div>
            <div class="flex items-center gap-4">
               <div class="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center">
                  <span class="text-2xl">⭐</span>
               </div>
               <div>
                  <p class="text-2xl font-bold text-foreground">৪.৯/৫</p>
                  <p class="text-sm text-muted-foreground">রোগীর সন্তুষ্টি</p>
               </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Scroll Indicator -->
    <div class="absolute bottom-8 left-1/2 -translate-x-1/2 animate-bounce">
      <div class="w-6 h-10 border-2 border-primary-foreground/30 rounded-full flex justify-center">
        <div class="w-1.5 h-3 bg-primary-foreground/50 rounded-full mt-2 animate-pulse" />
      </div>
    </div>
  </section>
</template>
