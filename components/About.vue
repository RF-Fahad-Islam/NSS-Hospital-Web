<script setup lang="ts">
import { CheckCircle } from 'lucide-vue-next'

const features = [
  'নিরাপদ ও মানসম্মত সেবা',
  'অভিজ্ঞ ও দক্ষ চিকিৎসক',
  'গোপনীয়তা ও সম্মান',
  'সাশ্রয়ী খরচে চিকিৎসা',
]
</script>

<template>
  <section id="about" class="section-padding">
    <div class="section-container">
      <div class="grid lg:grid-cols-2 gap-12 lg:gap-16 items-center">
        <!-- Image Side -->
        <div class="relative">
          <div class="relative z-10">
            <div class="aspect-[4/3] rounded-2xl overflow-hidden shadow-medical-lg">
              <img
                src="https://images.unsplash.com/photo-1551076805-e1869033e561?auto=format&fit=crop&w=800&q=80"
                alt="Modern hospital facility"
                class="w-full h-full object-cover"
              />
            </div>
          </div>
          
          <!-- Decorative Elements -->
          <div class="absolute -bottom-6 -left-6 w-32 h-32 bg-secondary/20 rounded-2xl -z-10" />
          <div class="absolute -top-6 -right-6 w-24 h-24 bg-primary/10 rounded-2xl -z-10" />
          
          <!-- Experience Badge -->
          <div class="absolute -bottom-4 right-8 bg-card rounded-xl shadow-medical p-4 z-20">
            <div class="text-center">
              <p class="text-3xl font-bold text-primary">24+</p>
              <p class="text-sm text-muted-foreground">Years of Service</p>
            </div>
          </div>
        </div>

        <!-- Content Side -->
        <div>
          <span class="text-secondary font-semibold tracking-wide uppercase text-sm">
            আমাদের সম্পর্কে
          </span>
          <h2 class="heading-lg text-foreground mt-3 mb-6">
            যত্ন, বিশ্বাস ও নিরাপদ<br/>স্বাস্থ্যসেবার প্রতিশ্রুতি
          </h2>
          <p class="text-muted-foreground text-lg mb-6 leading-relaxed">
            মা স্বাস্থ্য সেবা কেন্দ্র এবং মেরি ক্লিনিক—এই দুইটি স্বাস্থ্যসেবা প্রতিষ্ঠান একই লক্ষ্য ও আদর্শ নিয়ে দীর্ঘদিন ধরে মানুষের সেবায় কাজ করে যাচ্ছে।
          </p>
          <p class="text-muted-foreground mb-8 leading-relaxed">
            আমাদের প্রধান উদ্দেশ্য হলো নিরাপদ, মানসম্মত ও সাশ্রয়ী স্বাস্থ্যসেবা সাধারণ মানুষের দোরগোড়ায় পৌঁছে দেওয়া, বিশেষ করে মা, শিশু ও পরিবারের জন্য। আমরা বিশ্বাস করি, ভালো চিকিৎসা মানে শুধু রোগ নিরাময় নয়—এটি রোগীর প্রতি মানবিক আচরণ, গোপনীয়তা এবং সম্মান প্রদর্শনের সমন্বয়।
          </p>

          <!-- Features List -->
          <ul class="space-y-3 mb-8">
            <li v-for="feature in features" :key="feature" class="flex items-center gap-3">
              <CheckCircle class="w-5 h-5 text-secondary shrink-0" />
              <span class="text-foreground">{{ feature }}</span>
            </li>
          </ul>

          <NuxtLink to="/about-us" class="btn-primary inline-flex items-center">
            আরও জানুন
          </NuxtLink>
        </div>
      </div>
    </div>
  </section>
</template>
