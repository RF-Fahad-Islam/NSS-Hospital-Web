import { createClient } from '@supabase/supabase-js'

const getEnv = (key: string, publicKey: string) => {
    // Try process.env first (Server-side / Vercel)
    if (typeof process !== 'undefined' && process.env && process.env[key]) {
        return process.env[key]
    }
    // Try import.meta.env (Client-side / Vite)
    if (import.meta && import.meta.env && import.meta.env[key]) {
        return import.meta.env[key]
    }
    return ''
}

const SUPABASE_URL = getEnv('VITE_SUPABASE_URL', 'supabaseUrl')
const SUPABASE_PUBLISHABLE_KEY = getEnv('VITE_SUPABASE_PUBLISHABLE_KEY', 'supabaseKey')

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
