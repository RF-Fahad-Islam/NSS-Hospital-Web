<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { 
  Bell, Calendar, LogOut, Clock, User, Phone, Mail, 
  CheckCircle, XCircle, Eye, Loader2, Stethoscope, Building2,
  Plus, Edit, Trash2, X, Save, Search, BarChart3, TrendingUp
} from 'lucide-vue-next'
import { format, subDays, startOfDay, endOfDay, eachDayOfInterval } from 'date-fns'
import { supabase } from '@/lib/supabase'
import type { Branch, Doctor, Service, BranchForm, DoctorForm, ServiceForm, GalleryItem, GalleryForm } from '@/types/admin-types'
import ImageUpload from '@/components/ImageUpload.vue'
import AnalyticsDashboard from '@/components/admin/AnalyticsDashboard.vue'

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
const activeTab = ref<'analytics' | 'appointments' | 'branches' | 'doctors' | 'services' | 'gallery'>('analytics')
const loading = ref(true)
const searchQuery = ref('')

// Appointments state
const appointments = ref<Appointment[]>([])
const selectedAppointment = ref<Appointment | null>(null)
const unreadCount = ref(0)

// Branches state
const branches = ref<Branch[]>([])
const editingBranch = ref<Branch | null>(null)
const branchFormOpen = ref(false)
const branchForm = ref<BranchForm>({
  name: '',
  address: '',
  phone: '',
  email: '',
  map_url: '',
  image: ''
})

// Doctors state
const doctors = ref<Doctor[]>([])
const editingDoctor = ref<Doctor | null>(null)
const doctorFormOpen = ref(false)
const doctorForm = ref<DoctorForm>({
  name: '',
  specialty: '',
  experience: '',
  rating: 5,
  image: '',
  branch_id: '',
  education: '',
  bio: '',

  available_days: ['Everyday'],
  is_doctor: true
})
const doctorFilter = ref<'all' | 'doctor' | 'staff'>('all')

// Services state
const services = ref<Service[]>([])
const editingService = ref<Service | null>(null)
const serviceFormOpen = ref(false)
const serviceForm = ref<ServiceForm>({
  title: '',
  description: '',
  full_description: '',
  color: '',
  bg_color: '',
  features: [],
  icon_name: ''
})

// Gallery state
const galleryItems = ref<GalleryItem[]>([])
const editingGallery = ref<GalleryItem | null>(null)
const galleryFormOpen = ref(false)
const galleryForm = ref<GalleryForm>({
  src: '',
  alt: '',
  category: 'Facility'
})

// Delete Modal State
const deleteModalOpen = ref(false)
const deleteTargetId = ref<string | number | null>(null)
const deleteTargetType = ref<'branch' | 'doctor' | 'service' | 'gallery' | null>(null)
const isDeleting = ref(false)

let realtimeChannel: any = null

// Computed
const filteredBranches = computed(() => {
  if (!searchQuery.value) return branches.value
  return branches.value.filter(b => 
    b.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
    b.address.toLowerCase().includes(searchQuery.value.toLowerCase())
  )
})

const filteredDoctors = computed(() => {
  let filtered = doctors.value
  
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(d => 
      d.name.toLowerCase().includes(query) ||
      d.specialty.toLowerCase().includes(query)
    )
  }

  if (doctorFilter.value !== 'all') {
    const isDoctor = doctorFilter.value === 'doctor'
    filtered = filtered.filter(d => d.is_doctor === isDoctor)
  }
  
  return filtered
})

const filteredServices = computed(() => {
  if (!searchQuery.value) return services.value
  return services.value.filter(s => 
    s.title.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
    s.description.toLowerCase().includes(searchQuery.value.toLowerCase())
  )
})



// Analytics state
const totalVisits = ref(0)
const todayVisits = ref(0)
const weeklyVisits = ref<{ date: string; count: number; label: string }[]>([])
const topPages = ref<{ path: string; count: number }[]>([])

// Fetch functions
const { getAnalyticsStats } = useAnalytics()

const fetchAnalytics = async () => {
  const stats = await getAnalyticsStats()
  totalVisits.value = stats.totalVisits
  todayVisits.value = stats.todayVisits
  weeklyVisits.value = stats.weeklyVisits
  topPages.value = stats.topPages
}

const fetchAppointments = async () => {
  try {
    const { data, error } = await supabase
      .from('appointments')
      .select('*')
      .order('created_at', { ascending: false })

    if (error) throw error
    appointments.value = (data as Appointment[]) || []
    unreadCount.value = appointments.value.filter(apt => !apt.is_read).length
  } catch (error) {
    console.error('Error fetching appointments:', error)
  }
}

const fetchBranches = async () => {
  try {
    const { data, error } = await supabase
      .from('branches')
      .select('*')
      .order('created_at', { ascending: false })

    if (error) throw error
    branches.value = data || []
  } catch (error) {
    console.error('Error fetching branches:', error)
  }
}

