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
  ArrowRight,
  Globe,
  Smartphone,
  Printer
} from 'lucide-vue-next'

const quickLinks = [
  { name: 'আমাদের সম্পর্কে', href: '/about-us' },
  { name: 'সেবাসমূহ', href: '/services' },
  { name: 'ডাক্তার ও স্টাফ', href: '/doctors' },
  { name: 'অ্যাপয়েন্টমেন্ট', href: '#appointment' },
  { name: 'যোগাযোগ', href: '#contact' },
]

const services = [
  'কার্ডিওলজি',
  'শিশুরোগ',
  'স্নায়ুরোগ',
  'অর্থোপেডিক্স',
  'জরুরী সেবা',
  'ল্যাবরেটরি',
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
            <img src="/images/nss-footer-logo.png" alt="NSS Logo" class="h-16 w-auto object-contain bg-white rounded-lg p-1" />
          </a>
          <p class="text-background/70 mb-6 leading-relaxed">
            সামাজিক পরিবর্তনের জন্য জনগণের অংশগ্রহণ
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
          <h4 class="font-semibold text-lg mb-6">দ্রুত লিঙ্ক</h4>
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
          <h4 class="font-semibold text-lg mb-6">আমাদের সেবাসমূহ</h4>
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
          <h4 class="font-semibold text-lg mb-6">যোগাযোগ করুন</h4>
          <ul class="space-y-4">
            <li class="flex items-start gap-3">
              <MapPin class="w-5 h-5 text-secondary shrink-0 mt-0.5" />
              <span class="text-background/70">
                নাসরিন প্যালেস (২য় তলা) কেএন লেন<br />
                একে স্কুল রোড, উপজেলা: আমতলী<br />
                জেলা: বরগুনা-৮৭১০, বাংলাদেশ
              </span>
            </li>
            <li>
              <div class="flex items-start gap-3 text-background/70">
                <Phone class="w-5 h-5 text-secondary shrink-0 mt-1" />
                <div class="flex flex-col">
                  <a href="tel:+880445256054" class="hover:text-secondary transition-colors">ফোন: +৮৮ ০৪৪৫২ ৫৬০৫৪</a>
                  <span class="flex items-center gap-2">
                    <Printer class="w-4 h-4 ml-0" /> ফ্যাক্স: +৮৮ ০৪৪৫২ ৫৬১৬৪
                  </span>
                </div>
              </div>
            </li>
            <li>
               <div class="flex items-start gap-3 text-background/70">
                <Smartphone class="w-5 h-5 text-secondary shrink-0 mt-1" />
                <div class="flex flex-col">
                  <span class="font-medium mb-1">মোবাইল:</span>
                  <a href="tel:+8801712795359" class="hover:text-secondary transition-colors">+৮৮ ০ ১৭১২ ৭৯৫৩৫৯</a>
                  <a href="tel:+8801733096000" class="hover:text-secondary transition-colors">+৮৮ ০ ১৭৩৩ ০৯৬০০০</a>
                </div>
              </div>
            </li>
            <li>
              <a href="mailto:nssngo@gmail.com" class="flex items-center gap-3 text-background/70 hover:text-secondary transition-colors">
                <Mail class="w-5 h-5 text-secondary shrink-0" />
                nssngo@gmail.com
              </a>
            </li>
            <li>
              <a href="http://www.nssngo.org" target="_blank" rel="noopener noreferrer" class="flex items-center gap-3 text-background/70 hover:text-secondary transition-colors">
                <Globe class="w-5 h-5 text-secondary shrink-0" />
                www.nssngo.org
              </a>
            </li>
          </ul>
        </div>
      </div>

    </div>

    <!-- Bottom Bar -->
    <div class="border-t border-background/10">
      <div class="section-container py-6">
        <div class="flex flex-col md:flex-row items-center justify-between gap-4 text-sm text-background/60">
          <p>© ২০২৪ এনএসএস। সর্বস্বত্ব সংরক্ষিত।</p>
          <div class="flex gap-6">
            <a href="#" class="hover:text-secondary transition-colors">গোপনীয়তা নীতি</a>
            <a href="#" class="hover:text-secondary transition-colors">সেবার শর্তাবলী</a>
            <NuxtLink to="/admin" class="hover:text-secondary transition-colors">অ্যাডমিন</NuxtLink>
          </div>
        </div>
      </div>
    </div>
  </footer>
</template>
