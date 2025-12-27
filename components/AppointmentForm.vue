<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useSupabaseClient } from '#imports'
import { Calendar, Clock, User, Mail, Phone, MessageSquare, CheckCircle, Loader2 } from 'lucide-vue-next'
import type { Database } from '~/types/database.types'

const supabase = useSupabaseClient<Database>()

const isSubmitted = ref(false)
const isLoading = ref(false)
const branchAddresses = ref<string[]>([])
const formData = reactive({
  patientName: '',
  patientEmail: '',
  patientPhone: '',
  branchAddress: '',
  appointmentDate: '',
  appointmentTime: '',
  message: '',
})

const { toast } = useToast()

onMounted(async () => {
  try {
    const { data, error } = await supabase
      .from('branches')
      .select('address')
      .order('address')
    
    if (error) throw error
    
    if (data) {
      branchAddresses.value = data.map((b: { address: string }) => b.address)
    }
  } catch (err) {
    console.error('Error fetching branches:', err)
  }
})

const handleSubmit = async () => {
  isLoading.value = true

  try {
    const { error } = await supabase
      .from('appointments')
      .insert({
        patient_name: formData.patientName.trim(),
        patient_email: formData.patientEmail.trim(),
        patient_phone: formData.patientPhone.trim(),
        branch_name: formData.branchAddress, 
        appointment_date: formData.appointmentDate,
        appointment_time: formData.appointmentTime,
        message: formData.message.trim() || null,
      })

    if (error) throw error

    isSubmitted.value = true
    
    toast({
      title: "অ্যাপয়েন্টমেন্ট অনুরোধ",
      description: "আমরা আপনার অ্যাপয়েন্টমেন্ট অনুরোধ পেয়েছি। আমরা শীঘ্রই আপনার সাথে যোগাযোগ করব।",
      variant: "success",
    })
    
    // Reset form
    Object.assign(formData, {
        patientName: '',
        patientEmail: '',
        patientPhone: '',
        branchAddress: '',
        appointmentDate: '',
        appointmentTime: '',
        message: '',
    })
    
    setTimeout(() => {
      isSubmitted.value = false
    }, 5000)

  } catch (error: any) {
    console.error('Error submitting appointment:', error, error.details, error.hint)
    alert(`অ্যাপয়েন্টমেন্ট জমা দিতে ব্যর্থ হয়েছে: ${error.message || 'অজানা ত্রুটি'}`)
    toast({
      title: "জমা দিতে ব্যর্থ হয়েছে",
      description: error.message || "অ্যাপয়েন্টমেন্ট জমা দিতে ব্যর্থ হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।",
      variant: "destructive",
    })
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
  <section id="appointment" class="section-padding bg-primary relative overflow-hidden">
    <!-- Background Pattern -->
    <div class="absolute inset-0 opacity-5">
      <div class="absolute inset-0" :style="{
        backgroundImage: 'radial-gradient(circle at 2px 2px, white 1px, transparent 0)',
        backgroundSize: '32px 32px'
      }" />
    </div>

    <div class="section-container relative">
      <div class="grid lg:grid-cols-2 gap-12 lg:gap-16 items-center">
        <!-- Content Side -->
        <div>
          <span class="text-secondary font-semibold tracking-wide uppercase text-sm">
            অ্যাপয়েন্টমেন্ট নিন
          </span>
          <h2 class="heading-lg text-primary-foreground mt-3 mb-6">
            আজই আপনার ভিজিট শিডিউল করুন
          </h2>
          <p class="text-primary-foreground/80 text-lg mb-8 leading-relaxed">
            সুস্বাস্থ্যের দিকে প্রথম পদক্ষেপ নিন। আমাদের বিশেষজ্ঞ চিকিৎসকদের সাথে অ্যাপয়েন্টমেন্ট বুক করুন এবং ব্যক্তিগতকৃত স্বাস্থ্যসেবার অভিজ্ঞতা নিন।
          </p>

          <div class="space-y-4">
            <div class="flex items-center gap-4">
              <div class="w-12 h-12 rounded-xl bg-primary-foreground/10 flex items-center justify-center">
                <Calendar class="w-6 h-6 text-primary-foreground" />
              </div>
              <div>
                <p class="font-semibold text-primary-foreground">নমনীয় সময়সূচী</p>
                <p class="text-primary-foreground/70 text-sm">আপনার জন্য সুবিধাজনক সময় বেছে নিন</p>
              </div>
            </div>
            <div class="flex items-center gap-4">
              <div class="w-12 h-12 rounded-xl bg-primary-foreground/10 flex items-center justify-center">
                <Clock class="w-6 h-6 text-primary-foreground" />
              </div>
              <div>
                <p class="font-semibold text-primary-foreground">দ্রুত প্রতিক্রিয়া</p>
                <p class="text-primary-foreground/70 text-sm">২৪ ঘন্টার মধ্যে নিশ্চিতকরণ</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Form Side -->
        <div class="bg-card rounded-2xl shadow-medical-lg p-8">
          <div v-if="isSubmitted" class="text-center py-12">
            <div class="w-16 h-16 rounded-full bg-secondary/20 flex items-center justify-center mx-auto mb-4">
              <CheckCircle class="w-8 h-8 text-secondary" />
            </div>
            <h3 class="heading-sm text-foreground mb-2">অ্যাপয়েন্টমেন্ট অনুরোধ করা হয়েছে!</h3>
            <p class="text-muted-foreground">নিশ্চিত করার জন্য আমরা শীঘ্রই আপনার সাথে যোগাযোগ করব।</p>
          </div>
          
          <form v-else @submit.prevent="handleSubmit" class="space-y-5">
            <div class="grid sm:grid-cols-2 gap-5">
              <div>
                <label class="block text-sm font-medium text-foreground mb-2">
                  পুরো নাম
                </label>
                <div class="relative">
                  <User class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                  <input
                    type="text"
                    v-model="formData.patientName"
                    required
                    maxlength="100"
                    placeholder="আপনার নাম"
                    class="input-field pl-11"
                  />
                </div>
              </div>
              <div>
                <label class="block text-sm font-medium text-foreground mb-2">
                  ইমেল ঠিকানা
                </label>
                <div class="relative">
                  <Mail class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                  <input
                    type="email"
                    v-model="formData.patientEmail"
                    required
                    maxlength="255"
                    placeholder="আপনার ইমেল"
                    class="input-field pl-11"
                  />
                </div>
              </div>
            </div>

            <div class="grid sm:grid-cols-2 gap-5">
              <div>
                <label class="block text-sm font-medium text-foreground mb-2">
                  ফোন নম্বর
                </label>
                <div class="relative">
                  <Phone class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                  <input
                    type="tel"
                    v-model="formData.patientPhone"
                    required
                    maxlength="20"
                    placeholder="+৮৮০ ১..."
                    class="input-field pl-11"
                  />
                </div>
              </div>
              <div>
                <label class="block text-sm font-medium text-foreground mb-2">
                  শাখার অবস্থান
                </label>
                <select 
                  v-model="formData.branchAddress"
                  required 
                  class="input-field"
                >
                  <option value="">শাখা নির্বাচন করুন</option>
                  <option v-for="addr in branchAddresses" :key="addr" :value="addr">{{ addr }}</option>
                </select>
              </div>
            </div>

            <div class="grid sm:grid-cols-2 gap-5">
              <div>
                <label class="block text-sm font-medium text-foreground mb-2">
                  পছন্দের তারিখ
                </label>
                <input
                  type="date"
                  v-model="formData.appointmentDate"
                  required
                  :min="new Date().toISOString().split('T')[0]"
                  class="input-field"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-foreground mb-2">
                  পছন্দের সময়
                </label>
                <select 
                  v-model="formData.appointmentTime"
                  required 
                  class="input-field"
                >
                  <option value="">সময় নির্বাচন করুন</option>
                  <option value="09:00 AM">সকাল ০৯:০০</option>
                  <option value="10:00 AM">সকাল ১০:০০</option>
                  <option value="11:00 AM">সকাল ১১:০০</option>
                  <option value="02:00 PM">দুপুর ০২:০০</option>
                  <option value="03:00 PM">বিকাল ০৩:০০</option>
                  <option value="04:00 PM">বিকাল ০৪:০০</option>
                </select>
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-foreground mb-2">
                অতিরিক্ত নোট
              </label>
              <div class="relative">
                <MessageSquare class="absolute left-4 top-4 w-4 h-4 text-muted-foreground" />
                <textarea
                  v-model="formData.message"
                  rows="3"
                  maxlength="1000"
                  placeholder="আপনার সমস্যা বর্ণনা করুন..."
                  class="input-field pl-11 resize-none"
                />
              </div>
            </div>

            <button 
              type="submit" 
              :disabled="isLoading"
              class="btn-primary w-full py-4 flex items-center justify-center gap-2"
            >
              <template v-if="isLoading">
                <Loader2 class="w-5 h-5 animate-spin" />
                জমা দেওয়া হচ্ছে...
              </template>
              <template v-else>
                অ্যাপয়েন্টমেন্ট অনুরোধ করুন
              </template>
            </button>
          </form>
        </div>
      </div>
    </div>
  </section>
</template>
