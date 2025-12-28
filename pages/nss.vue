<script setup lang="ts">
import { Building2, Users, Target, Heart, Shield, Globe, MapPin, Phone, Mail } from 'lucide-vue-next'

useHead({
  title: 'Pioneer of Social Change | NSS',
  meta: [
    { name: 'description', content: 'Nazrul Smriti Sangsad (NSS) - A social welfare organization working for the development of underprivileged rural and urban poor people.' },
    { name: 'keywords', content: 'NSS, NGO, social welfare, development, Bangladesh, poverty alleviation' }
  ]
})

const projects = [
  'Right Here, Right Now',
  'Community Engagement Project',
  'Strengthening Household Capacity for Climate Adaptive and Resilient Livelihood',
  'Social Transformation through Adolescent and Youth Development (STAY)',
  'Vulnerable Group Development-VGD',
  'ASTHA Project',
  'Strengthening Community Resilience to Disaster through School Safety Initiative',
  'Fisher Women’s Empowerment and Economic Development (WEED)',
  'Improving the life quality of disabled children and Youth',
  'Emergency Warehouse',
  'Improved Cook Stoves –ICS',
  'Family Planning Clinic Program',
  'Health Education, Sanitation and Nutrition Program',
  'Climate Resilient Housing Program',
  'Agricultural Technology Extension',
  'Family Planning and Reproductive Health',
  'Micro Finance Program –MFP',
  'Solid Waste Management Program',
  'NSS AgroTech',
  'WASH Business',
  'NSS InfoTech',
  'Chawra Technical and Agriculture Diploma College',
  'Action4Transformation',
  'EMPOWER'
]

const partners = [
  'Actionaid Bangladesh',
  'Action Contre La -ACF',
  'Start Fund Bangladesh',
  'Oxfam',
  'World Vision Bangladseh',
  'Swisscontact International',
  'IDCOL',
  'Bangladesh Bank Housing Fund',
  'Ministry of Information',
  'Women Affairs Department',
  'Gender Train Project-IWTC, New York',
  'Family Planning Association of Bangladesh- FPAB',
  'Naripokkho',
  'Amtali Pourashava',
  'NGO Forum',
  'Ministry of Health and Family Welfare',
  'Lilian Fonds',
  'Educo Bangladesh'
]

// Using placeholders since direct image scraping was restricted
const galleryImages = [
  'https://plus.unsplash.com/premium_photo-1682092585257-58d1c6c3206e?q=80&w=2070&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1542601906990-b4d3fb7d5b43?q=80&w=2070&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1469571486292-0ba58a3f068b?q=80&w=2070&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?q=80&w=2070&auto=format&fit=crop'
]
</script>

