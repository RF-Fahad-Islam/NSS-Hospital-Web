// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },
  modules: ['@nuxtjs/tailwindcss', '@nuxtjs/supabase'],
  supabase: {
    redirect: false,
    url: process.env.VITE_SUPABASE_URL,
    key: process.env.VITE_SUPABASE_PUBLISHABLE_KEY
  },
  css: ['~/assets/css/main.css', 'aos/dist/aos.css'],
  srcDir: '.',
  build: {
    transpile: ['lucide-vue-next']
  },
  app: {
    head: {
      titleTemplate: '%s - NSS',
      htmlAttrs: {
        lang: 'bn'
      },
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        { name: 'description', content: 'NSS পরিচালিত মা স্বাস্থ্য সেবা কেন্দ্র ও মেরি ক্লিনিক। নিরাপদ মাতৃত্ব ও পারিবারিক স্বাস্থ্যসেবায় অঙ্গীকারবদ্ধ।' },
        { name: 'keywords', content: 'NSS, hospital, clinic, healthcare, doctor, Bangladesh, medical services, maternity' },
        { property: 'og:site_name', content: 'NSS' },
        { property: 'og:locale', content: 'bn_BD' }
      ],
      link: [
        { rel: 'icon', type: 'image/png', href: '/favicon.png' },
        { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Hind+Siliguri:wght@300;400;500;600;700&display=swap' }
      ]
    },
    pageTransition: { name: 'page', mode: 'out-in' }
  },
  runtimeConfig: {
    public: {
      supabaseUrl: process.env.VITE_SUPABASE_URL,
      supabaseKey: process.env.VITE_SUPABASE_PUBLISHABLE_KEY
    }
  }
})
