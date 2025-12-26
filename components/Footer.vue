<script setup lang="ts">
import { 
  Phone, 
  Mail, 
  MapPin, 
  Clock,
  Facebook,
  Twitter,
  Instagram,
  Linkedin,
  ArrowRight
} from 'lucide-vue-next'

const quickLinks = [
  { name: 'About Us', href: '#about' },
  { name: 'Services', href: '#services' },
  { name: 'Doctors & Staff', href: '#doctors' },
  { name: 'Appointments', href: '#appointment' },
  { name: 'Contact', href: '#contact' },
]

const services = [
  'Cardiology',
  'Pediatrics',
  'Neurology',
  'Orthopedics',
  'Emergency Care',
  'Laboratory',
]

const socialLinks = [
  { icon: Facebook, href: '#', label: 'Facebook' },
  { icon: Twitter, href: '#', label: 'Twitter' },
  { icon: Instagram, href: '#', label: 'Instagram' },
  { icon: Linkedin, href: '#', label: 'LinkedIn' },
]
</script>

<template>
  <footer id="contact" class="bg-foreground text-background">
    <!-- Main Footer -->
    <div class="section-container py-16">
      <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-10 lg:gap-8">
        <!-- Brand Column -->
        <div class="lg:col-span-1">
          <a href="#" class="flex items-center gap-3 mb-6">
            <div class="w-10 h-10 rounded-xl bg-primary flex items-center justify-center">
              <span class="text-primary-foreground font-bold text-lg">N</span>
            </div>
            <span class="text-xl font-bold text-background">
              NSS
            </span>
          </a>
          <p class="text-background/70 mb-6 leading-relaxed">
            Providing compassionate healthcare with advanced medical technology 
            for over 35 years.
          </p>
          <div class="flex gap-3">
            <a
              v-for="social in socialLinks"
              :key="social.label"
              :href="social.href"
              class="w-10 h-10 rounded-lg bg-background/10 flex items-center justify-center hover:bg-primary transition-colors"
              :aria-label="social.label"
            >
              <component :is="social.icon" class="w-5 h-5" />
            </a>
          </div>
        </div>

        <!-- Quick Links -->
        <div>
          <h4 class="font-semibold text-lg mb-6">Quick Links</h4>
          <ul class="space-y-3">
            <li v-for="link in quickLinks" :key="link.name">
              <a
                :href="link.href"
                class="text-background/70 hover:text-secondary transition-colors inline-flex items-center gap-2 group"
              >
                <ArrowRight class="w-4 h-4 opacity-0 -ml-6 group-hover:opacity-100 group-hover:ml-0 transition-all" />
                {{ link.name }}
              </a>
            </li>
          </ul>
        </div>

        <!-- Services -->
        <div>
          <h4 class="font-semibold text-lg mb-6">Our Services</h4>
          <ul class="space-y-3">
            <li v-for="service in services" :key="service">
              <a
                href="#services"
                class="text-background/70 hover:text-secondary transition-colors inline-flex items-center gap-2 group"
              >
                <ArrowRight class="w-4 h-4 opacity-0 -ml-6 group-hover:opacity-100 group-hover:ml-0 transition-all" />
                {{ service }}
              </a>
            </li>
          </ul>
        </div>

        <!-- Contact Info -->
        <div>
          <h4 class="font-semibold text-lg mb-6">Contact Us</h4>
          <ul class="space-y-4">
            <li class="flex items-start gap-3">
              <MapPin class="w-5 h-5 text-secondary shrink-0 mt-0.5" />
              <span class="text-background/70">
                123 Healthcare Avenue<br />
                Medical District, NY 10001
              </span>
            </li>
            <li>
              <a href="tel:+18001234567" class="flex items-center gap-3 text-background/70 hover:text-secondary transition-colors">
                <Phone class="w-5 h-5 text-secondary shrink-0" />
                1-800-123-4567
              </a>
            </li>
            <li>
              <a href="mailto:info@nss.com" class="flex items-center gap-3 text-background/70 hover:text-secondary transition-colors">
                <Mail class="w-5 h-5 text-secondary shrink-0" />
                info@nss.com
              </a>
            </li>
            <li class="flex items-start gap-3">
              <Clock class="w-5 h-5 text-secondary shrink-0 mt-0.5" />
              <span class="text-background/70">
                Mon - Fri: 8:00 AM - 8:00 PM<br />
                Sat - Sun: 9:00 AM - 5:00 PM
              </span>
            </li>
          </ul>
        </div>
      </div>

      <!-- Newsletter -->
      <div class="mt-12 pt-10 border-t border-background/10">
        <div class="flex flex-col md:flex-row items-center justify-between gap-6">
          <div>
            <h4 class="font-semibold text-lg mb-2">Subscribe to Our Newsletter</h4>
            <p class="text-background/70">Get health tips and updates delivered to your inbox.</p>
          </div>
          <form class="flex gap-3 w-full md:w-auto" @submit.prevent>
            <input
              type="email"
              placeholder="Enter your email"
              class="flex-1 md:w-64 px-4 py-3 bg-background/10 border border-background/20 rounded-lg text-background placeholder:text-background/50 focus:outline-none focus:ring-2 focus:ring-secondary/50"
            />
            <button type="submit" class="btn-secondary shrink-0">
              Subscribe
            </button>
          </form>
        </div>
      </div>
    </div>

    <!-- Bottom Bar -->
    <div class="border-t border-background/10">
      <div class="section-container py-6">
        <div class="flex flex-col md:flex-row items-center justify-between gap-4 text-sm text-background/60">
          <p>© 2024 NSS. All rights reserved.</p>
          <div class="flex gap-6">
            <a href="#" class="hover:text-secondary transition-colors">Privacy Policy</a>
            <a href="#" class="hover:text-secondary transition-colors">Terms of Service</a>
            <NuxtLink to="/admin" class="hover:text-secondary transition-colors">Admin</NuxtLink>
          </div>
        </div>
      </div>
    </div>
  </footer>
</template>