const fetchDoctors = async () => {
  try {
    const { data, error } = await supabase
      .from('doctors')
      .select('*')
      .order('created_at', { ascending: false })

    if (error) throw error
    doctors.value = data || []
  } catch (error) {
    console.error('Error fetching doctors:', error)
  }
}

const fetchServices = async () => {
  try {
    const { data, error } = await supabase
      .from('services')
      .select('*')
      .order('created_at', { ascending: false })

    if (error) throw error
    services.value = data || []
  } catch (error) {
    console.error('Error fetching services:', error)
  }
}

const fetchGallery = async () => {
  try {
    const { data, error } = await supabase
      .from('gallery_items')
      .select('*')
      .order('created_at', { ascending: false })

    if (error) throw error
    galleryItems.value = data || []
  } catch (error) {
    console.error('Error fetching gallery:', error)
  }
}

// Branch CRUD
const openBranchForm = (branch?: Branch) => {
  if (branch) {
    editingBranch.value = branch
    branchForm.value = { ...branch }
  } else {
    editingBranch.value = null
    resetBranchForm()
  }
  branchFormOpen.value = true
}

const resetBranchForm = () => {
  branchForm.value = {
    name: '',
    address: '',
    phone: '',
    email: '',
    map_url: '',
    image: ''
  }
}

const saveBranch = async () => {
  try {
    const payload = {
      name: branchForm.value.name,
      address: branchForm.value.address,
      phone: branchForm.value.phone,
      email: branchForm.value.email,
      map_url: branchForm.value.map_url,
      image: branchForm.value.image
    }

    if (editingBranch.value) {
      const { error } = await supabase
        .from('branches')
        .update(payload)
        .eq('id', editingBranch.value.id)
      
      if (error) throw error
    } else {
      const id = branchForm.value.name.toLowerCase().replace(/\s+/g, '-')
      const { error } = await supabase
        .from('branches')
        .insert({ ...payload, id })
      
      if (error) throw error
    }
    branchFormOpen.value = false
    await fetchBranches()
  } catch (error: any) {
    console.error('Error saving branch:', error)
    alert(`Failed to save branch: ${error.message || 'Unknown error'}`)
  }
}

const deleteBranch = (id: string) => {
  deleteTargetId.value = id
  deleteTargetType.value = 'branch'
  deleteModalOpen.value = true
}

const executeDeleteBranch = async (id: string) => {
  try {
    const { error } = await supabase
      .from('branches')
      .delete()
      .eq('id', id)
    
    if (error) throw error
    await fetchBranches()
  } catch (error: any) {
    console.error('Error deleting branch:', error)
    alert(`Failed to delete branch: ${error.message || 'Unknown error'}`)
  }
}

// Doctor CRUD
const openDoctorForm = (doctor?: Doctor) => {
  if (doctor) {
    editingDoctor.value = doctor
    // Deep copy to ensure no reference issues and clean form state
    const formData = JSON.parse(JSON.stringify(doctor))
    
    // Ensure arrays are initialized even if null in DB
    formData.available_days = Array.isArray(formData.available_days) ? formData.available_days : []
    
    // Ensure is_doctor is boolean (default to true for legacy records)
    if (formData.is_doctor === undefined || formData.is_doctor === null) {
        formData.is_doctor = true
    }

    doctorForm.value = formData
  } else {
    editingDoctor.value = null
    resetDoctorForm()
  }
  doctorFormOpen.value = true
}

const resetDoctorForm = () => {
  doctorForm.value = {
    name: '',
    specialty: '',
    experience: '',
    rating: 5,
    image: '',
    branch_id: '',
    education: '',
    bio: '',
    available_days: [],
    is_doctor: true
  }
}

const saveDoctor = async () => {
  // Validation
  if (!doctorForm.value.name) {
    alert('Please enter a doctor name')
    return
  }
  if (!doctorForm.value.branch_id) {
    alert('Please select a branch')
    return
  }

  try {
    const payload = {
      name: doctorForm.value.name,
      specialty: doctorForm.value.specialty,
      experience: doctorForm.value.experience,
      rating: doctorForm.value.rating,
      image: doctorForm.value.image,
      branch_id: doctorForm.value.branch_id,
      education: doctorForm.value.education,
      bio: doctorForm.value.bio,
      available_days: doctorForm.value.available_days,
      is_doctor: doctorForm.value.is_doctor
    }

    console.log('Saving doctor payload:', payload)

    if (editingDoctor.value) {
     const { error } = await supabase
        .from('doctors')
        .update(payload)
        .eq('id', editingDoctor.value.id)
      
      if (error) throw error
    } else {
      const id = 'dr-' + doctorForm.value.name.toLowerCase().replace(/[^a-z]+/g, '-')
      const { error } = await supabase
        .from('doctors')
        .insert({ ...payload, id })
      
      if (error) throw error
    }
    doctorFormOpen.value = false
    await fetchDoctors()
  } catch (error: any) {
    console.error('Error saving doctor:', error)
    if (error.message?.includes('is_doctor')) {
        alert('Critical Error: Database schema missing "is_doctor" column.\nPlease run the "add_is_doctor_column.sql" script in Supabase SQL Editor.')
    } else {
        alert(`Failed to save doctor: ${error.message || 'Unknown error'}`)
    }
  }
}

