<template>
  <div class="chatbot-container">
    <!-- Chatbot Toggle Button -->
    <Transition name="bounce">
      <button
        v-if="!isChatOpen"
        @click="toggleChat"
        class="chatbot-toggle"
        aria-label="Open AI Chat Assistant"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="chat-icon"
        >
          <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
          <circle cx="9" cy="10" r="1" fill="currentColor"></circle>
          <circle cx="12" cy="10" r="1" fill="currentColor"></circle>
          <circle cx="15" cy="10" r="1" fill="currentColor"></circle>
        </svg>
        <div class="pulse-ring"></div>
      </button>
    </Transition>

    <!-- Chat Window -->
    <Transition name="slide-up">
      <div v-if="isChatOpen" class="chat-window">
        <!-- Chat Header -->
        <div class="chat-header">
          <div class="header-content">
            <div class="bot-avatar">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
              >
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                <circle cx="12" cy="16" r="1" fill="currentColor"></circle>
              </svg>
            </div>
            <div class="header-info">
              <h3>{{ preferredLanguage === 'bn' ? 'AI সহায়ক' : 'AI Assistant' }}</h3>
              <p class="status">
                <span class="status-dot"></span>
                {{ preferredLanguage === 'bn' ? 'অনলাইন' : 'Online' }}
              </p>
            </div>
          </div>
          <div class="header-actions">
            <!-- Language Toggle Button -->
            <button 
              @click="toggleLanguage" 
              class="lang-toggle-btn" 
              :aria-label="preferredLanguage === 'bn' ? 'Switch to English' : 'Switch to Bangla'"
              :title="preferredLanguage === 'bn' ? 'Switch to English' : 'বাংলায় পরিবর্তন করুন'"
            >
              <span class="lang-text">{{ preferredLanguage === 'bn' ? 'EN' : 'বাং' }}</span>
            </button>
            <button @click="toggleChat" class="close-btn" aria-label="Close chat">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
              >
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
              </svg>
            </button>
          </div>
        </div>

        <!-- Chat Messages -->
        <div class="chat-messages" ref="messagesContainer">
          <div
            v-for="(message, index) in messages"
            :key="index"
            :class="['message', message.type]"
          >
            <div v-if="message.type === 'bot'" class="message-avatar">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
              >
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
              </svg>
            </div>
            <div class="message-content">
              <p v-html="message.text"></p>
              <span class="message-time">{{ message.time }}</span>
            </div>
          </div>

          <!-- Typing Indicator -->
          <div v-if="isTyping" class="message bot typing-indicator">
            <div class="message-avatar">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
              >
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
              </svg>
            </div>
            <div class="message-content">
              <div class="typing-dots">
                <span></span>
                <span></span>
                <span></span>
              </div>
            </div>
          </div>
        </div>

        <!-- Chat Input -->
        <div class="chat-input-container">
          <form @submit.prevent="sendMessage" class="chat-input-form">
            <input
              v-model="userInput"
              type="text"
              placeholder="বাংলা বা ইংরেজিতে জিজ্ঞাসা করুন / Ask in Bangla or English..."
              class="chat-input"
              :disabled="isTyping"
            />
            <button
              type="submit"
              class="send-btn"
              :disabled="!userInput.trim() || isTyping"
              aria-label="Send message"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
              >
                <line x1="22" y1="2" x2="11" y2="13"></line>
                <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
              </svg>
            </button>
          </form>
        </div>

        <!-- Quick Suggestions -->
        <div v-if="messages.length === 1" class="quick-suggestions">
          <button
            v-for="(suggestion, index) in quickSuggestions"
            :key="index"
            @click="sendQuickMessage(suggestion)"
            class="suggestion-btn"
          >
            {{ suggestion }}
          </button>
        </div>
      </div>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { ref, nextTick, onMounted, computed } from 'vue'
import { useSupabaseClient } from '#imports'

interface Message {
  text: string
  type: 'user' | 'bot'
  time: string
}

interface Doctor {
  id: string
  name: string
  specialty: string
  experience: string
  rating: number
  languages: string[]
  available_days: string[]
  branch_id: string
}

