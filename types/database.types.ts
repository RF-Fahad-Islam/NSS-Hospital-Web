export type Json =
    | string
    | number
    | boolean
    | null
    | { [key: string]: Json | undefined }
    | Json[]

export interface Database {
    public: {
        Tables: {
            analytics: {
                Row: {
                    id: string
                    page_path: string
                    created_at: string
                }
                Insert: {
                    id?: string
                    page_path: string
                    created_at?: string
                }
                Update: {
                    id?: string
                    page_path?: string
                    created_at?: string
                }
                Relationships: []
            }
            appointments: {
                Row: {
                    id: string
                    created_at: string
                    patient_name: string
                    patient_email: string
                    patient_phone: string
                    branch_name: string | null
                    doctor_name: string | null
                    service: string | null
                    appointment_date: string
                    appointment_time: string
                    message: string | null
                    status: string | null
                    is_read: boolean | null
                }
                Insert: {
                    id?: string
                    created_at?: string
                    patient_name: string
                    patient_email: string
                    patient_phone: string
                    branch_name?: string | null
                    doctor_name?: string | null
                    service?: string | null
                    appointment_date: string
                    appointment_time: string
                    message?: string | null
                    status?: string | null
                    is_read?: boolean | null
                }
                Update: {
                    id?: string
                    created_at?: string
                    patient_name?: string
                    patient_email?: string
                    patient_phone?: string
                    branch_name?: string | null
                    doctor_name?: string | null
                    service?: string | null
                    appointment_date?: string
                    appointment_time?: string
                    message?: string | null
                    status?: string | null
                    is_read?: boolean | null
                }
                Relationships: []
            }
            branches: {
                Row: {
                    id: string
                    created_at: string
                    address: string
                    name: string
                    phone: string
                    email: string
                    map_url: string
                    image: string
                }
                Insert: {
                    id?: string
                    created_at?: string
                    address: string
                    name: string
                    phone: string
                    email: string
                    map_url: string
                    image: string
                }
                Update: {
                    id?: string
                    created_at?: string
                    address?: string
                    name?: string
                    phone?: string
                    email?: string
                    map_url?: string
                    image?: string
                }
                Relationships: []
            }
            doctors: {
                Row: {
                    id: string
                    created_at: string
                    name: string
                    specialty: string
                    experience: string
                    rating: number
                    image: string
                    branch_id: string
                    education: string
                    bio: string
                    languages: string[]
                    available_days: string[]
                    is_doctor: boolean
                }
                Insert: {
                    id?: string
                    created_at?: string
                    name: string
                    specialty: string
                    experience: string
                    rating: number
                    image: string
                    branch_id: string
                    education: string
                    bio: string
                    languages: string[]
                    available_days: string[]
                }
                Update: {
                    id?: string
                    created_at?: string
                    name?: string
                    specialty?: string
                    experience?: string
                    rating?: number
                    image?: string
                    branch_id?: string
                    education?: string
                    bio?: string
                    languages?: string[]
                    available_days?: string[]
                }
                Relationships: []
            }
            services: {
                Row: {
                    id: string
                    created_at: string
                    title: string
                    description: string
                    full_description: string
                    color: string
                    bg_color: string
                    features: string[]
                    icon_name: string
                }
                Insert: {
                    id?: string
                    created_at?: string
                    title: string
                    description: string
                    full_description: string
                    color: string
                    bg_color: string
                    features: string[]
                    icon_name: string
                }
                Update: {
                    id?: string
                    created_at?: string
                    title?: string
                    description?: string
                    full_description?: string
                    color?: string
                    bg_color?: string
                    features?: string[]
                    icon_name?: string
                }
                Relationships: []
            }
            gallery_items: {
                Row: {
                    id: number
                    created_at: string
                    src: string
                    alt: string
                    category: string
                }
                Insert: {
                    id?: number
                    created_at?: string
                    src: string
                    alt: string
                    category: string
                }
                Update: {
                    id?: number
                    created_at?: string
                    src?: string
                    alt?: string
                    category?: string
                }
                Relationships: []
            }
            user_roles: {
                Row: {
                    id: string
                    created_at: string
                    user_id: string
                    role: string
                }
                Insert: {
                    id?: string
                    created_at?: string
                    user_id: string
                    role: string
                }
                Update: {
                    id?: string
                    created_at?: string
                    user_id?: string
                    role?: string
                }
                Relationships: []
            }
        }
        Views: {
            [_ in never]: never
        }
        Functions: {
            [_ in never]: never
        }
        Enums: {
            [_ in never]: never
        }
        CompositeTypes: {
            [_ in never]: never
        }
    }
}
