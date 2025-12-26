<script setup lang="ts">
import { CheckCircle } from 'lucide-vue-next'

const features = [
  'State-of-the-art medical equipment',
  'Board-certified physicians',
  'Personalized treatment plans',
  'Compassionate patient care',
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
              <p class="text-3xl font-bold text-primary">35+</p>
              <p class="text-sm text-muted-foreground">Years of Excellence</p>
            </div>
          </div>
        </div>

        <!-- Content Side -->
        <div>
          <span class="text-secondary font-semibold tracking-wide uppercase text-sm">
            About Us
          </span>
          <h2 class="heading-lg text-foreground mt-3 mb-6">
            A Legacy of Healing & Innovation
          </h2>
          <p class="text-muted-foreground text-lg mb-6 leading-relaxed">
            For over three decades, NSS has been at the forefront of 
            healthcare excellence. Our commitment to combining advanced medical 
            technology with compassionate care has made us a trusted name in the community.
          </p>
          <p class="text-muted-foreground mb-8 leading-relaxed">
            We believe that every patient deserves personalized attention and 
            the highest standard of medical care. Our team of dedicated professionals 
            works tirelessly to ensure your health and well-being.
          </p>

          <!-- Features List -->
          <ul class="space-y-3 mb-8">
            <li v-for="feature in features" :key="feature" class="flex items-center gap-3">
              <CheckCircle class="w-5 h-5 text-secondary shrink-0" />
              <span class="text-foreground">{{ feature }}</span>
            </li>
          </ul>

          <a href="#contact" class="btn-primary">
            Learn More About Us
          </a>
        </div>
      </div>
    </div>
  </section>
</template>