interface Service {
  id: string
  title: string
  description: string
  full_description: string
}

interface Branch {
  id: string
  name: string
  address: string
  phone: string
  email: string
}

const isChatOpen = ref(false)
const userInput = ref('')
const isTyping = ref(false)
const messagesContainer = ref<HTMLElement | null>(null)

// Language preference - Bangla is primary (default)
const preferredLanguage = ref<'bn' | 'en'>('bn')

// Data from Supabase
const doctors = ref<Doctor[]>([])
const services = ref<Service[]>([])
const branches = ref<Branch[]>([])

const messages = ref<Message[]>([
  {
    text: "নমস্কার! আমি আপনার AI সহায়ক। আজ আমি আপনাকে কীভাবে সাহায্য করতে পারি?",
    type: 'bot',
    time: getCurrentTime(),
  },
])

// Quick suggestions based on language
const quickSuggestions = computed(() => {
  if (preferredLanguage.value === 'bn') {
    return [
      'সেবা দেখান',
      'ডাক্তার তালিকা',
      'শাখা তালিকা',
      'অ্যাপয়েন্টমেন্ট',
    ]
  } else {
    return [
      'What services?',
      'Show doctors',
      'Branch locations',
      'Book appointment',
    ]
  }
})

// Fetch data from Supabase
onMounted(async () => {
  await fetchData()
})

async function fetchData() {
  try {
    const supabase = useSupabaseClient()
    
    // Fetch doctors
    const { data: doctorsData } = await supabase
      .from('doctors')
      .select('*')
      .order('sequence', { ascending: true, nullsFirst: false })
    
    if (doctorsData) doctors.value = doctorsData

    // Fetch services
    const { data: servicesData } = await supabase
      .from('services')
      .select('*')
      .order('title')
    
    if (servicesData) services.value = servicesData

    // Fetch branches
    const { data: branchesData } = await supabase
      .from('branches')
      .select('*')
      .order('sequence', { ascending: true, nullsFirst: false })
    
    if (branchesData) branches.value = branchesData
  } catch (error) {
    console.error('Error fetching data:', error)
  }
}

function toggleLanguage() {
  preferredLanguage.value = preferredLanguage.value === 'bn' ? 'en' : 'bn'
  
  // Add system message about language change
  const langChangeMessage = preferredLanguage.value === 'bn'
    ? 'ভাষা বাংলায় পরিবর্তন হয়েছে।'
    : 'Language switched to English.'
  
  messages.value.push({
    text: `<em>${langChangeMessage}</em>`,
    type: 'bot',
    time: getCurrentTime(),
  })
  
  nextTick(() => {
    scrollToBottom()
  })
}

function toggleChat() {
  isChatOpen.value = !isChatOpen.value
  if (isChatOpen.value) {
    nextTick(() => {
      scrollToBottom()
    })
  }
}

function getCurrentTime(): string {
  const now = new Date()
  return now.toLocaleTimeString('en-US', {
    hour: '2-digit',
    minute: '2-digit',
  })
}

function sendQuickMessage(suggestion: string) {
  userInput.value = suggestion
  sendMessage()
}

async function sendMessage() {
  if (!userInput.value.trim()) return

  // Add user message
  messages.value.push({
    text: userInput.value,
    type: 'user',
    time: getCurrentTime(),
  })

  const query = userInput.value.toLowerCase()
  userInput.value = ''

  await nextTick()
  scrollToBottom()

  // Show typing indicator
  isTyping.value = true

  // Simulate AI response delay
  setTimeout(() => {
    const response = generateResponse(query)
    messages.value.push({
      text: response,
      type: 'bot',
      time: getCurrentTime(),
    })
    isTyping.value = false
    nextTick(() => {
      scrollToBottom()
    })
  }, 1000 + Math.random() * 1000)
}

function detectLanguage(query: string): 'bn' | 'en' | 'mixed' {
  // Detect Bengali characters
  const bengaliPattern = /[\u0980-\u09FF]/
  const hasBengali = bengaliPattern.test(query)
  const hasEnglish = /[a-zA-Z]/.test(query)
  
  if (hasBengali && hasEnglish) return 'mixed'
  if (hasBengali) return 'bn'
  return 'en'
}

