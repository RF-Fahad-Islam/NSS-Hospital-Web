<script setup lang="ts">
import { CheckCircle, Heart, Shield, Users, Award } from 'lucide-vue-next'
const aboutHeroImage = 'https://images.unsplash.com/photo-1576091160550-217359f4ecf8?auto=format&fit=crop&w=1200&q=80'

useHead({
  title: 'About Us | Maa Health Service Center',
  meta: [
    { name: 'description', content: 'Maa Health Service Center and Mary Clinic - Promise of Care, Trust, and Safe Healthcare. Services operated by NSS.' }
  ]
})

const services = [
  'নিরাপদ এম আর (MR) ও গর্ভপাত পরবর্তী সেবা (PAC)',
  'গর্ভবতী মায়ের নিয়মিত চেকআপ ও প্রসবপূর্ব সেবা',
  'নরমাল ডেলিভারি সাপোর্ট',
  'পরিবার পরিকল্পনা ও জন্মনিয়ন্ত্রণ সেবা',
  'প্রজনন স্বাস্থ্য ও সাধারণ স্বাস্থ্য পরামর্শ',
  'শিশু স্বাস্থ্য কনসালটেশন',
  'নির্ভুল ও বিশ্বস্ত প্যাথলজি পরীক্ষা',
  'প্রয়োজনীয় টিকাদান (ভ্যাকসিনেশন) সেবা'
]

const trustPoints = [
  'একই মান ও যত্নে পরিচালিত দুইটি বিশ্বস্ত ক্লিনিক',
  'অভিজ্ঞ, দায়িত্বশীল ও রোগীবান্ধব স্বাস্থ্যকর্মী',
  'সম্পূর্ণ গোপনীয় ও নিরাপদ পরিবেশ',
  'সাশ্রয়ী খরচে মানসম্মত স্বাস্থ্যসেবা',
  'নিয়মিত ফলো-আপ ও প্রয়োজনীয় পরামর্শ'
]
</script>

