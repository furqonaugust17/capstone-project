"use client";

import { useEffect, useState, useMemo } from 'react';
import { useApi } from '@/hooks/use-api';
import { leaderboardService } from '@/services/leaderboard.service';
import { LeaderboardTable } from '@/components/tables/leaderboard-table';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Badge } from '@/components/ui/badge';
import { Search, RefreshCw, Users, Trophy, Target, Gamepad2, Medal, Clock, Camera, Zap } from 'lucide-react';
import { LoadingSpinner } from '@/components/common/loading-spinner';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, ResponsiveContainer } from 'recharts';
import { useAutoRefresh } from '@/hooks/use-auto-refresh';
import { LeaderboardEntry, LeaderboardPeriod } from '@/types';
import { formatDate } from '@/lib/utils';
import { toast } from 'sonner';

const generateDefaultPeriodLabel = (period: LeaderboardPeriod): string => {
  const now = new Date();
  const year = now.getFullYear();
  switch (period) {
    case 'WEEKLY': {
      const startOfYear = new Date(year, 0, 1);
      const days = Math.floor((now.getTime() - startOfYear.getTime()) / 86400000);
      const week = Math.ceil((days + startOfYear.getDay() + 1) / 7);
      return `${year}-W${String(week).padStart(2, '0')}`;
    }
    case 'MONTHLY':
      return `${year}-${String(now.getMonth() + 1).padStart(2, '0')}`;
    case 'SEASONAL': {
      const quarter = Math.ceil((now.getMonth() + 1) / 3);
      return `${year}-S${quarter}`;
    }
    case 'ALL_TIME':
      return `${year}`;
  }
};

const computeScoreBuckets = (entries: LeaderboardEntry[]) => {
  const buckets = { '0-1K': 0, '1K-3K': 0, '3K-5K': 0, '5K-10K': 0, '10K+': 0 };
  entries.forEach(e => {
    const score = e.totalScore ?? 0;
    if (score < 1000) buckets['0-1K']++;
    else if (score < 3000) buckets['1K-3K']++;
    else if (score < 5000) buckets['3K-5K']++;
    else if (score < 10000) buckets['5K-10K']++;
    else buckets['10K+']++;
  });
  return Object.entries(buckets).map(([range, count]) => ({ range, count }));
};

const computeGamesBuckets = (entries: LeaderboardEntry[]) => {
  const buckets = { '1-10': 0, '11-25': 0, '26-50': 0, '51-100': 0, '100+': 0 };
  entries.forEach(e => {
    const games = e.totalGames ?? 0;
    if (games <= 10) buckets['1-10']++;
    else if (games <= 25) buckets['11-25']++;
    else if (games <= 50) buckets['26-50']++;
    else if (games <= 100) buckets['51-100']++;
    else buckets['100+']++;
  });
  return Object.entries(buckets).map(([range, count]) => ({ range, count }));
};

