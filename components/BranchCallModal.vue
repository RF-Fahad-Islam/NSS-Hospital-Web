<script setup lang="ts">
import { useBranchModal } from '~/composables/useBranchModal'
import { useSupabaseClient, useAsyncData } from '#imports'

interface Branch {
  id: string
  name: string
  address: string
  phone: string
}

const { isOpen, closeModal } = useBranchModal()
const supabase = useSupabaseClient()

// Fetch branches
const { data: branches } = useAsyncData<Branch[]>('branches-list-modal', async () => {
  const { data } = await supabase
    .from('branches')
    .select('*')
    .order('sequence', { ascending: true, nullsFirst: false })
  return (data as Branch[]) || []
})

const dialBranch = (phone: string) => {
  if (phone) {
    window.location.href = `tel:${phone}`
  }
  closeModal()
}
</script>

<template>
  <ClientOnly>
    <Teleport to="body">
      <Transition name="modal">
        <div 
          v-if="isOpen" 
          class="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm"
          @click.self="closeModal"
        >
          <div class="bg-card rounded-2xl shadow-2xl max-w-4xl w-full max-h-[80vh] overflow-hidden border border-border">
            <!-- Modal Header -->
            <div class="sticky top-0 bg-gradient-to-br from-primary/10 via-background to-secondary/10 border-b border-border p-6 flex justify-between items-center">
              <div>
                <h3 class="text-2xl font-bold text-foreground mb-1">শাখা নির্বাচন করুন</h3>
                <p class="text-sm text-muted-foreground">কল করতে একটি শাখায় ক্লিক করুন</p>
              </div>
              <button 
                @click="closeModal"
                class="text-muted-foreground hover:text-foreground transition-colors p-2 rounded-lg hover:bg-muted"
              >
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>

            <!-- Modal Body -->
            <div class="p-6 overflow-y-auto max-h-[calc(80vh-120px)]">
              <div v-if="!branches || branches.length === 0" class="text-center py-12">
                <p class="text-muted-foreground">লোড হচ্ছে...</p>
              </div>
              <div v-else class="grid sm:grid-cols-2 gap-4">
                <button
                  v-for="branch in branches"
                  :key="branch.id"
                  @click="dialBranch(branch.phone)"
                  class="group relative bg-gradient-to-br from-card to-card/50 border border-border rounded-xl p-5 text-left transition-all duration-300 hover:shadow-lg hover:scale-[1.02] hover:border-primary/50 overflow-hidden"
                >
                  <!-- Animated background gradient on hover -->
                  <div class="absolute inset-0 bg-gradient-to-br from-primary/5 to-secondary/5 opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                  
                  <!-- Content -->
                  <div class="relative z-10">
                    <div class="flex items-start justify-between mb-3">
                      <div class="flex-1">
                        <h4 class="text-lg font-semibold text-foreground mb-1 group-hover:text-primary transition-colors">
                          {{ branch.name }}
                        </h4>
                      </div>
                      <div class="bg-primary/10 text-primary p-2 rounded-lg group-hover:bg-primary group-hover:text-primary-foreground transition-all">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                        </svg>
                      </div>
                    </div>
                    
                    <div class="space-y-2 mb-3">
                      <div class="flex items-start gap-2 text-sm text-muted-foreground">
                        <svg class="w-4 h-4 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                        </svg>
                        <span class="flex-1">{{ branch.address }}</span>
                      </div>
                      
                      <div class="flex items-center gap-2 text-sm font-medium text-primary">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                        </svg>
                        <span>{{ branch.phone }}</span>
                      </div>
                    </div>

                    <div class="flex items-center gap-2 text-xs text-muted-foreground group-hover:text-primary transition-colors">
                      <span>কল করতে ক্লিক করুন</span>
                      <svg class="w-3 h-3 transform group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                      </svg>
                    </div>
                  </div>
                </button>
              </div>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>
  </ClientOnly>
</template>

<style scoped>
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s ease;
}

.modal-enter-active .bg-card,
.modal-leave-active .bg-card {
  transition: transform 0.3s ease, opacity 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-from .bg-card,
.modal-leave-to .bg-card {
  transform: scale(0.95);
  opacity: 0;
}
</style>