<template>
  <div class="min-h-screen bg-background">
    <!-- Hero Section -->
    <section class="relative py-24 bg-primary/5">
      <div class="section-container">
        <div class="max-w-4xl mx-auto text-center" data-aos="zoom-in-up">
          <span class="text-primary font-bold tracking-wider uppercase text-sm mb-4 block">
            ESTABLISHED 2000
          </span>
          <h1 class="heading-xl text-foreground mb-6">
            Nazrul Smriti Sangsad (NSS)
          </h1>
          <p class="text-xl text-muted-foreground leading-relaxed">
            "People Participation for Social Change"
          </p>
        </div>
      </div>
    </section>

    <!-- About Section -->
    <section class="section-padding">
      <div class="section-container">
        <div class="grid lg:grid-cols-2 gap-12 items-center">
          <div class="space-y-6">
            <h2 class="heading-lg text-foreground" data-aos="zoom-in-up">About NSS</h2>
            <p class="text-lg text-muted-foreground leading-relaxed" data-aos="zoom-in-up" data-aos-delay="100">
              NSS has been implementing different types of projects and programs in the coastal upazilas of Barguna and Patuakhali districts since its development interventions in 2000. In the last few years, NSS has focused on addressing the needs of disadvantaged rural and urban poor people including vulnerable and ethnic groups.
            </p>
            <p class="text-lg text-muted-foreground leading-relaxed" data-aos="zoom-in-up" data-aos-delay="200">
              NSS believes that only through working together honestly, transparently, efficiently with maximum social commitment providing with necessary humanitarian and right based support with these backward community will their hopes and dreams be achieved.
            </p>
            
            <div class="grid sm:grid-cols-2 gap-6 mt-8">
              <div class="flex gap-4" data-aos="zoom-in-up" data-aos-delay="300">
                <div class="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center shrink-0">
                  <Target class="w-6 h-6 text-primary" />
                </div>
                <div>
                  <h3 class="font-bold text-foreground mb-1">Mission</h3>
                  <p class="text-sm text-muted-foreground">Empowering disadvantaged communities through sustainable development.</p>
                </div>
              </div>
              <div class="flex gap-4" data-aos="zoom-in-up" data-aos-delay="400">
                <div class="w-12 h-12 rounded-xl bg-secondary/10 flex items-center justify-center shrink-0">
                  <Heart class="w-6 h-6 text-secondary" />
                </div>
                <div>
                  <h3 class="font-bold text-foreground mb-1">Values</h3>
                  <p class="text-sm text-muted-foreground">Honesty, Transparency, Efficiency, and Social Commitment.</p>
                </div>
              </div>
            </div>
          </div>
          <div class="relative" data-aos="zoom-in-up" data-aos-delay="200">
            <div class="aspect-square rounded-2xl overflow-hidden shadow-xl">
               <!-- Placeholder for About Image -->
               <img 
                src="https://images.unsplash.com/photo-1531206715517-5c0ba140b2b8?q=80&w=2070&auto=format&fit=crop" 
                alt="NSS Community Work" 
                class="w-full h-full object-cover transition-transform duration-700 hover:scale-110"
              />
            </div>
            <!-- Decorative Elements -->
            <div class="absolute -bottom-6 -left-6 w-48 h-48 bg-primary/10 rounded-full -z-10 blur-3xl animate-pulse"></div>
            <div class="absolute -top-6 -right-6 w-48 h-48 bg-secondary/10 rounded-full -z-10 blur-3xl animate-pulse" style="animation-delay: 1s;"></div>
          </div>
        </div>
      </div>
    </section>

    <!-- Projects Section -->
    <section class="section-padding bg-muted/30">
      <div class="section-container">
        <div class="text-center max-w-2xl mx-auto mb-16" data-aos="zoom-in-up">
          <h2 class="heading-lg text-foreground mb-4">Present Programs and Projects</h2>
          <p class="text-muted-foreground">Ongoing initiatives making a difference in our community.</p>
        </div>

        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div 
            v-for="(project, index) in projects" 
            :key="index"
            class="bg-card p-6 rounded-xl border border-border hover:shadow-lg transition-all flex items-start gap-4 hover:scale-[1.02]"
            data-aos="zoom-in-up"
            :data-aos-delay="index * 50"
          >
            <div class="w-10 h-10 rounded-lg bg-primary/10 flex items-center justify-center shrink-0 mt-1">
              <Shield class="w-5 h-5 text-primary" />
            </div>
            <p class="font-medium text-foreground">{{ project }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Donors & Partners -->
    <section class="section-padding">
      <div class="section-container">
        <div class="text-center max-w-2xl mx-auto mb-16" data-aos="zoom-in-up">
          <h2 class="heading-lg text-foreground mb-4">Donors and Partners</h2>
          <p class="text-muted-foreground">We are proud to work with these organizations.</p>
        </div>

        <div class="flex flex-wrap justify-center gap-4">
          <div 
            v-for="(partner, index) in partners" 
            :key="index"
            class="px-6 py-3 bg-muted rounded-full text-sm font-medium text-muted-foreground hover:bg-primary/10 hover:text-primary transition-colors cursor-default hover:scale-105 transform duration-300"
            data-aos="zoom-in-up"
            :data-aos-delay="index * 50"
          >
            {{ partner }}
          </div>
        </div>
      </div>
    </section>

    <!-- Gallery Section -->
    <section class="section-padding bg-muted/30">
        <div class="section-container">
            <div class="text-center max-w-2xl mx-auto mb-12" data-aos="zoom-in-up">
            <h2 class="heading-lg text-foreground mb-4">Photo Gallery</h2>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                <div v-for="(img, idx) in galleryImages" :key="idx" class="aspect-square rounded-xl overflow-hidden group relative hover:scale-[1.02] transition-transform duration-500" data-aos="zoom-in-up" :data-aos-delay="idx * 100">
                    <img :src="img" alt="NSS Gallery" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110" />
                    <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                        <span class="text-white font-medium">View</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section class="py-24 bg-primary text-primary-foreground">
      <div class="section-container text-center" data-aos="zoom-in-up">
        <h2 class="text-3xl font-bold mb-12">Contact Us</h2>
        <div class="grid md:grid-cols-3 gap-8 max-w-4xl mx-auto">
          <div class="flex flex-col items-center gap-4 p-6 rounded-2xl bg-white/10 backdrop-blur-sm hover:scale-[1.02] transition-transform duration-300" data-aos="zoom-in-up" data-aos-delay="100">
            <MapPin class="w-8 h-8" />
            <p class="font-medium">Nasrin Palace (2nd Floor) KN Lane, AK School Road, Upazila- Amtali, District -Barguna. Bangladesh</p>
          </div>
          <div class="flex flex-col items-center gap-4 p-6 rounded-2xl bg-white/10 backdrop-blur-sm hover:scale-[1.02] transition-transform duration-300" data-aos="zoom-in-up" data-aos-delay="200">
            <Phone class="w-8 h-8" />
            <div>
              <p class="font-medium">04452-56054</p>
              <p class="font-medium">01712-795359</p>
            </div>
          </div>
          <div class="flex flex-col items-center gap-4 p-6 rounded-2xl bg-white/10 backdrop-blur-sm hover:scale-[1.02] transition-transform duration-300" data-aos="zoom-in-up" data-aos-delay="300">
            <Mail class="w-8 h-8" />
            <p class="font-medium">nssngo@gmail.com</p>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>
