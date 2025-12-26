<script setup lang="ts">
import { ref, reactive } from 'vue'
import { Calendar, Clock, User, Mail, Phone, MessageSquare, CheckCircle, Loader2 } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'

const isSubmitted = ref(false)
const isLoading = ref(false)
const formData = reactive({
  patientName: '',
  patientEmail: '',
  patientPhone: '',
  service: '',
  appointmentDate: '',
  appointmentTime: '',
  message: '',
})

const departments = [
  'Cardiology',
  'Pediatrics',
  'Neurology',
  'Orthopedics',
  'Ophthalmology',
  'General Medicine',
]

const handleSubmit = async () => {
  isLoading.value = true

  try {
    const { error } = await supabase
      .from('appointments')
      .insert({
        patient_name: formData.patientName.trim(),
        patient_email: formData.patientEmail.trim(),
        patient_phone: formData.patientPhone.trim(),
        service: formData.service,
        appointment_date: formData.appointmentDate,
        appointment_time: formData.appointmentTime,
        message: formData.message.trim() || null,
      })

    if (error) throw error

    isSubmitted.value = true
    
    // Reset form
    Object.assign(formData, {
        patientName: '',
        patientEmail: '',
        patientPhone: '',
        service: '',
        appointmentDate: '',
        appointmentTime: '',
        message: '',
    })
    
    setTimeout(() => {
      isSubmitted.value = false
    }, 5000)

  } catch (error) {
    console.error('Error submitting appointment:', error)
    alert('Failed to submit appointment. Please try again.')
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
            Book Appointment
          </span>
          <h2 class="heading-lg text-primary-foreground mt-3 mb-6">
            Schedule Your Visit Today
          </h2>
          <p class="text-primary-foreground/80 text-lg mb-8 leading-relaxed">
            Take the first step towards better health. Book an appointment with our 
            expert physicians and experience personalized healthcare.
          </p>

          <div class="space-y-4">
            <div class="flex items-center gap-4">
              <div class="w-12 h-12 rounded-xl bg-primary-foreground/10 flex items-center justify-center">
                <Calendar class="w-6 h-6 text-primary-foreground" />
              </div>
              <div>
                <p class="font-semibold text-primary-foreground">Flexible Scheduling</p>
                <p class="text-primary-foreground/70 text-sm">Choose a time that works for you</p>
              </div>
            </div>
            <div class="flex items-center gap-4">
              <div class="w-12 h-12 rounded-xl bg-primary-foreground/10 flex items-center justify-center">
                <Clock class="w-6 h-6 text-primary-foreground" />
              </div>
              <div>
                <p class="font-semibold text-primary-foreground">Quick Response</p>
                <p class="text-primary-foreground/70 text-sm">Confirmation within 24 hours</p>
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
            <h3 class="heading-sm text-foreground mb-2">Appointment Requested!</h3>
            <p class="text-muted-foreground">We'll contact you shortly to confirm.</p>
          </div>
          
          <form v-else @submit.prevent="handleSubmit" class="space-y-5">
            <div class="grid sm:grid-cols-2 gap-5">
              <div>
                <label class="block text-sm font-medium text-foreground mb-2">
                  Full Name
                </label>
                <div class="relative">
                  <User class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                  <input
                    type="text"
                    v-model="formData.patientName"
                    required
                    maxlength="100"
                    placeholder="John Doe"
                    class="input-field pl-11"
                  />
                </div>
              </div>
              <div>
                <label class="block text-sm font-medium text-foreground mb-2">
                  Email Address
                </label>
                <div class="relative">
                  <Mail class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                  <input
                    type="email"
                    v-model="formData.patientEmail"
                    required
                    maxlength="255"
                    placeholder="john@example.com"
                    class="input-field pl-11"
                  />
                </div>
              </div>
            </div>

            <div class="grid sm:grid-cols-2 gap-5">
              <div>
                <label class="block text-sm font-medium text-foreground mb-2">
                  Phone Number
                </label>
                <div class="relative">
                  <Phone class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                  <input
                    type="tel"
                    v-model="formData.patientPhone"
                    required
                    maxlength="20"
                    placeholder="+1 234 567 890"
                    class="input-field pl-11"
                  />
                </div>
              </div>
              <div>
                <label class="block text-sm font-medium text-foreground mb-2">
                  Department
                </label>
                <select 
                  v-model="formData.service"
                  required 
                  class="input-field"
                >
                  <option value="">Select Department</option>
                  <option v-for="dept in departments" :key="dept" :value="dept">{{ dept }}</option>
                </select>
              </div>
            </div>

            <div class="grid sm:grid-cols-2 gap-5">
              <div>
                <label class="block text-sm font-medium text-foreground mb-2">
                  Preferred Date
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
                  Preferred Time
                </label>
                <select 
                  v-model="formData.appointmentTime"
                  required 
                  class="input-field"
                >
                  <option value="">Select Time</option>
                  <option value="09:00 AM">09:00 AM</option>
                  <option value="10:00 AM">10:00 AM</option>
                  <option value="11:00 AM">11:00 AM</option>
                  <option value="02:00 PM">02:00 PM</option>
                  <option value="03:00 PM">03:00 PM</option>
                  <option value="04:00 PM">04:00 PM</option>
                </select>
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-foreground mb-2">
                Additional Notes
              </label>
              <div class="relative">
                <MessageSquare class="absolute left-4 top-4 w-4 h-4 text-muted-foreground" />
                <textarea
                  v-model="formData.message"
                  rows="3"
                  maxlength="1000"
                  placeholder="Describe your concerns..."
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
                Submitting...
              </template>
              <template v-else>
                Request Appointment
              </template>
            </button>
          </form>
        </div>
      </div>
    </div>
  </section>
</template>
