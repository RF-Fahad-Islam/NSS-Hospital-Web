<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { Shield, Mail, Lock, AlertCircle, Loader2, User, CheckCircle } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'

definePageMeta({
  layout: false
})

// However, I want to use 'none' layout for admin login to match original.
// Nuxt layouts are in layouts/. I created default.vue. I can use layout: false.

const router = useRouter()
const isLogin = ref(true)
const email = ref('')
const password = ref('')
const fullName = ref('')
const loading = ref(false)
const error = ref('')
const signupSuccess = ref(false)

onMounted(async () => {
  const { data: { session } } = await supabase.auth.getSession()
  if (session) {
    const { data: roleData } = await supabase
      .from('user_roles')
      .select('role')
      .eq('user_id', session.user.id)
      .eq('role', 'admin')
      .maybeSingle()
    
    if (roleData) {
      router.push('/admin/dashboard')
    }
  }
})

const handleLogin = async () => {
  loading.value = true
  error.value = ''

  try {
    const { data, error: authError } = await supabase.auth.signInWithPassword({
      email: email.value.trim(),
      password: password.value,
    })

    if (authError) {
      if (authError.message.includes('Invalid login credentials')) {
        error.value = 'Invalid email or password'
      } else {
        error.value = authError.message
      }
      return
    }

    if (data.user) {
      const { data: roleData, error: roleError } = await supabase
        .from('user_roles')
        .select('role')
        .eq('user_id', data.user.id)
        .eq('role', 'admin')
        .maybeSingle()

      if (roleError || !roleData) {
        await supabase.auth.signOut()
        error.value = 'Access denied. Your admin access is pending approval.'
        return
      }

      // Toast or alert
      // alert("Welcome back! Successfully logged in as admin.")
      router.push('/admin/dashboard')
    }
  } catch (err) {
    error.value = 'An unexpected error occurred. Please try again.'
  } finally {
    loading.value = false
  }
}

const handleSignup = async () => {
  loading.value = true
  error.value = ''

  if (password.value.length < 6) {
    error.value = 'Password must be at least 6 characters'
    loading.value = false
    return
  }

  try {
    const { data, error: signupError } = await supabase.auth.signUp({
      email: email.value.trim(),
      password: password.value,
      options: {
        emailRedirectTo: `${window.location.origin}/admin`,
        data: {
          full_name: fullName.value.trim(),
        }
      }
    })

    if (signupError) {
      if (signupError.message.includes('already registered')) {
        error.value = 'This email is already registered. Please sign in instead.'
      } else {
        error.value = signupError.message
      }
      return
    }

    if (data.user) {
      signupSuccess.value = true
      email.value = ''
      password.value = ''
      fullName.value = ''
    }
  } catch (err) {
    error.value = 'An unexpected error occurred. Please try again.'
  } finally {
    loading.value = false
  }
}

const resetForm = () => {
  email.value = ''
  password.value = ''
  fullName.value = ''
  error.value = ''
  signupSuccess.value = false
}

const toggleMode = () => {
  resetForm()
  isLogin.value = !isLogin.value
}
</script>

