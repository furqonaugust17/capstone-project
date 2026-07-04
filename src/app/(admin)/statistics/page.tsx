"use client";

import { useEffect, useState } from 'react';
import { analyticsService } from '@/services/analytics.service';
import { useApi } from '@/hooks/use-api';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Users, Gamepad2, Target, Eye, Flame, TrendingDown } from 'lucide-react';
import { LoadingSpinner } from '@/components/common/loading-spinner';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, ResponsiveContainer, PieChart, Pie, Cell, Legend } from 'recharts';

// Focus score colors
const FOCUS_COLORS = ['#EF4444', '#F97316', '#EAB308', '#22C55E', '#10B981'];

export default function StatisticsPage() {
  const [isMounted, setIsMounted] = useState(false);
  const { data: overview, isLoading: loadingOverview, execute: fetchOverview } = useApi(analyticsService.getOverview);
  const { data: animalsData, isLoading: loadingAnimals, execute: fetchAnimals } = useApi(analyticsService.getAnimalsAnalytics);
  const { data: focusData, isLoading: loadingFocus, execute: fetchFocus } = useApi(analyticsService.getFocusDistribution);

  useEffect(() => {
    setIsMounted(true);
    fetchOverview();
    fetchAnimals();
    fetchFocus();
  }, [fetchOverview, fetchAnimals, fetchFocus]);

  const isLoading = loadingOverview || loadingAnimals || loadingFocus;

  // Process pie chart data
  const pieData = focusData?.distribution ? Object.entries(focusData.distribution).map(([key, value]) => ({
    name: key,
    value: value
  })) : [];

  if (isLoading) {
    return <LoadingSpinner text="Memuat data analitik..." />;
  }

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold tracking-tight">Statistik & Analitik</h2>
        <p className="text-muted-foreground">Tinjauan komprehensif tentang performa aplikasi dan keterlibatan pemain.</p>
      </div>

      {/* Aggregate Stat Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <Card className="bg-gradient-to-br from-blue-50 to-white dark:from-blue-950/20 dark:to-zinc-950 border-blue-100 dark:border-blue-900">
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-blue-800 dark:text-blue-300">Total Pengguna Terdaftar</CardTitle>
            <div className="p-2 bg-blue-100 dark:bg-blue-900 rounded-full">
              <Users className="h-4 w-4 text-blue-600 dark:text-blue-400" />
            </div>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold text-blue-950 dark:text-blue-100">{overview?.totalUsers?.toLocaleString() || '0'}</div>
            <p className="text-xs text-blue-600/80 dark:text-blue-400/80 mt-1">Total pemain dalam sistem</p>
          </CardContent>
        </Card>

        <Card className="bg-gradient-to-br from-purple-50 to-white dark:from-purple-950/20 dark:to-zinc-950 border-purple-100 dark:border-purple-900">
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-purple-800 dark:text-purple-300">Total Permainan Dimainkan</CardTitle>
            <div className="p-2 bg-purple-100 dark:bg-purple-900 rounded-full">
              <Gamepad2 className="h-4 w-4 text-purple-600 dark:text-purple-400" />
            </div>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold text-purple-950 dark:text-purple-100">{overview?.totalSessions?.toLocaleString() || '0'}</div>
            <p className="text-xs text-purple-600/80 dark:text-purple-400/80 mt-1">Sesi permainan keseluruhan</p>
          </CardContent>
        </Card>

        <Card className="bg-gradient-to-br from-green-50 to-white dark:from-green-950/20 dark:to-zinc-950 border-green-100 dark:border-green-900">
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-green-800 dark:text-green-300">Skor Permainan Rata-rata</CardTitle>
            <div className="p-2 bg-green-100 dark:bg-green-900 rounded-full">
              <Target className="h-4 w-4 text-green-600 dark:text-green-400" />
            </div>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold text-green-950 dark:text-green-100">{overview?.avgScore?.toLocaleString() || '0'}</div>
            <p className="text-xs text-green-600/80 dark:text-green-400/80 mt-1">Poin rata-rata per sesi</p>
          </CardContent>
        </Card>

        <Card className="bg-gradient-to-br from-orange-50 to-white dark:from-orange-950/20 dark:to-zinc-950 border-orange-100 dark:border-orange-900">
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-orange-800 dark:text-orange-300">Fokus Pemain Rata-rata</CardTitle>
            <div className="p-2 bg-orange-100 dark:bg-orange-900 rounded-full">
              <Eye className="h-4 w-4 text-orange-600 dark:text-orange-400" />
            </div>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold text-orange-950 dark:text-orange-100">{((overview?.avgFocus || 0) * 100).toFixed(1)}%</div>
            <p className="text-xs text-orange-600/80 dark:text-orange-400/80 mt-1">Metrik perhatian keseluruhan</p>
          </CardContent>
        </Card>
      </div>

      {/* Popular/Least Popular Animals */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Card className="bg-gradient-to-br from-amber-50 to-white dark:from-amber-950/20 dark:to-zinc-950 border-amber-200 dark:border-amber-900">
          <CardHeader className="pb-2">
            <CardTitle className="text-amber-800 dark:text-amber-400 flex items-center gap-2 text-sm uppercase tracking-wider font-bold">
              <Flame className="h-5 w-5 text-amber-500" /> Hewan Paling Sering Dimainkan
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="flex items-center gap-4">
              <div className="h-16 w-16 rounded-full overflow-hidden bg-amber-100 dark:bg-amber-900 border-2 border-amber-300 dark:border-amber-700 shadow-sm flex-shrink-0">
                {animalsData?.mostPopular?.thumbnailUrl && (
                  <img src={animalsData.mostPopular.thumbnailUrl} alt="Thumbnail" className="h-full w-full object-cover" />
                )}
              </div>
              <div>
                <p className="text-2xl font-bold text-amber-950 dark:text-amber-100">{animalsData?.mostPopular?.animalName || 'N/A'}</p>
                <p className="text-sm font-medium text-amber-700 dark:text-amber-500">total {animalsData?.mostPopular?.totalPlayed?.toLocaleString() || 0} permainan dimainkan</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card className="bg-gradient-to-br from-slate-50 to-white dark:from-slate-900/40 dark:to-zinc-950 border-slate-200 dark:border-slate-800">
          <CardHeader className="pb-2">
            <CardTitle className="text-slate-700 dark:text-slate-400 flex items-center gap-2 text-sm uppercase tracking-wider font-bold">
              <TrendingDown className="h-5 w-5 text-slate-500" /> Hewan Paling Jarang Dimainkan
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="flex items-center gap-4">
              <div className="h-16 w-16 rounded-full overflow-hidden bg-slate-200 dark:bg-slate-800 border-2 border-slate-300 dark:border-slate-700 shadow-sm flex-shrink-0">
                {animalsData?.leastPopular?.thumbnailUrl && (
                  <img src={animalsData.leastPopular.thumbnailUrl} alt="Thumbnail" className="h-full w-full object-cover grayscale opacity-80" />
                )}
              </div>
              <div>
                <p className="text-2xl font-bold text-slate-900 dark:text-slate-200">{animalsData?.leastPopular?.animalName || 'N/A'}</p>
                <p className="text-sm font-medium text-slate-600 dark:text-slate-500">Hanya {animalsData?.leastPopular?.totalPlayed?.toLocaleString() || 0} permainan dimainkan</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Performa Hewan</CardTitle>
            <CardDescription>Perbandingan total permainan dan skor rata-rata untuk setiap hewan</CardDescription>
          </CardHeader>
          <CardContent className="h-[350px]">
            {isMounted && animalsData?.stats && animalsData.stats.length > 0 ? (
              <ResponsiveContainer width="100%" height="100%" minHeight={300}>
                <BarChart data={animalsData.stats} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#e5e7eb" />
                  <XAxis dataKey="animalName" tick={{ fontSize: 12 }} />
                  <YAxis yAxisId="left" tick={{ fontSize: 12 }} />
                  <YAxis yAxisId="right" orientation="right" tick={{ fontSize: 12 }} />
                  <RechartsTooltip
                    contentStyle={{ borderRadius: '8px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
                  />
                  <Legend wrapperStyle={{ paddingTop: '20px' }} />
                  <Bar yAxisId="left" dataKey="totalPlayed" name="Total Permainan Dimainkan" fill="#8b5cf6" radius={[4, 4, 0, 0]} />
                  <Bar yAxisId="right" dataKey="avgScore" name="Skor Rata-rata" fill="#10b981" radius={[4, 4, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            ) : (
              <div className="flex items-center justify-center h-full text-zinc-500">Data tidak tersedia</div>
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Distribusi Fokus Pemain</CardTitle>
            <CardDescription>Rincian skor fokus sesi untuk semua pengguna</CardDescription>
          </CardHeader>
          <CardContent className="h-[350px]">
            {isMounted && pieData.length > 0 ? (
              <ResponsiveContainer width="100%" height="100%" minHeight={300}>
                <PieChart>
                  <Pie
                    data={pieData}
                    cx="50%"
                    cy="45%"
                    innerRadius={70}
                    outerRadius={100}
                    paddingAngle={3}
                    dataKey="value"
                  >
                    {pieData.map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={FOCUS_COLORS[index % FOCUS_COLORS.length]} />
                    ))}
                  </Pie>
                  <RechartsTooltip
                    formatter={(value) => [`${value} sesi`, 'Jumlah']}
                    contentStyle={{ borderRadius: '8px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
                  />
                  <Legend wrapperStyle={{ paddingTop: '20px' }} />
                </PieChart>
              </ResponsiveContainer>
            ) : (
              <div className="flex items-center justify-center h-full text-zinc-500">Data tidak tersedia</div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
