import { ref } from 'vue'

export interface Toast {
    id: string
    title?: string
    description?: string
    variant?: 'default' | 'destructive' | 'success'
    duration?: number
}

const toasts = ref<Toast[]>([])

export function useToast() {
    const toast = ({ title, description, variant = 'default', duration = 5000 }: Omit<Toast, 'id'>) => {
        const id = Math.random().toString(36).substring(2, 9)
        const newToast: Toast = {
            id,
            title,
            description,
            variant,
            duration
        }

        toasts.value.push(newToast)

        if (duration > 0) {
            setTimeout(() => {
                dismiss(id)
            }, duration)
        }

        return id
    }

    const dismiss = (id: string) => {
        toasts.value = toasts.value.filter((t) => t.id !== id)
    }

    return {
        toasts,
        toast,
        dismiss
    }
}
