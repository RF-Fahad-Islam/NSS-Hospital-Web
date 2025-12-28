import { format, subDays, eachDayOfInterval } from 'date-fns'
import { supabase } from '@/lib/supabase'

export const useAnalytics = () => {
    // const supabase = useSupabaseClient() - Replaced with shared client to fix auth/RLS issues

    const trackVisit = async (path: string) => {
        try {
            const { error } = await supabase.from('analytics').insert({
                page_path: path
            })
            if (error) {
                console.error('Analytics insert error:', error)
                return error
            }
        } catch (error) {
            // Fail silently to not impact user experience
            console.error('Analytics error:', error)
            return error
        }
    }

    const getAnalyticsStats = async () => {
        try {
            // Total visits
            const { count: total, error: totalError } = await supabase
                .from('analytics')
                .select('*', { count: 'exact', head: true })

            if (totalError) console.error('Error fetching total visits:', totalError)

            // Today's visits
            const today = new Date().toISOString().split('T')[0]
            const { count: todayCount, error: todayError } = await supabase
                .from('analytics')
                .select('*', { count: 'exact', head: true })
                .gte('created_at', today)

            if (todayError) console.error('Error fetching today visits:', todayError)

            // Weekly Graph Data (Last 7 Days)
            const endDate = new Date()
            const startDate = subDays(endDate, 6)

            // Get data for graph and top pages
            // We fetch the actual data now instead of just head/count for more detailed analytics
            const { data: analyticsData, error: dataError } = await supabase
                .from('analytics')
                .select('created_at, page_path')
                .gte('created_at', startDate.toISOString())
                .lte('created_at', endDate.toISOString())

            if (dataError) console.error('Error fetching analytics data:', dataError)

            const cleanData = analyticsData || []

            // Group by day for graph
            const days = eachDayOfInterval({ start: startDate, end: endDate })
            const weeklyVisits = days.map(day => {
                const dayStr = format(day, 'yyyy-MM-dd')
                const label = format(day, 'MMM dd')
                const count = cleanData.filter((item: any) => item.created_at.startsWith(dayStr)).length
                return { date: dayStr, count, label }
            })

            // Calculate Top Pages
            const pageCounts: Record<string, number> = {}
            cleanData.forEach((item: any) => {
                const path = item.page_path || '/'
                pageCounts[path] = (pageCounts[path] || 0) + 1
            })

            const topPages = Object.entries(pageCounts)
                .map(([path, count]) => ({ path, count }))
                .sort((a, b) => b.count - a.count)
                .slice(0, 5)

            return {
                totalVisits: total || 0,
                todayVisits: todayCount || 0,
                weeklyVisits,
                topPages
            }
        } catch (error) {
            console.error('Error fetching analytics:', error)
            return {
                totalVisits: 0,
                todayVisits: 0,
                weeklyVisits: [],
                topPages: []
            }
        }
    }

    return {
        trackVisit,
        getAnalyticsStats
    }
}