<template>
  <div class="pt-24 pb-16 font-bangla">
    <div class="section-container">
      <!-- Header Section -->
      <div class="max-w-4xl mx-auto text-center mb-16" data-aos="zoom-in-up">
        <span class="text-secondary font-semibold tracking-wide uppercase text-sm">
          আমাদের সম্পর্কে
        </span>
        <h1 class="heading-lg text-foreground mt-3 mb-6">
          যত্ন, বিশ্বাস ও নিরাপদ স্বাস্থ্যসেবার প্রতিশ্রুতি
        </h1>
        <p class="text-muted-foreground text-lg leading-relaxed">
          মা স্বাস্থ্য সেবা কেন্দ্র এবং মেরি ক্লিনিক—এই দুইটি স্বাস্থ্যসেবা প্রতিষ্ঠান একই লক্ষ্য ও আদর্শ নিয়ে দীর্ঘদিন ধরে মানুষের সেবায় কাজ করে যাচ্ছে। আমাদের প্রধান উদ্দেশ্য হলো নিরাপদ, মানসম্মত ও সাশ্রয়ী স্বাস্থ্যসেবা সাধারণ মানুষের দোরগোড়ায় পৌঁছে দেওয়া, বিশেষ করে মা, শিশু ও পরিবারের জন্য।
        </p>
      </div>

      <!-- Vision/Mission Section -->
      <div class="grid lg:grid-cols-2 gap-12 items-center mb-24">
        <div class="rounded-2xl overflow-hidden shadow-medical-lg relative group" data-aos="zoom-in-up" data-aos-delay="100">
           <img
            :src="aboutHeroImage"
            alt="Compassionate Care"
            class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
          />
        </div>
        <div class="space-y-6">
          <div class="bg-card p-6 rounded-xl shadow-sm border border-border/50 hover:shadow-md transition-shadow hover:scale-[1.02] duration-300" data-aos="zoom-in-up" data-aos-delay="200">
            <h3 class="text-xl font-bold text-foreground mb-3 flex items-center gap-2">
              <Heart class="w-5 h-5 text-secondary" />
              আমাদের বিশ্বাস
            </h3>
            <p class="text-muted-foreground">
              আমরা বিশ্বাস করি, ভালো চিকিৎসা মানে শুধু রোগ নিরাময় নয়—এটি রোগীর প্রতি মানবিক আচরণ, গোপনীয়তা এবং সম্মান প্রদর্শনের সমন্বয়। এই বিশ্বাস থেকেই আমাদের প্রতিটি সেবা পরিকল্পিতভাবে ও দায়িত্বের সঙ্গে প্রদান করা হয়।
            </p>
          </div>
          
          <div class="bg-card p-6 rounded-xl shadow-sm border border-border/50 hover:shadow-md transition-shadow hover:scale-[1.02] duration-300" data-aos="zoom-in-up" data-aos-delay="300">
            <h3 class="text-xl font-bold text-foreground mb-3 flex items-center gap-2">
              <Award class="w-5 h-5 text-secondary" />
               আমাদের অঙ্গীকার
            </h3>
            <p class="text-muted-foreground">
              মা স্বাস্থ্য সেবা কেন্দ্র ও মেরি ক্লিনিক সবসময় প্রতিশ্রুতিবদ্ধ— নিরাপদ মাতৃত্ব নিশ্চিত করা, সুস্থ পরিবার গড়ে তোলা এবং একটি স্বাস্থ্যবান সমাজ নির্মাণে সক্রিয় ভূমিকা রাখার জন্য।
            </p>
          </div>
        </div>
      </div>

      <!-- Services List -->
      <div class="mb-24">
        <h2 class="text-3xl font-bold text-center mb-12" data-aos="zoom-in-up">আমাদের সেবা ও দক্ষতা</h2>
        <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div v-for="(service, index) in services" :key="index" 
               class="bg-card p-6 rounded-xl shadow-sm border border-border/50 hover:shadow-md transition-all hover:scale-[1.05]"
               data-aos="zoom-in-up"
               :data-aos-delay="index * 100">
            <div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center mb-4">
              <CheckCircle class="w-5 h-5 text-primary" />
            </div>
            <p class="font-medium text-foreground">{{ service }}</p>
          </div>
        </div>
        <p class="text-center text-muted-foreground mt-8 italic" data-aos="zoom-in-up" data-aos-delay="400">
          প্রতিটি সেবায় আমরা স্বাস্থ্যবিধি, নিরাপত্তা ও রোগীর স্বাচ্ছন্দ্যকে সর্বোচ্চ গুরুত্ব দিয়ে থাকি।
        </p>
      </div>

      <!-- Trust Factors -->
      <div class="bg-muted/30 rounded-3xl p-8 lg:p-12" data-aos="zoom-in-up">
        <div class="grid lg:grid-cols-2 gap-12 items-center">
          <div>
            <h2 class="text-3xl font-bold mb-8">কেন রোগীরা আমাদের ওপর আস্থা রাখেন</h2>
            <ul class="space-y-4">
              <li v-for="(point, index) in trustPoints" :key="index" class="flex items-start gap-3"
                  data-aos="zoom-in-up"
                  :data-aos-delay="200 + (index * 100)">
                <Shield class="w-6 h-6 text-secondary shrink-0 mt-1" />
                <span class="text-lg text-muted-foreground">{{ point }}</span>
              </li>
            </ul>
            <p class="mt-8 text-primary font-medium text-lg" data-aos="zoom-in-up" data-aos-delay="600">
              আমাদের কাছে প্রতিটি রোগী গুরুত্বপূর্ণ, এবং আমরা প্রতিটি রোগীকে পরিবারের একজন সদস্যের মতো যত্ন করে থাকি।
            </p>
          </div>
          <div class="relative" data-aos="zoom-in-up" data-aos-delay="200">
             <div class="aspect-square rounded-2xl overflow-hidden shadow-lg hover:scale-[1.02] transition-transform duration-500">
               <img 
                 src="https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=800&q=80" 
                 alt="Trust and Care" 
                 class="w-full h-full object-cover"
               />
             </div>
             <!-- Decorative blob/shape could go here -->
          </div>
        </div>
      </div>

      <!-- Closing -->
      <div class="text-center mt-24" data-aos="zoom-in-up">
         <h3 class="text-2xl font-bold text-foreground">
           আপনার ও আপনার পরিবারের স্বাস্থ্যসেবায় আমরা আছি—বিশ্বাস, যত্ন ও দায়িত্ব নিয়ে।
         </h3>
      </div>

    </div>
  </div>
</template>