function generateResponse(query: string): string {
  // Use preferred language instead of detecting from query
  const lang = preferredLanguage.value
  
  // Services query
  if (
    query.includes('সেবা') ||
    query.includes('service') ||
    query.includes('treatment') ||
    query.includes('offer')
  ) {
    return generateServicesResponse(lang)
  }
  
  // Doctors query
  else if (
    query.includes('ডাক্তার') ||
    query.includes('doctor') ||
    query.includes('specialist') ||
    query.includes('চিকিৎসক')
  ) {
    return generateDoctorsResponse(lang, query)
  }
  
  // Branches query
  else if (
    query.includes('শাখা') ||
    query.includes('branch') ||
    query.includes('location') ||
    query.includes('ঠিকানা') ||
    query.includes('address') ||
    query.includes('where')
  ) {
    return generateBranchesResponse(lang)
  }
  
  // Appointment query
  else if (
    query.includes('appointment') ||
    query.includes('book') ||
    query.includes('schedule') ||
    query.includes('অ্যাপয়েন্টমেন্ট') ||
    query.includes('সিরিয়াল')
  ) {
    return generateAppointmentResponse(lang)
  }
  
  // Hours query
  else if (
    query.includes('hour') ||
    query.includes('time') ||
    query.includes('open') ||
    query.includes('সময়') ||
    query.includes('খোলা')
  ) {
    return generateHoursResponse(lang)
  }
  
  // Contact query
  else if (
    query.includes('contact') ||
    query.includes('call') ||
    query.includes('phone') ||
    query.includes('যোগাযোগ') ||
    query.includes('ফোন')
  ) {
    return generateContactResponse(lang)
  }
  
  // Greetings
  else if (
    query.includes('hello') ||
    query.includes('hi') ||
    query.includes('hey') ||
    query.includes('নমস্কার') ||
    query.includes('হ্যালো') ||
    query.includes('হাই')
  ) {
    if (lang === 'bn') {
      return 'নমস্কার! আমি আপনাকে কীভাবে সাহায্য করতে পারি? আমাদের সেবা, ডাক্তার, শাখা বা অ্যাপয়েন্টমেন্ট সম্পর্কে জিজ্ঞাসা করুন!'
    } else {
      return 'Hello! How can I assist you today? Feel free to ask about our services, doctors, branch locations, or appointments!'
    }
  }
  
  // Thanks
  else if (query.includes('thank') || query.includes('ধন্যবাদ')) {
    if (lang === 'bn') {
      return 'আপনাকে স্বাগতম! আর কিছু জানতে চান?'
    } else {
      return "You're welcome! Is there anything else I can help you with?"
    }
  }
  
  // Default response
  else {
    if (lang === 'bn') {
      return 'আমি সাহায্য করতে পারব! আপনি আমাদের সেবা, ডাক্তার তালিকা, শাখার ঠিকানা, কর্মঘণ্টা বা অ্যাপয়েন্টমেন্ট বুকিং সম্পর্কে জানতে পারেন। কী জানতে চান?'
    } else {
      return "I'd be happy to help! You can ask me about our services, doctors list, branch locations, operating hours, or appointment booking. What would you like to know?"
    }
  }
}

function generateServicesResponse(lang: 'bn' | 'en' | 'mixed'): string {
  if (services.value.length === 0) {
    return lang === 'bn'
      ? 'আমরা বিভিন্ন চিকিৎসা সেবা প্রদান করি। বিস্তারিত জানতে আমাদের Services পেজ দেখুন।'
      : 'We offer a wide range of medical services. Please visit our Services page for more details.'
  }

  const servicesList = services.value
    .slice(0, 5)
    .map((s) => `• ${s.title}`)
    .join('<br>')

  if (lang === 'bn') {
    return `আমরা নিম্নলিখিত সেবা প্রদান করি:<br><br>${servicesList}<br><br>আরও বিস্তারিত জানতে Services পেজ দেখুন।`
  } else {
    return `We offer the following services:<br><br>${servicesList}<br><br>${
      services.value.length > 5 ? 'And more! ' : ''
    }Visit our Services page for complete details.`
  }
}