const deleteDoctor = (id: string) => {
  deleteTargetId.value = id
  deleteTargetType.value = 'doctor'
  deleteModalOpen.value = true
}

const executeDeleteDoctor = async (id: string) => {
  try {
    const { error } = await supabase
      .from('doctors')
      .delete()
      .eq('id', id)
    
    if (error) throw error
    await fetchDoctors()
  } catch (error: any) {
    console.error('Error deleting doctor:', error)
    alert(`Failed to delete doctor: ${error.message || 'Unknown error'}`)
  }
}

// Service CRUD
const openServiceForm = (service?: Service) => {
  if (service) {
    editingService.value = service
    serviceForm.value = JSON.parse(JSON.stringify(service))
  } else {
    editingService.value = null
    resetServiceForm()
  }
  serviceFormOpen.value = true
}

const resetServiceForm = () => {
  serviceForm.value = {
    title: '',
    description: '',
    full_description: '',
    color: '',
    bg_color: '',
    features: [],
    icon_name: ''
  }
}

const saveService = async () => {
  try {
    const payload = {
      title: serviceForm.value.title,
      description: serviceForm.value.description,
      full_description: serviceForm.value.full_description,
      color: serviceForm.value.color,
      bg_color: serviceForm.value.bg_color,
      features: serviceForm.value.features,
      icon_name: serviceForm.value.icon_name
    }

    if (editingService.value) {
      const { error } = await supabase
        .from('services')
        .update(payload)
        .eq('id', editingService.value.id)
      
      if (error) throw error
    } else {
      const id = serviceForm.value.title.toLowerCase().replace(/\s+/g, '-')
      const { error } = await supabase
        .from('services')
        .insert({ ...payload, id })
      
      if (error) throw error
    }
    serviceFormOpen.value = false
    await fetchServices()
  } catch (error: any) {
    console.error('Error saving service:', error)
    alert(`Failed to save service: ${error.message || 'Unknown error'}`)
  }
}

const deleteService = (id: string) => {
  deleteTargetId.value = id
  deleteTargetType.value = 'service'
  deleteModalOpen.value = true
}

const executeDeleteService = async (id: string) => {
  try {
    const { error } = await supabase
      .from('services')
      .delete()
      .eq('id', id)
    
    if (error) throw error
    await fetchServices()
  } catch (error: any) {
    console.error('Error deleting service:', error)
    alert(`Failed to delete service: ${error.message || 'Unknown error'}`)
  }
}

// Gallery CRUD
const openGalleryForm = (item?: GalleryItem) => {
  if (item) {
    editingGallery.value = item
    galleryForm.value = JSON.parse(JSON.stringify(item))
  } else {
    editingGallery.value = null
    resetGalleryForm()
  }
  galleryFormOpen.value = true
}

const resetGalleryForm = () => {
  galleryForm.value = {
    src: '',
    alt: '',
    category: 'Facility'
  }
}

const saveGallery = async () => {
  try {
    const payload = {
      src: galleryForm.value.src,
      alt: galleryForm.value.alt,
      category: galleryForm.value.category
    }

    if (editingGallery.value) {
      const { error } = await supabase
        .from('gallery_items')
        .update(payload)
        .eq('id', editingGallery.value.id)
      
      if (error) throw error
    } else {
      const { error } = await supabase
        .from('gallery_items')
        .insert(payload)
      
      if (error) throw error
    }
    galleryFormOpen.value = false
    await fetchGallery()
  } catch (error: any) {
    console.error('Error saving gallery item:', error)
    alert(`Failed to save gallery item: ${error.message || 'Unknown error'}`)
  }
}

const deleteGallery = (id: number) => {
  deleteTargetId.value = id
  deleteTargetType.value = 'gallery'
  deleteModalOpen.value = true
}

const executeDeleteGallery = async (id: number) => {
  try {
    const { error } = await supabase
      .from('gallery_items')
      .delete()
      .eq('id', id)
    
    if (error) throw error
    await fetchGallery()
  } catch (error: any) {
    console.error('Error deleting gallery item:', error)
    alert(`Failed to delete gallery item: ${error.message || 'Unknown error'}`)
  }
}

