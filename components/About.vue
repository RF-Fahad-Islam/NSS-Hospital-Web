<script setup lang="ts">
import { CheckCircle, Quote } from 'lucide-vue-next'
import headImage from '~/assets/head.jpeg'

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
        <div class="relative" data-aos="fade-right" data-aos-duration="1000">
          <div class="relative z-10">
            <div class="aspect-[4/3] rounded-2xl overflow-hidden shadow-medical-lg">
              <img
                src="https://images.unsplash.com/photo-1581056771107-24ca5f033842?auto=format&fit=crop&w=800&q=80"
                alt="Compassionate health care professionals"
                class="w-full h-full object-cover"
              />
            </div>
          </div>
          
          <!-- Decorative Elements -->
          <div class="absolute -bottom-6 -left-6 w-32 h-32 bg-secondary/20 rounded-2xl -z-10"></div>
          <div class="absolute -top-6 -right-6 w-24 h-24 bg-primary/10 rounded-2xl -z-10"></div>
          
          <!-- Experience Badge -->
          <div class="absolute -bottom-4 right-8 bg-card rounded-xl shadow-medical p-4 z-20">
            <div class="text-center">
              <p class="text-3xl font-bold text-primary">24+</p>
              <p class="text-sm text-muted-foreground">Years of Service</p>
            </div>
          </div>
        </div>

        <!-- Content Side -->
        <div data-aos="fade-left" data-aos-duration="1000">
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

      <!-- Executive Director Statement - Full Width Box -->
      <div class="mt-20 max-w-5xl mx-auto" data-aos="fade-up" data-aos-duration="1000">
        <div class="bg-card rounded-3xl p-8 md:p-12 shadow-medical-lg border border-muted/50 relative overflow-hidden group hover:shadow-xl transition-all duration-500">
          
          <!-- Large Decorative Quote -->
          <div class="absolute top-0 right-0 opacity-[0.03] group-hover:opacity-[0.06] transition-opacity duration-500 pointer-events-none">
            <Quote class="w-64 h-64 md:w-96 md:h-96 text-primary rotate-12 transform translate-x-1/4 -translate-y-1/4" />
          </div>

          <div class="relative z-10 flex flex-col md:flex-row items-center gap-8 md:gap-12">
            <!-- Large Image -->
            <div class="relative shrink-0">
              <div class="w-40 h-40 md:w-56 md:h-56 rounded-full p-1.5 bg-gradient-to-br from-primary/20 to-secondary/20 group-hover:from-primary/30 group-hover:to-secondary/30 transition-colors duration-500">
                <div class="w-full h-full rounded-full overflow-hidden border-4 border-background shadow-inner">
                  <img 
                    :src="headImage" 
                    alt="Shahabuddin Panna"
                    class="w-full h-full object-cover transform group-hover:scale-105 transition-transform duration-700"
                  />
                </div>
              </div>
              <!-- Floating Badge -->
              <div class="absolute bottom-2 right-2 md:bottom-4 md:right-4 bg-background text-secondary rounded-full p-3 shadow-medical border border-muted animate-bounce-custom">
                 <Quote class="w-6 h-6 fill-current" />
              </div>
            </div>

            <!-- Content -->
            <div class="text-center md:text-left flex-1">
              <h3 class="heading-md md:text-3xl font-bold text-foreground mb-2">শাহাবুদ্দিন পাননা</h3>
              <div class="text-primary font-semibold text-lg md:text-xl mb-6 flex flex-col md:flex-row items-center md:items-start md:gap-3">
                <span>নির্বাহী পরিচালক</span>
                <span class="hidden md:inline text-muted-foreground">•</span>
                <span class="text-secondary">নজরুল স্মৃতি সংসদ (এনএসএস)</span>
              </div>
              
              <div class="bg-muted/30 rounded-2xl p-6 border border-border/50 relative">
                <Quote class="w-8 h-8 text-primary/20 absolute -top-3 -left-2 transform -scale-x-100" />
                 <p class="text-muted-foreground text-lg md:text-xl italic leading-relaxed">
                  "আমাদের লক্ষ্য কেবল চিকিৎসাসেবা প্রদান নয়, বরং প্রতিটি মানুষের মুখে হাসি ফোটানো। আমরা বিশ্বাস করি, সেবাই ধর্ম, সেবাই কর্ম। আপনাদের সুস্থতাই আমাদের একমাত্র ব্রত।"
                </p>
                <Quote class="w-8 h-8 text-primary/20 absolute -bottom-3 -right-2" />
              </div>
              
              <div class="mt-4 flex items-center justify-center md:justify-start gap-2 text-sm text-muted-foreground">
                 <span class="w-2 h-2 rounded-full bg-primary animate-pulse"></span>
                 <span>আমতলী, বরগুনা</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
