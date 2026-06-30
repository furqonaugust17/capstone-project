"use client";

import { useEffect, useState } from 'react';
import { StatCard } from '@/components/common/stat-card';
import { Users, Gamepad2, Trophy, Cpu } from 'lucide-react';
import { statisticsService } from '@/services/statistics.service';
import { SessionsChart } from '@/components/charts/sessions-chart';
import { AnimalPopularityChart } from '@/components/charts/animal-popularity-chart';
import { TopUsersList } from '@/components/dashboard/top-users-list';
import { RecentSessionsList } from '@/components/dashboard/recent-sessions-list';

interface OverviewData {
  totalUsers: number;
  totalGames: number;
  avgScore: number;
  activeModels: number;
  mostPlayedAnimal: string;
}

export default function DashboardPage() {
  const [data, setData] = useState<OverviewData | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchOverview = async () => {
      try {
        const response = await statisticsService.getOverview();
        setData(response);
      } catch (error) {
        console.error('Failed to fetch overview', error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchOverview();
  }, []);

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold tracking-tight">Dashboard</h2>
        <p className="text-muted-foreground">Ringkasan metrik aplikasi Anda.</p>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <StatCard
          title="Total Pengguna"
          value={data?.totalUsers ?? 0}
          icon={Users}
          isLoading={isLoading}
        />
        <StatCard
          title="Total Permainan"
          value={data?.totalGames ?? 0}
          icon={Gamepad2}
          isLoading={isLoading}
        />
        <StatCard
          title="Skor Rata-rata"
          value={data?.avgScore ? Math.round(data.avgScore) : 0}
          icon={Trophy}
          isLoading={isLoading}
        />
        <StatCard
          title="Model Aktif"
          value={data?.activeModels ?? 0}
          icon={Cpu}
          isLoading={isLoading}
        />
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-7">
        <div className="col-span-4">
          <SessionsChart />
        </div>
        <div className="col-span-3">
          <AnimalPopularityChart />
        </div>
      </div>
      
      {/* P1B-15: Recent Activity Section */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        <div className="col-span-1 lg:col-span-1">
          <TopUsersList />
        </div>
        <div className="col-span-1 lg:col-span-2">
          <RecentSessionsList />
        </div>
      </div>
    </div>
  );
}