// Appointment functions
const markAsRead = async (appointment: Appointment) => {
  if (!appointment.is_read) {
    await supabase
      .from('appointments')
      .update({ is_read: true })
      .eq('id', appointment.id)
    
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

    appointments.value = appointments.value.map(a => a.id === id ? { ...a, status } : a)
    if (selectedAppointment.value && selectedAppointment.value.id === id) {
        selectedAppointment.value.status = status
    }
    
    selectedAppointment.value = null
  } catch (error) {
    console.error("Failed to update status", error)
    alert('Failed to update appointment status')
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

const handleDeleteConfirm = async () => {
  if (!deleteTargetId.value || !deleteTargetType.value) return

  isDeleting.value = true
  try {
    if (deleteTargetType.value === 'branch') {
      await executeDeleteBranch(deleteTargetId.value as string)
    } else if (deleteTargetType.value === 'doctor') {
      await executeDeleteDoctor(deleteTargetId.value as string)
    } else if (deleteTargetType.value === 'service') {
      await executeDeleteService(deleteTargetId.value as string)
    } else if (deleteTargetType.value === 'gallery') {
      await executeDeleteGallery(deleteTargetId.value as number)
    }
  } finally {
    isDeleting.value = false
    deleteModalOpen.value = false
    deleteTargetId.value = null
    deleteTargetType.value = null
  }
}

onMounted(async () => {
  let { data: { session } } = await supabase.auth.getSession()
  
  // DEV MOCK: Bypass auth in development if no session
  if (!session && (import.meta.dev || import.meta.env.MODE === 'development')) {
      console.warn('Dev mode: Using mock admin session')
      session = {
          user: { id: 'mock-admin-id', email: 'mock@test.com' },
          access_token: 'mock-token',
          refresh_token: 'mock-refresh',
          token_type: 'bearer',
          expires_in: 3600,
          expires_at: Date.now() + 3600
      } as any
  }
  
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
    if (import.meta.dev || import.meta.env.MODE === 'development') {
      console.warn('Dev mode: Bypassing admin dashboard role check')
    } else {
      await supabase.auth.signOut()
      router.push('/admin')
      return
    }
  }

  await Promise.all([
    fetchAnalytics(),
    fetchAppointments(),
    fetchBranches(),
    fetchDoctors(),
    fetchServices(),
    fetchGallery()
  ])
  loading.value = false

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
      (payload: any) => {
        if (payload.eventType === 'INSERT') {
          appointments.value = [payload.new as Appointment, ...appointments.value]
          unreadCount.value++
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

const isDev = import.meta.dev || import.meta.env.MODE === 'development'
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
              <h1 class="font-bold text-foreground flex items-center gap-2">
                NSS Admin
                <span v-if="isDev" class="px-2 py-0.5 rounded-full bg-yellow-100 text-yellow-800 text-[10px] font-bold uppercase tracking-wider">
                  Dev Mode
                </span>
              </h1>
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
      <!-- Tabs Navigation -->
      <div class="mb-8 border-b border-border">
        <nav class="flex gap-8">
          <button
            @click="activeTab = 'analytics'; searchQuery = ''"
            class="pb-4 px-2 font-medium transition-colors relative"
            :class="activeTab === 'analytics' ? 'text-primary' : 'text-muted-foreground hover:text-foreground'"
          >
            Analytics
            <span v-if="activeTab === 'analytics'" class="absolute bottom-0 left-0 right-0 h-0.5 bg-primary"></span>
          </button>
          <!-- Appointments Tab Disabled -->

          <button
            @click="activeTab = 'branches'; searchQuery = ''"
            class="pb-4 px-2 font-medium transition-colors relative"
            :class="activeTab === 'branches' ? 'text-primary' : 'text-muted-foreground hover:text-foreground'"
          >
            Branches
            <span v-if="activeTab === 'branches'" class="absolute bottom-0 left-0 right-0 h-0.5 bg-primary"></span>
          </button>
          <button
            @click="activeTab = 'doctors'; searchQuery = ''"
            class="pb-4 px-2 font-medium transition-colors relative"
            :class="activeTab === 'doctors' ? 'text-primary' : 'text-muted-foreground hover:text-foreground'"
          >
            Doctors
            <span v-if="activeTab === 'doctors'" class="absolute bottom-0 left-0 right-0 h-0.5 bg-primary"></span>
          </button>
          <button
            @click="activeTab = 'services'; searchQuery = ''"
            class="pb-4 px-2 font-medium transition-colors relative"
            :class="activeTab === 'services' ? 'text-primary' : 'text-muted-foreground hover:text-foreground'"
          >
            Services
            <span v-if="activeTab === 'services'" class="absolute bottom-0 left-0 right-0 h-0.5 bg-primary"></span>
          </button>
          <button
            @click="activeTab = 'gallery'; searchQuery = ''"
            class="pb-4 px-2 font-medium transition-colors relative"
            :class="activeTab === 'gallery' ? 'text-primary' : 'text-muted-foreground hover:text-foreground'"
          >
            Gallery
            <span v-if="activeTab === 'gallery'" class="absolute bottom-0 left-0 right-0 h-0.5 bg-primary"></span>
          </button>
        </nav>
      </div>

      <!-- Analytics Tab -->
      <div v-if="activeTab === 'analytics'">
        <AnalyticsDashboard
          :total-visits="totalVisits"
          :today-visits="todayVisits"
          :weekly-visits="weeklyVisits"
          :top-pages="topPages"
        />
      </div>




      <!-- Branches Tab -->
      <div v-if="activeTab === 'branches'">
        <div class="mb-6 flex items-center justify-between gap-4">
          <div class="relative flex-1 max-w-md">
            <Search class="w-5 h-5 absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search branches..."
              class="w-full pl-10 pr-4 py-2 border border-border rounded-lg bg-card text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
            />
          </div>
          <button
            @click="openBranchForm()"
            class="btn-primary flex items-center gap-2"
          >
            <Plus class="w-4 h-4" />
            Add Branch
          </button>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div
            v-for="branch in filteredBranches"
            :key="branch.id"
            class="bg-card rounded-xl border border-border overflow-hidden hover:shadow-lg transition-shadow"
          >
            <img :src="branch.image" :alt="branch.name" class="w-full h-48 object-cover" />
            <div class="p-6">
              <h3 class="font-semibold text-lg text-foreground mb-2">{{ branch.name }}</h3>
              <p class="text-sm text-muted-foreground mb-4">{{ branch.address }}</p>
              <div class="space-y-2 mb-4">
                <div class="flex items-center gap-2 text-sm">
                  <Phone class="w-4 h-4 text-muted-foreground" />
                  <span class="text-foreground">{{ branch.phone }}</span>
                </div>
                <div class="flex items-center gap-2 text-sm">
                  <Mail class="w-4 h-4 text-muted-foreground" />
                  <span class="text-foreground">{{ branch.email }}</span>
                </div>
              </div>
              <div class="flex gap-2">
                <button
                  @click="openBranchForm(branch)"
                  class="flex-1 px-4 py-2 border border-border rounded-lg hover:bg-muted transition-colors flex items-center justify-center gap-2"
                >
                  <Edit class="w-4 h-4" />
                  Edit
                </button>
                <button
                  @click="deleteBranch(branch.id)"
                  class="px-4 py-2 border border-destructive text-destructive rounded-lg hover:bg-destructive hover:text-destructive-foreground transition-colors"
                >
                  <Trash2 class="w-4 h-4" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Doctors Tab -->
      <div v-if="activeTab === 'doctors'">
        <div class="flex justify-between items-center mb-6">
          <div class="flex items-center gap-4">
            <h2 class="text-xl font-semibold text-foreground">Doctors & Staff</h2>
            <div class="flex bg-muted rounded-lg p-1">
              <button
                @click="doctorFilter = 'all'"
                :class="[
                  'px-3 py-1.5 text-sm font-medium rounded-md transition-all',
                  doctorFilter === 'all' 
                    ? 'bg-background text-foreground shadow-sm' 
                    : 'text-muted-foreground hover:text-foreground'
                ]"
              >
                All
              </button>
              <button
                @click="doctorFilter = 'doctor'"
                :class="[
                  'px-3 py-1.5 text-sm font-medium rounded-md transition-all',
                  doctorFilter === 'doctor' 
                    ? 'bg-background text-foreground shadow-sm' 
                    : 'text-muted-foreground hover:text-foreground'
                ]"
              >
                Doctors
              </button>
              <button
                @click="doctorFilter = 'staff'"
                :class="[
                  'px-3 py-1.5 text-sm font-medium rounded-md transition-all',
                  doctorFilter === 'staff' 
                    ? 'bg-background text-foreground shadow-sm' 
                    : 'text-muted-foreground hover:text-foreground'
                ]"
              >
                Staff
              </button>
            </div>
          </div>
          <button
            @click="openDoctorForm()"
            class="btn-primary flex items-center gap-2"
          >
            <Plus class="w-4 h-4" />
            Add Doctor/Staff
          </button>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div
            v-for="doctor in filteredDoctors"
            :key="doctor.id"
            class="bg-card rounded-xl border border-border overflow-hidden hover:shadow-lg transition-shadow"
          >
            <img :src="doctor.image" :alt="doctor.name" class="w-full h-48 object-cover" />
            <div class="p-6">
              <h3 class="font-semibold text-lg text-foreground mb-1">{{ doctor.name }}</h3>
              <p class="text-sm text-primary mb-2">{{ doctor.specialty }}</p>
              <p class="text-sm text-muted-foreground mb-4">{{ doctor.experience }} • Rating: {{ doctor.rating }}</p>
              <div class="flex gap-2">
                <button
                  @click="openDoctorForm(doctor)"
                  class="flex-1 px-4 py-2 border border-border rounded-lg hover:bg-muted transition-colors flex items-center justify-center gap-2"
                >
                  <Edit class="w-4 h-4" />
                  Edit
                </button>
                <button
                  @click="deleteDoctor(doctor.id)"
                  class="px-4 py-2 border border-destructive text-destructive rounded-lg hover:bg-destructive hover:text-destructive-foreground transition-colors"
                >
                  <Trash2 class="w-4 h-4" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Services Tab -->
      <div v-if="activeTab === 'services'">
        <div class="mb-6 flex items-center justify-between gap-4">
          <div class="relative flex-1 max-w-md">
            <Search class="w-5 h-5 absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search services..."
              class="w-full pl-10 pr-4 py-2 border border-border rounded-lg bg-card text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
            />
          </div>
          <button
            @click="openServiceForm()"
            class="btn-primary flex items-center gap-2"
          >
            <Plus class="w-4 h-4" />
            Add Service
          </button>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div
            v-for="service in filteredServices"
            :key="service.id"
            class="bg-card rounded-xl border border-border p-6 hover:shadow-lg transition-shadow"
          >
            <div class="w-12 h-12 rounded-xl mb-4 flex items-center justify-center" :class="service.bg_color">
              <div :class="service.color" class="text-2xl">{{ service.icon_name }}</div>
            </div>
            <h3 class="font-semibold text-lg text-foreground mb-2">{{ service.title }}</h3>
            <p class="text-sm text-muted-foreground mb-4 line-clamp-2">{{ service.description }}</p>
            <p class="text-xs text-muted-foreground mb-4">{{ service.features.length }} features</p>
            <div class="flex gap-2">
              <button
                @click="openServiceForm(service)"
                class="flex-1 px-4 py-2 border border-border rounded-lg hover:bg-muted transition-colors flex items-center justify-center gap-2"
              >
                <Edit class="w-4 h-4" />
                Edit
              </button>
              <button
                @click="deleteService(service.id)"
                class="px-4 py-2 border border-destructive text-destructive rounded-lg hover:bg-destructive hover:text-destructive-foreground transition-colors"
              >
                <Trash2 class="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Gallery Tab -->
      <div v-if="activeTab === 'gallery'">
        <div class="mb-6 flex items-center justify-between gap-4">
          <div class="relative flex-1 max-w-md">
            <Search class="w-5 h-5 absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search gallery..."
              class="w-full pl-10 pr-4 py-2 border border-border rounded-lg bg-card text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
            />
          </div>
          <button
            @click="openGalleryForm()"
            class="btn-primary flex items-center gap-2"
          >
            <Plus class="w-4 h-4" />
            Add Image
          </button>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div
            v-for="item in galleryItems"
            :key="item.id"
            class="bg-card rounded-xl border border-border overflow-hidden hover:shadow-lg transition-shadow"
          >
            <img :src="item.src" :alt="item.alt" class="w-full h-48 object-cover" />
            <div class="p-4">
              <p class="text-sm font-medium text-foreground mb-1">{{ item.alt }}</p>
              <p class="text-xs text-muted-foreground mb-4">{{ item.category }}</p>
              <div class="flex gap-2">
                <button
                  @click="openGalleryForm(item)"
                  class="flex-1 px-4 py-2 border border-border rounded-lg hover:bg-muted transition-colors flex items-center justify-center gap-2"
                >
                  <Edit class="w-4 h-4" />
                  Edit
                </button>
                <button
                  @click="deleteGallery(item.id)"
                  class="px-4 py-2 border border-destructive text-destructive rounded-lg hover:bg-destructive hover:text-destructive-foreground transition-colors"
                >
                  <Trash2 class="w-4 h-4" />
                </button>
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

    <!-- Branch Form Modal -->
    <div v-if="branchFormOpen" class="fixed inset-0 bg-background/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div class="bg-card rounded-2xl shadow-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div class="p-6 border-b border-border">
          <div class="flex items-center justify-between">
            <h2 class="text-lg font-semibold text-foreground">{{ editingBranch ? 'Edit' : 'Add' }} Branch</h2>
            <button
              @click="branchFormOpen = false"
              class="text-muted-foreground hover:text-foreground"
            >
              <X class="w-5 h-5" />
            </button>
          </div>
        </div>
        
        <div class="p-6 space-y-4">
          <div>
            <label class="block text-sm font-medium text-foreground mb-2">Branch Name</label>
            <input
              v-model="branchForm.name"
              type="text"
              class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder="Downtown Medical Center"
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium text-foreground mb-2">Address</label>
            <textarea
              v-model="branchForm.address"
              rows="2"
              class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder="123 Main Street, Downtown, City 10001"
            ></textarea>
          </div>
          
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-foreground mb-2">Phone</label>
              <input
                v-model="branchForm.phone"
                type="tel"
                class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
                placeholder="+1 (555) 123-4567"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-foreground mb-2">Email</label>
              <input
                v-model="branchForm.email"
                type="email"
                class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
                placeholder="contact@branch.com"
              />
            </div>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-foreground mb-2">Map URL</label>
            <input
              v-model="branchForm.map_url"
              type="url"
              class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder="https://maps.google.com/..."
            />
          </div>
          
          
          <ImageUpload
            v-model="branchForm.image"
            label="Branch Image"
            folder="branches"
          />
          
          <div class="flex gap-3 pt-4">
            <button
              @click="saveBranch"
              class="flex-1 btn-primary py-3 flex items-center justify-center gap-2"
            >
              <Save class="w-4 h-4" />
              Save Branch
            </button>
            <button
              @click="branchFormOpen = false"
              class="px-6 py-3 border border-border rounded-xl hover:bg-muted transition-colors"
            >
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Doctor Form Modal -->
    <div v-if="doctorFormOpen" class="fixed inset-0 bg-background/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div class="bg-card rounded-2xl shadow-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div class="p-6 border-b border-border">
          <div class="flex items-center justify-between">
            <h2 class="text-lg font-semibold text-foreground">{{ editingDoctor ? 'Edit' : 'Add' }} Doctor</h2>
            <button
              @click="doctorFormOpen = false"
              class="text-muted-foreground hover:text-foreground"
            >
              <X class="w-5 h-5" />
            </button>
          </div>
        </div>
        
        <div class="p-6 space-y-4">
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-foreground mb-2">Full Name</label>
              <input
                v-model="doctorForm.name"
                type="text"
                class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
                placeholder="Dr. John Doe"
              />
            </div>
            
            <div class="flex items-center pt-6">
               <label class="flex items-center gap-2 cursor-pointer">
                 <input 
                   type="checkbox" 
                   v-model="doctorForm.is_doctor"
                   class="w-4 h-4 rounded border-border text-primary focus:ring-primary"
                 >
                 <span class="text-sm font-medium text-foreground">Is Doctor?</span>
               </label>
               <span class="text-xs text-muted-foreground ml-2">(Uncheck for Staff)</span>
            </div>
          </div>
          
          <div class="grid grid-cols-3 gap-4">
            <div>
              <label class="block text-sm font-medium text-foreground mb-2">Experience</label>
              <input
                v-model="doctorForm.experience"
                type="text"
                class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
                placeholder="10+ Years"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-foreground mb-2">Rating</label>
              <input
                v-model.number="doctorForm.rating"
                type="number"
                step="0.1"
                min="0"
                max="5"
                class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-foreground mb-2">Branch</label>
              <select
                v-model="doctorForm.branch_id"
                class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
              >
                <option value="">Select Branch</option>
                <option v-for="branch in branches" :key="branch.id" :value="branch.id">
                  {{ branch.name }} - {{ branch.address }}
                </option>
              </select>
            </div>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-foreground mb-2">Education</label>
            <input
              v-model="doctorForm.education"
              type="text"
              class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder="MD from Harvard Medical School"
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium text-foreground mb-2">Bio</label>
            <textarea
              v-model="doctorForm.bio"
              rows="3"
              class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder="Brief biography..."
            ></textarea>
          </div>
          
          
          <ImageUpload
            v-model="doctorForm.image"
            label="Doctor Photo"
            folder="doctors"
          />
          

          <div>
            <label class="block text-sm font-medium text-foreground mb-2">Available Days (comma-separated)</label>
            <input
              :value="doctorForm.available_days.join(', ')"
              @input="doctorForm.available_days = ($event.target as HTMLInputElement).value.split(',').map(d => d.trim())"
              type="text"
              class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder="Monday, Wednesday, Friday"
            />
          </div>
          
          <div class="flex gap-3 pt-4">
            <button
              @click="saveDoctor"
              class="flex-1 btn-primary py-3 flex items-center justify-center gap-2"
            >
              <Save class="w-4 h-4" />
              Save Doctor
            </button>
            <button
              @click="doctorFormOpen = false"
              class="px-6 py-3 border border-border rounded-xl hover:bg-muted transition-colors"
            >
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Service Form Modal -->
    <div v-if="serviceFormOpen" class="fixed inset-0 bg-background/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div class="bg-card rounded-2xl shadow-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div class="p-6 border-b border-border">
          <div class="flex items-center justify-between">
            <h2 class="text-lg font-semibold text-foreground">{{ editingService ? 'Edit' : 'Add' }} Service</h2>
            <button
              @click="serviceFormOpen = false"
              class="text-muted-foreground hover:text-foreground"
            >
              <X class="w-5 h-5" />
            </button>
          </div>
        </div>
        
        <div class="p-6 space-y-4">
          <div>
            <label class="block text-sm font-medium text-foreground mb-2">Service Title</label>
            <input
              v-model="serviceForm.title"
              type="text"
              class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder="Cardiology Services"
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium text-foreground mb-2">Short Description</label>
            <textarea
              v-model="serviceForm.description"
              rows="2"
              class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder="Brief description of the service..."
            ></textarea>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-foreground mb-2">Full Description</label>
            <textarea
              v-model="serviceForm.full_description"
              rows="3"
              class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder="Detailed description of the service..."
            ></textarea>
          </div>
          
          <div class="grid grid-cols-3 gap-4">
            <div>
              <label class="block text-sm font-medium text-foreground mb-2">Icon Name</label>
              <input
                v-model="serviceForm.icon_name"
                type="text"
                class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
                placeholder="Heart"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-foreground mb-2">Color Class</label>
              <input
                v-model="serviceForm.color"
                type="text"
                class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
                placeholder="text-red-500"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-foreground mb-2">BG Color Class</label>
              <input
                v-model="serviceForm.bg_color"
                type="text"
                class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
                placeholder="bg-red-50"
              />
            </div>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-foreground mb-2">Features (one per line)</label>
            <textarea
              :value="serviceForm.features.join('\n')"
              @input="serviceForm.features = ($event.target as HTMLInputElement).value.split('\n').filter(f => f.trim())"
              rows="4"
              class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder="Feature 1&#10;Feature 2&#10;Feature 3"
            ></textarea>
          </div>
          
          <div class="flex gap-3 pt-4">
            <button
              @click="saveService"
              class="flex-1 btn-primary py-3 flex items-center justify-center gap-2"
            >
              <Save class="w-4 h-4" />
              Save Service
            </button>
            <button
              @click="serviceFormOpen = false"
              class="px-6 py-3 border border-border rounded-xl hover:bg-muted transition-colors"
            >
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Gallery Form Modal -->
    <div v-if="galleryFormOpen" class="fixed inset-0 bg-background/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div class="bg-card rounded-2xl shadow-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div class="p-6 border-b border-border">
          <div class="flex items-center justify-between">
            <h2 class="text-lg font-semibold text-foreground">{{ editingGallery ? 'Edit' : 'Add' }} Gallery Image</h2>
            <button
              @click="galleryFormOpen = false"
              class="text-muted-foreground hover:text-foreground"
            >
              <X class="w-5 h-5" />
            </button>
          </div>
        </div>
        
        <div class="p-6 space-y-4">
          <ImageUpload
            v-model="galleryForm.src"
            label="Gallery Image"
            folder="gallery"
          />
          
          <div>
            <label class="block text-sm font-medium text-foreground mb-2">Image Description</label>
            <input
              v-model="galleryForm.alt"
              type="text"
              class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder="Hospital lobby view"
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium text-foreground mb-2">Category</label>
            <select
              v-model="galleryForm.category"
              class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"
            >
              <option value="Facility">Facility</option>
              <option value="Interior">Interior</option>
              <option value="Medical">Medical</option>
              <option value="Team">Team</option>
            </select>
          </div>
          
          <div class="flex gap-3 pt-4">
            <button
              @click="saveGallery"
              class="flex-1 btn-primary py-3 flex items-center justify-center gap-2"
            >
              <Save class="w-4 h-4" />
              Save Image
            </button>
            <button
              @click="galleryFormOpen = false"
              class="px-6 py-3 border border-border rounded-xl hover:bg-muted transition-colors"
            >
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>
    <!-- Delete Confirmation Modal -->
    <div v-if="deleteModalOpen" class="fixed inset-0 bg-background/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div class="bg-card rounded-2xl shadow-xl max-w-sm w-full animate-in fade-in zoom-in-95 duration-200">
        <div class="p-6 text-center">
          <div class="w-12 h-12 rounded-full bg-destructive/10 flex items-center justify-center mx-auto mb-4">
            <Trash2 class="w-6 h-6 text-destructive" />
          </div>
          <h2 class="text-lg font-semibold text-foreground mb-2">Are you sure?</h2>
          <p class="text-sm text-muted-foreground mb-6">
            This action cannot be undone. This will permanently delete the selected {{ deleteTargetType }}.
          </p>
          <div class="flex gap-3">
            <button
              @click="deleteModalOpen = false"
              class="flex-1 px-4 py-2 border border-border rounded-lg hover:bg-muted transition-colors text-sm font-medium"
            >
              Cancel
            </button>
            <button
              @click="handleDeleteConfirm"
              :disabled="isDeleting"
              class="flex-1 btn-primary bg-destructive hover:bg-destructive/90 text-destructive-foreground px-4 py-2 rounded-lg text-sm font-medium flex items-center justify-center gap-2"
            >
              <Loader2 v-if="isDeleting" class="w-4 h-4 animate-spin" />
              {{ isDeleting ? 'Deleting...' : 'Delete' }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
