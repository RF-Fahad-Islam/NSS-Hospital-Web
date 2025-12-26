<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { 
  Bell, Calendar, LogOut, Clock, User, Phone, Mail, 
  CheckCircle, XCircle, Eye, Loader2, Stethoscope, Building2 
} from 'lucide-vue-next'
import { format } from 'date-fns'
import { supabase } from '@/lib/supabase'

definePageMeta({
  layout: false
})

interface Appointment {
  id: string
  patient_name: string
  patient_email: string
  patient_phone: string
  doctor_name: string | null
  branch_name: string | null
  service: string | null
  appointment_date: string
  appointment_time: string
  message: string | null
  status: string
  is_read: boolean
  created_at: string
}

const router = useRouter()
const appointments = ref<Appointment[]>([])
const loading = ref(true)
const selectedAppointment = ref<Appointment | null>(null)
const unreadCount = ref(0)
let realtimeChannel: any = null

const fetchAppointments = async () => {
  try {
    const { data, error } = await supabase
      .from('appointments')
      .select('*')
      .order('created_at', { ascending: false })

    if (error) throw error

    appointments.value = data || []
    unreadCount.value = (data || []).filter(apt => !apt.is_read).length
  } catch (error) {
    console.error('Error fetching appointments:', error)
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  const { data: { session } } = await supabase.auth.getSession()
  
  if (!session) {
    router.push('/admin')
    return
  }

  const { data: roleData } = await supabase
    .from('user_roles')
    .select('role')
    .eq('user_id', session.user.id)
    .eq('role', 'admin')
    .maybeSingle()

  if (!roleData) {
    await supabase.auth.signOut()
    router.push('/admin')
    return
  }

  fetchAppointments()

  // Realtime subscription
  realtimeChannel = supabase
    .channel('appointments-changes')
    .on(
      'postgres_changes',
      {
        event: '*',
        schema: 'public',
        table: 'appointments'
      },
      (payload) => {
        if (payload.eventType === 'INSERT') {
          appointments.value = [payload.new as Appointment, ...appointments.value]
          unreadCount.value++
          // alert(`New Appointment! ${(payload.new as Appointment).patient_name} requested an appointment.`)
        } else if (payload.eventType === 'UPDATE') {
          appointments.value = appointments.value.map(apt => apt.id === payload.new.id ? payload.new as Appointment : apt)
        } else if (payload.eventType === 'DELETE') {
          appointments.value = appointments.value.filter(apt => apt.id !== payload.old.id)
        }
      }
    )
    .subscribe()
})

onUnmounted(() => {
  if (realtimeChannel) {
    supabase.removeChannel(realtimeChannel)
  }
})

const handleLogout = async () => {
  await supabase.auth.signOut()
  router.push('/admin')
}

const markAsRead = async (appointment: Appointment) => {
  if (!appointment.is_read) {
    await supabase
      .from('appointments')
      .update({ is_read: true })
      .eq('id', appointment.id)
    
    // Update local state implicitly via realtime or manual update
    // But since realtime might be slow, optimistic update:
    appointment.is_read = true
    unreadCount.value = Math.max(0, unreadCount.value - 1)
  }
  selectedAppointment.value = appointment
}

const updateStatus = async (id: string, status: string) => {
  try {
    const { error } = await supabase
      .from('appointments')
      .update({ status })
      .eq('id', id)

    if (error) throw error

    // Optimistic update
    appointments.value = appointments.value.map(a => a.id === id ? { ...a, status } : a)
    if (selectedAppointment.value && selectedAppointment.value.id === id) {
        selectedAppointment.value.status = status
    }
    
    // alert(`Status Updated: Appointment marked as ${status}.`)
    selectedAppointment.value = null
  } catch (error) {
    console.error("Failed to update status")
  }
}

const getStatusBadge = (status: string) => {
  const styles: Record<string, string> = {
    pending: 'bg-amber-100 text-amber-800',
    confirmed: 'bg-green-100 text-green-800',
    cancelled: 'bg-red-100 text-red-800',
    completed: 'bg-blue-100 text-blue-800',
  }
  return styles[status] || styles.pending
}
</script>

