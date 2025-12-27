export interface BranchForm {
    id?: string
    name: string
    address: string
    phone: string
    email: string
    map_url: string
    image: string
    manager_name?: string
}

export interface DoctorForm {
    id?: string
    name: string
    specialty: string
    experience: string
    rating: number
    image: string
    branch_id: string
    education: string
    bio: string
    available_days: string[]
    is_doctor: boolean
}

export interface ServiceForm {
    id?: string
    title: string
    description: string
    full_description: string
    color: string
    bg_color: string
    features: string[]
    icon_name: string
}

export interface GalleryForm {
    id?: number
    src: string
    alt: string
    category: string
}

export interface Branch extends BranchForm {
    id: string
    created_at: string
}

export interface Doctor extends DoctorForm {
    id: string
    created_at: string
}

export interface Service extends ServiceForm {
    id: string
    created_at: string
}

export interface GalleryItem extends GalleryForm {
    id: number
    created_at: string
}