function generateDoctorsResponse(lang: 'bn' | 'en' | 'mixed', query: string): string {
  if (doctors.value.length === 0) {
    return lang === 'bn'
      ? 'আমাদের দক্ষ চিকিৎসক দল রয়েছে। বিস্তারিত জানতে Doctors পেজ দেখুন।'
      : 'We have a team of experienced doctors. Please visit our Doctors page for more information.'
  }

  // Check for specialty query
  let filteredDoctors = doctors.value
  if (
    query.includes('cardio') ||
    query.includes('heart') ||
    query.includes('হৃদরোগ')
  ) {
    filteredDoctors = doctors.value.filter((d) =>
      d.specialty.toLowerCase().includes('cardio')
    )
  } else if (
    query.includes('পেডিয়াট্রিক') ||
    query.includes('শিশু') ||
    query.includes('pediatric') ||
    query.includes('child')
  ) {
    filteredDoctors = doctors.value.filter((d) =>
      d.specialty.toLowerCase().includes('pediatric')
    )
  }

  const doctorsList = filteredDoctors
    .slice(0, 5)
    .map(
      (d) =>
        `• <strong>${d.name}</strong> - ${d.specialty} (${d.experience} অভিজ্ঞতা / experience)`
    )
    .join('<br>')

  if (lang === 'bn') {
    return `আমাদের ডাক্তার:<br><br>${doctorsList}<br><br>সম্পূর্ণ তালিকা দেখতে Doctors পেজ ভিজিট করুন।`
  } else {
    return `Our Doctors:<br><br>${doctorsList}<br><br>Visit our Doctors page to see the complete list and book appointments.`
  }
}

function generateBranchesResponse(lang: 'bn' | 'en' | 'mixed'): string {
  if (branches.value.length === 0) {
    return lang === 'bn'
      ? 'আমাদের একাধিক শাখা রয়েছে। বিস্তারিত জানতে Branches পেজ দেখুন।'
      : 'We have multiple branches. Please visit our Branches page for locations.'
  }

  const branchesList = branches.value
    .map(
      (b) =>
        `• <strong>${b.name}</strong><br>&nbsp;&nbsp;📍 ${b.address}<br>&nbsp;&nbsp;📞 ${b.phone}`
    )
    .join('<br><br>')

  if (lang === 'bn') {
    return `আমাদের শাখাসমূহ:<br><br>${branchesList}<br><br>আরও তথ্যের জন্য Branches পেজ দেখুন।`
  } else {
    return `Our Branch Locations:<br><br>${branchesList}<br><br>Visit our Branches page for map and more details.`
  }
}

function generateAppointmentResponse(lang: 'bn' | 'en' | 'mixed'): string {
  if (lang === 'bn') {
    return 'আপনি নিম্নলিখিত উপায়ে অ্যাপয়েন্টমেন্ট নিতে পারেন:<br><br>১. Contact পেজে যান<br>২. সরাসরি কল করুন<br>৩. অনলাইন ফর্ম পূরণ করুন<br><br>আমরা আপনার সেবায় প্রস্তুত!'
  } else {
    return 'You can book an appointment through:<br><br>1. Visit our Contact page<br>2. Call us directly<br>3. Fill out our online appointment form<br><br>We\'re here to help you!'
  }
}

function generateHoursResponse(lang: 'bn' | 'en' | 'mixed'): string {
  if (lang === 'bn') {
    return 'আমাদের কর্মঘণ্টা:<br><br>• সোমবার - শুক্রবার: সকাল ৮টা - রাত ৮টা<br>• শনিবার: সকাল ৯টা - বিকাল ৫টা<br>• রবিবার: সকাল ১০টা - বিকাল ৪টা'
  } else {
    return 'Our Operating Hours:<br><br>• Monday - Friday: 8:00 AM - 8:00 PM<br>• Saturday: 9:00 AM - 5:00 PM<br>• Sunday: 10:00 AM - 4:00 PM'
  }
}