<template>
  <div class="min-h-screen bg-muted/30">
    <!-- Header -->
    <header class="bg-card border-b border-border sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
          <div class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-white flex items-center justify-center p-1 border border-border">
              <img src="@/assets/logo.png" alt="NSS" class="w-full h-full object-contain" />
            </div>
            <div>
              <h1 class="font-bold text-foreground">NSS Admin</h1>
              <p class="text-xs text-muted-foreground">Dashboard</p>
            </div>
          </div>
          
          <div class="flex items-center gap-4">
            <div class="relative">
              <Bell class="w-6 h-6 text-muted-foreground" />
              <span v-if="unreadCount > 0" class="absolute -top-1 -right-1 w-5 h-5 bg-destructive text-destructive-foreground text-xs rounded-full flex items-center justify-center font-medium">
                {{ unreadCount }}
              </span>
            </div>
            <button
              @click="handleLogout"
              class="flex items-center gap-2 px-4 py-2 text-sm text-muted-foreground hover:text-foreground transition-colors"
            >
              <LogOut class="w-4 h-4" />
              Logout
            </button>
          </div>
        </div>
      </div>
    </header>

    <div v-if="loading" class="min-h-screen flex items-center justify-center">
      <Loader2 class="w-8 h-8 animate-spin text-primary" />
    </div>

    <main v-else class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- Stats Cards -->
      <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
        <div class="bg-card rounded-xl p-6 border border-border">
          <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center">
              <Calendar class="w-6 h-6 text-primary" />
            </div>
            <div>
              <p class="text-2xl font-bold text-foreground">{{ appointments.length }}</p>
              <p class="text-sm text-muted-foreground">Total Appointments</p>
            </div>
          </div>
        </div>
        
        <div class="bg-card rounded-xl p-6 border border-border">
          <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-amber-100 flex items-center justify-center">
              <Clock class="w-6 h-6 text-amber-600" />
            </div>
            <div>
              <p class="text-2xl font-bold text-foreground">
                {{ appointments.filter(a => a.status === 'pending').length }}
              </p>
              <p class="text-sm text-muted-foreground">Pending</p>
            </div>
          </div>
        </div>
        
        <div class="bg-card rounded-xl p-6 border border-border">
          <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-green-100 flex items-center justify-center">
              <CheckCircle class="w-6 h-6 text-green-600" />
            </div>
            <div>
              <p class="text-2xl font-bold text-foreground">
                {{ appointments.filter(a => a.status === 'confirmed').length }}
              </p>
              <p class="text-sm text-muted-foreground">Confirmed</p>
            </div>
          </div>
        </div>
        
        <div class="bg-card rounded-xl p-6 border border-border">
          <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-destructive/10 flex items-center justify-center">
              <Bell class="w-6 h-6 text-destructive" />
            </div>
            <div>
              <p class="text-2xl font-bold text-foreground">{{ unreadCount }}</p>
              <p class="text-sm text-muted-foreground">Unread</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Appointments List -->
      <div class="bg-card rounded-xl border border-border overflow-hidden">
        <div class="p-6 border-b border-border">
          <h2 class="text-lg font-semibold text-foreground">Recent Appointments</h2>
        </div>
        
        <div class="divide-y divide-border">
          <div v-if="appointments.length === 0" class="p-12 text-center">
            <Calendar class="w-12 h-12 text-muted-foreground mx-auto mb-4" />
            <p class="text-muted-foreground">No appointments yet</p>
          </div>
          <div v-else>
            <div
              v-for="appointment in appointments"
              :key="appointment.id"
              class="p-4 hover:bg-muted/50 transition-colors cursor-pointer"
              :class="{ 'bg-primary/5': !appointment.is_read }"
              @click="markAsRead(appointment)"
            >
              <div class="flex items-start justify-between gap-4">
                <div class="flex items-start gap-4">
                  <div class="w-10 h-10 rounded-full flex items-center justify-center" :class="!appointment.is_read ? 'bg-primary' : 'bg-muted'">
                    <User class="w-5 h-5" :class="!appointment.is_read ? 'text-primary-foreground' : 'text-muted-foreground'" />
                  </div>
                  <div>
                    <div class="flex items-center gap-2">
                      <h3 class="font-medium text-foreground">{{ appointment.patient_name }}</h3>
                      <span v-if="!appointment.is_read" class="w-2 h-2 rounded-full bg-primary" />
                    </div>
                    <p class="text-sm text-muted-foreground">{{ appointment.patient_email }}</p>
                    <div class="flex items-center gap-4 mt-2 text-sm text-muted-foreground">
                      <span class="flex items-center gap-1">
                        <Calendar class="w-3 h-3" />
                        {{ format(new Date(appointment.appointment_date), 'MMM dd, yyyy') }}
                      </span>
                      <span class="flex items-center gap-1">
                        <Clock class="w-3 h-3" />
                        {{ appointment.appointment_time }}
                      </span>
                      <span v-if="appointment.service" class="flex items-center gap-1">
                        <Stethoscope class="w-3 h-3" />
                        {{ appointment.service }}
                      </span>
                    </div>
                  </div>
                </div>
                <div class="flex items-center gap-3">
                  <span class="px-3 py-1 rounded-full text-xs font-medium" :class="getStatusBadge(appointment.status)">
                    {{ appointment.status }}
                  </span>
                  <Eye class="w-4 h-4 text-muted-foreground" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>

    <!-- Appointment Detail Modal -->
    <div v-if="selectedAppointment" class="fixed inset-0 bg-background/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div class="bg-card rounded-2xl shadow-xl max-w-lg w-full max-h-[90vh] overflow-y-auto">
        <div class="p-6 border-b border-border">
          <div class="flex items-center justify-between">
            <h2 class="text-lg font-semibold text-foreground">Appointment Details</h2>
            <button
              @click="selectedAppointment = null"
              class="text-muted-foreground hover:text-foreground"
            >
              <XCircle class="w-5 h-5" />
            </button>
          </div>
        </div>
        
        <div class="p-6 space-y-4">
          <div class="flex items-center gap-4">
            <div class="w-14 h-14 rounded-full bg-primary/10 flex items-center justify-center">
              <User class="w-7 h-7 text-primary" />
            </div>
            <div>
              <h3 class="font-semibold text-foreground text-lg">{{ selectedAppointment.patient_name }}</h3>
              <span class="inline-block px-3 py-1 rounded-full text-xs font-medium" :class="getStatusBadge(selectedAppointment.status)">
                {{ selectedAppointment.status }}
              </span>
            </div>
          </div>
          
          <div class="grid gap-3">
            <div class="flex items-center gap-3 p-3 bg-muted/50 rounded-lg">
              <Mail class="w-4 h-4 text-muted-foreground" />
              <span class="text-sm text-foreground">{{ selectedAppointment.patient_email }}</span>
            </div>
            <div class="flex items-center gap-3 p-3 bg-muted/50 rounded-lg">
              <Phone class="w-4 h-4 text-muted-foreground" />
              <span class="text-sm text-foreground">{{ selectedAppointment.patient_phone }}</span>
            </div>
            <div class="flex items-center gap-3 p-3 bg-muted/50 rounded-lg">
              <Calendar class="w-4 h-4 text-muted-foreground" />
              <span class="text-sm text-foreground">
                {{ format(new Date(selectedAppointment.appointment_date), 'MMMM dd, yyyy') }} at {{ selectedAppointment.appointment_time }}
              </span>
            </div>
            <div v-if="selectedAppointment.service" class="flex items-center gap-3 p-3 bg-muted/50 rounded-lg">
              <Stethoscope class="w-4 h-4 text-muted-foreground" />
              <span class="text-sm text-foreground">{{ selectedAppointment.service }}</span>
            </div>
            <div v-if="selectedAppointment.branch_name" class="flex items-center gap-3 p-3 bg-muted/50 rounded-lg">
              <Building2 class="w-4 h-4 text-muted-foreground" />
              <span class="text-sm text-foreground">{{ selectedAppointment.branch_name }}</span>
            </div>
          </div>
          
          <div v-if="selectedAppointment.message" class="p-4 bg-muted/50 rounded-lg">
            <p class="text-sm font-medium text-foreground mb-1">Additional Notes:</p>
            <p class="text-sm text-muted-foreground">{{ selectedAppointment.message }}</p>
          </div>
          
          <div class="flex gap-3 pt-4">
            <button
              @click="updateStatus(selectedAppointment!.id, 'confirmed')"
              class="flex-1 btn-primary py-3 flex items-center justify-center gap-2"
            >
              <CheckCircle class="w-4 h-4" />
              Confirm
            </button>
            <button
              @click="updateStatus(selectedAppointment!.id, 'cancelled')"
              class="flex-1 py-3 border border-destructive text-destructive rounded-xl hover:bg-destructive hover:text-destructive-foreground transition-colors flex items-center justify-center gap-2"
            >
              <XCircle class="w-4 h-4" />
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