<template>
    <div v-if="signupSuccess" class="min-h-screen bg-gradient-to-br from-primary/5 via-background to-secondary/5 flex items-center justify-center p-4">
      <div class="w-full max-w-md">
        <div class="bg-card rounded-2xl shadow-medical-lg p-8 text-center">
          <div class="w-16 h-16 rounded-full bg-secondary/20 flex items-center justify-center mx-auto mb-4">
            <CheckCircle class="w-8 h-8 text-secondary" />
          </div>
          <h1 class="heading-md text-foreground mb-2">Registration Successful!</h1>
          <p class="text-muted-foreground mb-6">
            Your account has been created. Please wait for an administrator to approve your access. 
            You will be notified once your admin privileges are granted.
          </p>
          <button
            @click="signupSuccess = false; isLogin = true"
            class="btn-primary w-full py-3"
          >
            Back to Login
          </button>
          <p class="text-center text-sm text-muted-foreground mt-4">
            <NuxtLink to="/" class="text-primary hover:underline">
              ← Back to Website
            </NuxtLink>
          </p>
        </div>
      </div>
    </div>

    <div v-else class="min-h-screen bg-gradient-to-br from-primary/5 via-background to-secondary/5 flex items-center justify-center p-4">
      <div class="w-full max-w-md">
        <div class="bg-card rounded-2xl shadow-medical-lg p-8">
          <div class="text-center mb-8">
            <div class="w-16 h-16 rounded-2xl bg-primary/10 flex items-center justify-center mx-auto mb-4">
              <Shield class="w-8 h-8 text-primary" />
            </div>
            <h1 class="heading-md text-foreground">
              {{ isLogin ? 'Admin Login' : 'Admin Registration' }}
            </h1>
            <p class="text-muted-foreground mt-2">
              {{ isLogin ? 'Sign in to access the dashboard' : 'Create an account to request admin access' }}
            </p>
          </div>

          <!-- Toggle Tabs -->
          <div class="flex mb-6 bg-muted rounded-lg p-1">
            <button
              type="button"
              @click="toggleMode"
              class="flex-1 py-2.5 text-sm font-medium rounded-md transition-all"
              :class="isLogin ? 'bg-card text-foreground shadow-sm' : 'text-muted-foreground hover:text-foreground'"
            >
              Sign In
            </button>
            <button
              type="button"
              @click="toggleMode"
              class="flex-1 py-2.5 text-sm font-medium rounded-md transition-all"
              :class="!isLogin ? 'bg-card text-foreground shadow-sm' : 'text-muted-foreground hover:text-foreground'"
            >
              Register
            </button>
          </div>

          <div v-if="error" class="mb-6 p-4 rounded-xl bg-destructive/10 border border-destructive/20 flex items-start gap-3">
            <AlertCircle class="w-5 h-5 text-destructive shrink-0 mt-0.5" />
            <p class="text-sm text-destructive">{{ error }}</p>
          </div>

          <form @submit.prevent="isLogin ? handleLogin() : handleSignup()" class="space-y-5">
            <div v-if="!isLogin">
              <label class="block text-sm font-medium text-foreground mb-2">
                Full Name
              </label>
              <div class="relative">
                <User class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                <input
                  type="text"
                  required
                  v-model="fullName"
                  placeholder="John Doe"
                  maxlength="100"
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
                  required
                  v-model="email"
                  placeholder="admin@hospital.com"
                  maxlength="255"
                  class="input-field pl-11"
                />
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-foreground mb-2">
                Password
              </label>
              <div class="relative">
                <Lock class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                <input
                  type="password"
                  required
                  v-model="password"
                  placeholder="••••••••"
                  minlength="6"
                  class="input-field pl-11"
                />
              </div>
              <p v-if="!isLogin" class="text-xs text-muted-foreground mt-1.5">
                Must be at least 6 characters
              </p>
            </div>

            <button
              type="submit"
              :disabled="loading"
              class="btn-primary w-full py-4 flex items-center justify-center gap-2"
            >
              <template v-if="loading">
                <Loader2 class="w-5 h-5 animate-spin" />
                {{ isLogin ? 'Signing in...' : 'Creating account...' }}
              </template>
              <template v-else>
                {{ isLogin ? 'Sign In' : 'Create Account' }}
              </template>
            </button>
          </form>

          <p v-if="!isLogin" class="text-xs text-muted-foreground text-center mt-4">
            After registration, an existing admin must approve your access before you can log in.
          </p>

          <p class="text-center text-sm text-muted-foreground mt-6">
            <NuxtLink to="/" class="text-primary hover:underline">
              ← Back to Website
            </NuxtLink>
          </p>
        </div>
      </div>
    </div>
</template>