function generateContactResponse(lang: 'bn' | 'en' | 'mixed'): string {
  const firstBranch = branches.value[0]
  
  if (lang === 'bn') {
    return `আমাদের সাথে যোগাযোগ করুন:<br><br>${
      firstBranch
        ? `📞 ${firstBranch.phone}<br>📧 ${firstBranch.email}<br><br>`
        : ''
    }আরও তথ্যের জন্য Contact পেজ দেখুন বা যেকোনো শাখায় যোগাযোগ করুন।`
  } else {
    return `Contact Us:<br><br>${
      firstBranch
        ? `📞 ${firstBranch.phone}<br>📧 ${firstBranch.email}<br><br>`
        : ''
    }Visit our Contact page or reach out to any of our branches for assistance.`
  }
}

function scrollToBottom() {
  if (messagesContainer.value) {
    messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight
  }
}
</script>

<style scoped>
.chatbot-container {
  position: fixed;
  bottom: 24px;
  right: 24px;
  z-index: 9999;
}

/* Toggle Button */
.chatbot-toggle {
  @apply relative w-16 h-16 rounded-full shadow-2xl cursor-pointer transition-all duration-300;
  background: linear-gradient(135deg, #0284c7 0%, #0369a1 100%);
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.chatbot-toggle:hover {
  transform: scale(1.1);
  box-shadow: 0 20px 40px rgba(2, 132, 199, 0.4);
}

.chatbot-toggle:active {
  transform: scale(0.95);
}

.chat-icon {
  width: 30px;
  height: 30px;
  position: relative;
  z-index: 2;
}

.pulse-ring {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 100%;
  height: 100%;
  border: 3px solid rgba(2, 132, 199, 0.6);
  border-radius: 50%;
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

@keyframes pulse {
  0%,
  100% {
    opacity: 1;
    transform: translate(-50%, -50%) scale(1);
  }
  50% {
    opacity: 0;
    transform: translate(-50%, -50%) scale(1.3);
  }
}

/* Chat Window */
.chat-window {
  @apply bg-white rounded-2xl shadow-2xl overflow-hidden;
  width: 380px;
  height: 550px;
  display: flex;
  flex-direction: column;
  border: 1px solid rgba(0, 0, 0, 0.1);
}

/* Chat Header */
.chat-header {
  @apply flex items-center justify-between px-5 py-4;
  background: linear-gradient(135deg, #0284c7 0%, #0369a1 100%);
  color: white;
}

.header-content {
  @apply flex items-center gap-3;
}

.bot-avatar {
  @apply w-10 h-10 rounded-full bg-white/20 flex items-center justify-center;
  backdrop-filter: blur(10px);
}

.bot-avatar svg {
  width: 20px;
  height: 20px;
}

.header-info h3 {
  @apply font-semibold text-base m-0;
  line-height: 1.3;
}

.status {
  @apply flex items-center gap-1.5 text-xs m-0;
  opacity: 0.9;
}

.status-dot {
  @apply w-2 h-2 rounded-full bg-green-400;
  animation: blink 2s ease-in-out infinite;
}

@keyframes blink {
  0%,
  100% {
    opacity: 1;
  }
  50% {
    opacity: 0.4;
  }
}

.header-actions {
  @apply flex items-center gap-2;
}

.lang-toggle-btn {
  @apply w-9 h-9 rounded-lg bg-white/20 border-none cursor-pointer transition-all duration-200;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-weight: 600;
  font-size: 13px;
  backdrop-filter: blur(10px);
}

.lang-toggle-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: scale(1.05);
}

.lang-toggle-btn:active {
  transform: scale(0.95);
}

.lang-text {
  display: block;
  line-height: 1;
}

.close-btn {
  @apply w-8 h-8 rounded-full bg-white/20 border-none cursor-pointer transition-all duration-200;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.close-btn:hover {
  background: rgba(255, 255, 255, 0.3);
}

.close-btn svg {
  width: 18px;
  height: 18px;
}

/* Chat Messages */
.chat-messages {
  @apply flex-1 overflow-y-auto p-4;
  background: #f8fafc;
}

.message {
  @apply flex gap-2 mb-4;
  animation: slideIn 0.3s ease-out;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.message.bot {
  @apply justify-start;
}

.message.user {
  @apply justify-end;
}

.message-avatar {
  @apply w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0;
  background: linear-gradient(135deg, #0284c7 0%, #0369a1 100%);
  color: white;
}

.message-avatar svg {
  width: 16px;
  height: 16px;
}

.message-content {
  @apply max-w-[75%] rounded-2xl px-4 py-2.5;
}

.message.bot .message-content {
  @apply bg-white shadow-sm;
  border: 1px solid rgba(0, 0, 0, 0.05);
}

.message.user .message-content {
  background: linear-gradient(135deg, #0284c7 0%, #0369a1 100%);
  @apply text-white;
}

.message-content p {
  @apply m-0 text-sm leading-relaxed;
}

.message-time {
  @apply text-xs opacity-60 mt-1;
  display: block;
}

/* Typing Indicator */
.typing-indicator .message-content {
  @apply px-5 py-3;
}

.typing-dots {
  @apply flex gap-1.5;
}

.typing-dots span {
  @apply w-2 h-2 rounded-full bg-gray-400;
  animation: bounce 1.4s infinite ease-in-out;
}

.typing-dots span:nth-child(1) {
  animation-delay: -0.32s;
}

.typing-dots span:nth-child(2) {
  animation-delay: -0.16s;
}

@keyframes bounce {
  0%,
  80%,
  100% {
    transform: scale(0.8);
    opacity: 0.5;
  }
  40% {
    transform: scale(1);
    opacity: 1;
  }
}

/* Chat Input */
.chat-input-container {
  @apply border-t border-gray-200 p-4 bg-white;
}

.chat-input-form {
  @apply flex gap-2;
}

.chat-input {
  @apply flex-1 px-4 py-3 rounded-xl border border-gray-300 outline-none transition-all duration-200;
  font-size: 14px;
}

.chat-input:focus {
  @apply border-sky-500;
  box-shadow: 0 0 0 3px rgba(2, 132, 199, 0.1);
}

.chat-input:disabled {
  @apply bg-gray-100 cursor-not-allowed;
}

.send-btn {
  @apply w-11 h-11 rounded-xl border-none cursor-pointer transition-all duration-200;
  background: linear-gradient(135deg, #0284c7 0%, #0369a1 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.send-btn:hover:not(:disabled) {
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(2, 132, 199, 0.3);
}

.send-btn:disabled {
  @apply opacity-50 cursor-not-allowed;
}

.send-btn svg {
  width: 18px;
  height: 18px;
}

/* Quick Suggestions */
.quick-suggestions {
  @apply px-4 pb-4 flex flex-wrap gap-2;
}

.suggestion-btn {
  @apply px-3 py-2 rounded-lg border border-sky-200 bg-sky-50 text-sky-700 text-xs cursor-pointer transition-all duration-200;
}

.suggestion-btn:hover {
  @apply bg-sky-100 border-sky-300;
}

/* Transitions */
.bounce-enter-active {
  animation: bounceIn 0.5s ease-out;
}

.bounce-leave-active {
  animation: bounceOut 0.3s ease-in;
}

@keyframes bounceIn {
  0% {
    opacity: 0;
    transform: scale(0.3);
  }
  50% {
    transform: scale(1.05);
  }
  100% {
    opacity: 1;
    transform: scale(1);
  }
}

@keyframes bounceOut {
  to {
    opacity: 0;
    transform: scale(0.3);
  }
}

.slide-up-enter-active {
  animation: slideUp 0.3s ease-out;
}

.slide-up-leave-active {
  animation: slideDown 0.3s ease-in;
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes slideDown {
  to {
    opacity: 0;
    transform: translateY(20px);
  }
}

/* Mobile Responsiveness */
@media (max-width: 640px) {
  .chatbot-container {
    @apply bottom-4 right-4;
  }

  .chatbot-toggle {
    @apply w-14 h-14;
  }

  .chat-icon {
    width: 26px;
    height: 26px;
  }

  .chat-window {
    width: calc(100vw - 32px);
    height: calc(100vh - 100px);
    max-height: 600px;
  }

  .message-content {
    @apply max-w-[80%];
  }
}
</style>