export default function LeaderboardPage() {
  const [isMounted, setIsMounted] = useState(false);
  const [search, setSearch] = useState('');
  const [lastUpdated, setLastUpdated] = useState<Date | null>(null);
  
  // Auto Refresh State
  const [refreshInterval, setRefreshInterval] = useState<number | null>(() => {
    if (typeof window !== 'undefined') {
      const saved = localStorage.getItem('leaderboard_refresh_interval');
      return saved ? parseInt(saved, 10) : null;
    }
    return null;
  });
  const [countdown, setCountdown] = useState<number>(refreshInterval ? refreshInterval / 1000 : 0);

  // Snapshot State
  const [selectedPeriod, setSelectedPeriod] = useState<LeaderboardPeriod>('WEEKLY');
  const [periodLabel, setPeriodLabel] = useState(generateDefaultPeriodLabel('WEEKLY'));

  // APIs
  const { data: rawEntries, isLoading, error, execute: fetchLive } = useApi(leaderboardService.getLive);
  const { data: snapshotData, isLoading: isLoadingSnapshot, execute: fetchSnapshot } = useApi(leaderboardService.getSnapshot);
  const { execute: generateSnapshot, isLoading: isGeneratingSnapshot } = useApi(leaderboardService.generateSnapshot, {
    successMessage: 'Snapshot berhasil dibuat',
  });

  // Initial Fetch & Mount
  useEffect(() => {
    setIsMounted(true);
    setLastUpdated(new Date());
    fetchLive({ limit: 100 });
  }, [fetchLive]);

  // Auto Refresh Hook
  useAutoRefresh(() => {
    if (!isLoading) {
      fetchLive({ limit: 100 }).then(() => {
        setLastUpdated(new Date());
        setCountdown(refreshInterval ? refreshInterval / 1000 : 0);
      });
    }
  }, refreshInterval);

  // Countdown timer
  useEffect(() => {
    if (!refreshInterval) return;
    setCountdown(refreshInterval / 1000);
    const id = setInterval(() => {
      setCountdown(prev => (prev > 0 ? prev - 1 : prev));
    }, 1000);
    return () => clearInterval(id);
  }, [refreshInterval]);

  const handleIntervalChange = (value: string | null) => {
    if (!value) return;
    const ms = value === 'off' ? null : parseInt(value, 10);
    setRefreshInterval(ms);
    if (typeof window !== 'undefined') {
      if (ms) localStorage.setItem('leaderboard_refresh_interval', ms.toString());
      else localStorage.removeItem('leaderboard_refresh_interval');
    }
  };

  const handleManualRefresh = async () => {
    await fetchLive({ limit: 100 });
    setLastUpdated(new Date());
    setCountdown(refreshInterval ? refreshInterval / 1000 : 0);
    toast.success('Papan Peringkat diperbarui');
  };

  const handlePeriodChange = (value: LeaderboardPeriod | null) => {
    if (!value) return;
    setSelectedPeriod(value);
    setPeriodLabel(generateDefaultPeriodLabel(value));
  };

  const handleViewSnapshot = async () => {
    try {
      await fetchSnapshot({ period: selectedPeriod, periodLabel });
    } catch (err: any) {
      if (err.response?.status === 404) {
        toast.error('Snapshot tidak ditemukan untuk periode ini.');
      } else {
        toast.error('Gagal melihat snapshot');
      }
    }
  };

  const handleGenerateSnapshot = async () => {
    await generateSnapshot({ period: selectedPeriod, periodLabel, limit: 100 });
    await fetchSnapshot({ period: selectedPeriod, periodLabel });
  };

  // Derived Data
  const entries = useMemo(() => {
    if (!rawEntries) return [];
    if (!search) return rawEntries;
    const lowerSearch = search.toLowerCase();
    return rawEntries.filter(e => 
      e.username.toLowerCase().includes(lowerSearch) || 
      e.displayName?.toLowerCase().includes(lowerSearch)
    );
  }, [rawEntries, search]);

  const stats = useMemo(() => {
    if (!rawEntries) return null;
    return leaderboardService.computeStats(rawEntries);
  }, [rawEntries]);

  const scoreBuckets = useMemo(() => rawEntries ? computeScoreBuckets(rawEntries) : [], [rawEntries]);
  const gamesBuckets = useMemo(() => rawEntries ? computeGamesBuckets(rawEntries) : [], [rawEntries]);

  if (error && !rawEntries) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[400px]">
        <p className="text-red-500 mb-4">Gagal memuat data papan peringkat. Silakan coba lagi.</p>
        <Button onClick={handleManualRefresh}>Coba Lagi</Button>
      </div>
    );
  }

  return (
    <div className="space-y-8 max-w-7xl mx-auto">
      {/* Header & Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h2 className="text-3xl font-bold tracking-tight">Papan Peringkat</h2>
          <p className="text-muted-foreground">100 pemain teratas diurutkan berdasarkan total skor.</p>
        </div>
        
        <div className="flex flex-col items-end gap-2">
          <div className="flex items-center gap-3">
            <div className="flex items-center gap-2 mr-2">
              <span className="text-sm font-medium">Segarkan otomatis:</span>
              <Select value={refreshInterval ? refreshInterval.toString() : 'off'} onValueChange={handleIntervalChange}>
                <SelectTrigger className="w-[120px] h-9">
                  <SelectValue placeholder="Mati" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="off">Mati</SelectItem>
                  <SelectItem value="30000">30 detik</SelectItem>
                  <SelectItem value="60000">1 menit</SelectItem>
                  <SelectItem value="300000">5 menit</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <Button 
              variant="outline" 
              size="sm" 
              onClick={handleManualRefresh} 
              disabled={isLoading}
              className="h-9"
            >
              <RefreshCw className={`mr-2 h-4 w-4 ${isLoading ? 'animate-spin' : ''}`} /> 
              Segarkan
            </Button>
          </div>
          <div className="flex items-center text-xs text-muted-foreground h-4">
            {isMounted && lastUpdated && (
              <>
                <Clock className="h-3 w-3 mr-1" /> Terakhir diperbarui: {lastUpdated.toLocaleTimeString()}
                {refreshInterval && countdown > 0 && (
                  <span className="ml-2 flex items-center text-blue-600">
                    <span className="relative flex h-2 w-2 mr-1.5">
                      <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-blue-400 opacity-75"></span>
                      <span className="relative inline-flex rounded-full h-2 w-2 bg-blue-500"></span>
                    </span>
                    Segarkan dalam {countdown}d
                  </span>
                )}
              </>
            )}
          </div>
        </div>
      </div>

      {/* Statistics Section */}
      <div className="space-y-4">
        {/* Top Player Banner & Stat Cards */}
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-4">
          <Card className="lg:col-span-1 bg-gradient-to-br from-amber-500 to-yellow-600 text-white border-none shadow-md overflow-hidden relative">
            <div className="absolute right-[-20px] top-[-20px] opacity-10">
              <Trophy className="h-40 w-40" />
            </div>
            <CardHeader className="pb-2">
              <CardTitle className="text-amber-100 text-sm font-medium">👑 Pemain #1</CardTitle>
            </CardHeader>
            <CardContent className="relative z-10">
              {stats?.topPlayer ? (
                <div className="flex flex-col">
                  <span className="text-2xl font-bold truncate">{stats.topPlayer.username}</span>
                  <span className="text-amber-100 font-medium">{stats.topPlayer.totalScore.toLocaleString()} pts</span>
                </div>
              ) : (
                <div className="text-amber-100/70">Tidak ada data</div>
              )}
            </CardContent>
          </Card>
          
          <div className="lg:col-span-3 grid grid-cols-2 md:grid-cols-4 gap-4">
            <Card>
              <CardHeader className="pb-2 flex flex-row items-center justify-between">
                <CardTitle className="text-sm font-medium text-muted-foreground">Pemain Peringkat</CardTitle>
                <Users className="h-4 w-4 text-zinc-400" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{stats?.totalRankedUsers || 0}</div>
              </CardContent>
            </Card>
            <Card>
              <CardHeader className="pb-2 flex flex-row items-center justify-between">
                <CardTitle className="text-sm font-medium text-muted-foreground">Poin Tertinggi</CardTitle>
                <Trophy className="h-4 w-4 text-amber-500" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{stats?.highestPoints?.toLocaleString() || 0}</div>
              </CardContent>
            </Card>
            <Card>
              <CardHeader className="pb-2 flex flex-row items-center justify-between">
                <CardTitle className="text-sm font-medium text-muted-foreground">Poin Rata-rata</CardTitle>
                <Target className="h-4 w-4 text-blue-500" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{stats?.averagePoints?.toLocaleString() || 0}</div>
              </CardContent>
            </Card>
            <Card>
              <CardHeader className="pb-2 flex flex-row items-center justify-between">
                <CardTitle className="text-sm font-medium text-muted-foreground">Permainan Terbanyak</CardTitle>
                <Gamepad2 className="h-4 w-4 text-purple-500" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{stats?.mostGamesPlayed?.toLocaleString() || 0}</div>
              </CardContent>
            </Card>
          </div>
        </div>

        {/* Charts */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-base">Distribusi Skor</CardTitle>
            </CardHeader>
            <CardContent className="h-[250px] pb-4">
              {isMounted && scoreBuckets.length > 0 ? (
                <ResponsiveContainer width="100%" height="100%" minHeight={200}>
                  <BarChart data={scoreBuckets} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" vertical={false} />
                    <XAxis dataKey="range" tick={{ fontSize: 11 }} />
                    <YAxis tick={{ fontSize: 11 }} allowDecimals={false} />
                    <RechartsTooltip cursor={{ fill: 'rgba(0,0,0,0.05)' }} />
                    <Bar dataKey="count" fill="#3b82f6" radius={[4, 4, 0, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              ) : (
                <div className="flex h-full items-center justify-center text-sm text-zinc-500">Data tidak tersedia</div>
              )}
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-base">Distribusi Permainan</CardTitle>
            </CardHeader>
            <CardContent className="h-[250px] pb-4">
              {isMounted && gamesBuckets.length > 0 ? (
                <ResponsiveContainer width="100%" height="100%" minHeight={200}>
                  <BarChart data={gamesBuckets} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" vertical={false} />
                    <XAxis dataKey="range" tick={{ fontSize: 11 }} />
                    <YAxis tick={{ fontSize: 11 }} allowDecimals={false} />
                    <RechartsTooltip cursor={{ fill: 'rgba(0,0,0,0.05)' }} />
                    <Bar dataKey="count" fill="#8b5cf6" radius={[4, 4, 0, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              ) : (
                <div className="flex h-full items-center justify-center text-sm text-zinc-500">Data tidak tersedia</div>
              )}
            </CardContent>
          </Card>
        </div>
      </div>

      {/* Live Leaderboard Table */}
      <div className="space-y-4">
        <div className="flex items-center gap-4">
          <div className="relative flex-1 max-w-sm">
            <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder="Cari berdasarkan username..."
              className="pl-8"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
          </div>
          <Badge variant="outline" className="text-xs text-muted-foreground font-normal">
            Menampilkan top {entries.length}
          </Badge>
        </div>

        <LeaderboardTable entries={entries} isLoading={isLoading && !rawEntries} />
      </div>

      {/* Snapshot Management */}
      <div className="pt-8 border-t">
        <Card className="bg-zinc-50/50 dark:bg-zinc-900/50">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Camera className="h-5 w-5" /> Manajemen Snapshot
            </CardTitle>
            <CardDescription>
              Lihat snapshot historis atau buat peringkat waktu tertentu.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="flex flex-col md:flex-row items-end gap-4 mb-6">
              <div className="space-y-1.5 w-full md:w-auto">
                <label className="text-xs font-medium text-muted-foreground">Periode</label>
                <Select value={selectedPeriod} onValueChange={handlePeriodChange}>
                  <SelectTrigger className="w-full md:w-[150px]">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="WEEKLY">Mingguan</SelectItem>
                    <SelectItem value="MONTHLY">Bulanan</SelectItem>
                    <SelectItem value="SEASONAL">Musiman</SelectItem>
                    <SelectItem value="ALL_TIME">Sepanjang Waktu</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-1.5 w-full md:w-[200px]">
                <label className="text-xs font-medium text-muted-foreground">Label Periode</label>
                <Input 
                  value={periodLabel} 
                  onChange={(e) => setPeriodLabel(e.target.value)} 
                  placeholder="mis. 2026-W25"
                />
              </div>
              <div className="flex items-center gap-2 w-full md:w-auto">
                <Button 
                  variant="secondary" 
                  onClick={handleViewSnapshot}
                  disabled={isLoadingSnapshot}
                  className="flex-1 md:flex-none"
                >
                  {isLoadingSnapshot ? <RefreshCw className="mr-2 h-4 w-4 animate-spin" /> : <Search className="mr-2 h-4 w-4" />}
                  Lihat Snapshot
                </Button>
                <Button 
                  onClick={handleGenerateSnapshot}
                  disabled={isGeneratingSnapshot}
                  className="flex-1 md:flex-none bg-blue-600 hover:bg-blue-700"
                >
                  {isGeneratingSnapshot ? <RefreshCw className="mr-2 h-4 w-4 animate-spin" /> : <Zap className="mr-2 h-4 w-4" />}
                  Buat Snapshot
                </Button>
              </div>
            </div>

            {/* Snapshot Viewer */}
            {snapshotData && (
              <div className="space-y-4 border rounded-lg p-4 bg-white dark:bg-zinc-950">
                <div className="flex items-center justify-between border-b pb-4">
                  <div>
                    <h4 className="font-semibold text-lg flex items-center gap-2">
                      <Medal className="h-5 w-5 text-amber-500" />
                      Snapshot: {snapshotData.periodLabel}
                    </h4>
                    <p className="text-xs text-muted-foreground mt-1 flex items-center gap-4">
                      <span>Dibuat pada: {formatDate(snapshotData.generatedAt, 'PPpp')}</span>
                      <span><Badge variant="outline">{snapshotData.period}</Badge></span>
                      <span>Entri: {snapshotData.rankings?.length || 0}</span>
                    </p>
                  </div>
                  <Button variant="ghost" size="sm" onClick={() => fetchSnapshot(undefined as any)}>Tutup</Button>
                </div>
                
                <div className="max-h-[500px] overflow-auto">
                  <LeaderboardTable entries={snapshotData.rankings || []} isLoading={false} />
                </div>
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
