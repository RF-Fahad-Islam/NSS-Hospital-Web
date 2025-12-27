import { format, subDays, eachDayOfInterval } from 'date-fns'

export const useAnalytics = () => {
    const supabase = useSupabaseClient()

    const trackVisit = async (path: string) => {
        try {
            await supabase.from('analytics').insert({
                page_path: path
            })
        } catch (error) {
            // Fail silently to not impact user experience
            console.error('Analytics error:', error)
        }
    }

    const getAnalyticsStats = async () => {
        try {
            // Total visits
            const { count: total } = await supabase
                .from('analytics')
                .select('*', { count: 'exact', head: true })

            // Today's visits
            const today = new Date().toISOString().split('T')[0]
            const { count: todayCount } = await supabase
                .from('analytics')
                .select('*', { count: 'exact', head: true })
                .gte('created_at', today)

            // Weekly Graph Data (Last 7 Days)
            const endDate = new Date()
            const startDate = subDays(endDate, 6)

            // Get data for graph and top pages
            // We fetch the actual data now instead of just head/count for more detailed analytics
            const { data: analyticsData } = await supabase
                .from('analytics')
                .select('created_at, page_path')
                .gte('created_at', startDate.toISOString())
                .lte('created_at', endDate.toISOString())

            const cleanData = analyticsData || []

            // Group by day for graph
            const days = eachDayOfInterval({ start: startDate, end: endDate })
            const weeklyVisits = days.map(day => {
                const dayStr = format(day, 'yyyy-MM-dd')
                const label = format(day, 'MMM dd')
                const count = cleanData.filter(item => item.created_at.startsWith(dayStr)).length
                return { date: dayStr, count, label }
            })

            // Calculate Top Pages
            const pageCounts: Record<string, number> = {}
            cleanData.forEach(item => {
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
