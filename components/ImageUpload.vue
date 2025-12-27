<script setup lang="ts">
import { ref } from 'vue'
import { Upload, X, Loader2, Image as ImageIcon } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'

interface Props {
  modelValue: string
  label?: string
  folder?: string
  accept?: string
}

interface Emits {
  (e: 'update:modelValue', value: string): void
}

const props = withDefaults(defineProps<Props>(), {
  label: 'Image',
  folder: 'general',
  accept: 'image/*'
})

const emit = defineEmits<Emits>()

const uploading = ref(false)
const uploadError = ref('')
const fileInput = ref<HTMLInputElement | null>(null)

const handleFileSelect = async (event: Event) => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  
  if (!file) return
  
  // Validate file type
  if (!file.type.startsWith('image/')) {
    uploadError.value = 'Please select an image file'
    return
  }
  
  // Validate file size (max 5MB)
  if (file.size > 5 * 1024 * 1024) {
    uploadError.value = 'Image size must be less than 5MB'
    return
  }
  
  await uploadImage(file)
}

const uploadImage = async (file: File) => {
  uploading.value = true
  uploadError.value = ''
  
  try {
    // Generate unique filename
    const fileExt = file.name.split('.').pop()
    const fileName = `${props.folder}/${Date.now()}-${Math.random().toString(36).substring(7)}.${fileExt}`
    
    // Upload to Supabase Storage
    const { data, error } = await supabase.storage
      .from('images')
      .upload(fileName, file, {
        cacheControl: '3600',
        upsert: false
      })
    
    if (error) throw error
    
    // Get public URL
    const { data: { publicUrl } } = supabase.storage
      .from('images')
      .getPublicUrl(fileName)
    
    emit('update:modelValue', publicUrl)
  } catch (error: any) {
    console.error('Upload error:', error)
    uploadError.value = error.message || 'Failed to upload image'
  } finally {
    uploading.value = false
  }
}

const clearImage = () => {
  emit('update:modelValue', '')
  if (fileInput.value) {
    fileInput.value.value = ''
  }
}

const triggerFileInput = () => {
  fileInput.value?.click()
}
</script>

<template>
  <div class="space-y-2">
    <label class="block text-sm font-medium text-foreground">{{ label }}</label>
    
    <div class="space-y-3">
      <!-- Image Preview -->
      <div
        v-if="modelValue"
        class="relative w-full h-48 rounded-lg overflow-hidden border border-border bg-muted"
      >
        <img
          :src="modelValue"
          :alt="label"
          class="w-full h-full object-cover"
        />
        <button
          @click="clearImage"
          type="button"
          class="absolute top-2 right-2 p-2 bg-destructive text-destructive-foreground rounded-lg hover:bg-destructive/90 transition-colors"
        >
          <X class="w-4 h-4" />
        </button>
      </div>
      
      <!-- Upload Button -->
      <div class="flex gap-2">
        <button
          @click="triggerFileInput"
          type="button"
          :disabled="uploading"
          class="flex-1 flex items-center justify-center gap-2 px-4 py-3 border-2 border-dashed border-border rounded-lg hover:border-primary hover:bg-primary/5 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <Loader2 v-if="uploading" class="w-5 h-5 animate-spin text-primary" />
          <Upload v-else class="w-5 h-5 text-muted-foreground" />
          <span class="text-sm font-medium text-foreground">
            {{ uploading ? 'Uploading...' : modelValue ? 'Change Image' : 'Upload Image' }}
          </span>
        </button>
        
        <input
          ref="fileInput"
          type="file"
          :accept="accept"
          @change="handleFileSelect"
          class="hidden"
        />
      </div>
      
      <!-- Manual URL Input -->
      <div>
        <label class="block text-xs text-muted-foreground mb-1">Or enter image URL</label>
        <input
          :value="modelValue"
          @input="emit('update:modelValue', ($event.target as HTMLInputElement).value)"
          type="url"
          placeholder="https://images.unsplash.com/..."
          class="w-full px-4 py-2 border border-border rounded-lg bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-primary"
        />
      </div>
      
      <!-- Error Message -->
      <p v-if="uploadError" class="text-sm text-destructive">
        {{ uploadError }}
      </p>
      
      <!-- Helper Text -->
      <p class="text-xs text-muted-foreground">
        Supported: JPG, PNG, WebP. Max size: 5MB
      </p>
    </div>
  </div>
</template>
