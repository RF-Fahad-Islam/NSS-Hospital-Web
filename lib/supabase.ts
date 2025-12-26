import { createClient } from '@supabase/supabase-js'

const SUPABASE_URL = import.meta.env.VITE_SUPABASE_URL || ''
const SUPABASE_PUBLISHABLE_KEY = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY || ''

// Mock client to prevent crash if keys are missing
const mockClient = {
    auth: {
        getSession: async () => ({ data: { session: null } }),
        signInWithPassword: async () => ({ error: { message: 'Supabase not configured' } }),
        signUp: async () => ({ error: { message: 'Supabase not configured' } }),
        signOut: async () => ({ error: null }),
    },
    from: () => ({
        select: () => ({
            eq: () => ({ maybeSingle: async () => ({ data: null }), order: async () => ({ data: [] }) }),
            order: async () => ({ data: [] }),
            insert: async () => ({ error: { message: 'Supabase not configured' } }),
            update: async () => ({ error: { message: 'Supabase not configured' } }),
        }),
    }),
    channel: () => ({
        on: () => ({ subscribe: () => { } }),
    }),
    removeChannel: () => { },
}

export const supabase = (SUPABASE_URL && SUPABASE_PUBLISHABLE_KEY)
    ? createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY)
    : (mockClient as any)

if (!SUPABASE_URL || !SUPABASE_PUBLISHABLE_KEY) {
    console.warn('Supabase keys missing. App running in mock mode.')
}
