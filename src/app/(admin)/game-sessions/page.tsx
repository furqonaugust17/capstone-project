"use client";

import { useEffect, useState } from 'react';
import { gameSessionService } from '@/services/game-session.service';
import { usePagination } from '@/hooks/use-pagination';
import { useFilters } from '@/hooks/use-filters';
import { useApi } from '@/hooks/use-api';
import { SessionsTable } from '@/components/tables/sessions-table';
import { SessionDetailModal } from '@/components/dialogs/session-detail-modal';
import { Pagination } from '@/components/common/pagination';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Search, Download } from 'lucide-react';
import { DEFAULT_PAGE_SIZE } from '@/lib/constants';
import { toast } from 'sonner';
import { ModelAccuracyChart } from '@/components/charts/model-accuracy-chart';
import { FocusScoreChart } from '@/components/charts/focus-score-chart';

export default function GameSessionsPage() {
  const { page, limit, setPage } = usePagination(1, DEFAULT_PAGE_SIZE);
  const { filters, debouncedFilters, updateFilter } = useFilters({ search: '' });
  
  const { data, isLoading, execute: fetchSessions } = useApi(gameSessionService.getSessions);

  const [selectedSessionId, setSelectedSessionId] = useState<string | null>(null);
  const [isExporting, setIsExporting] = useState(false);

  useEffect(() => {
    fetchSessions({
      page,
      limit,
      search: debouncedFilters.search || undefined,
    });
  }, [page, limit, debouncedFilters, fetchSessions]);

  const handleExportCSV = async () => {
    setIsExporting(true);
    try {
      const blob = await gameSessionService.exportCSV({
        search: debouncedFilters.search || undefined,
      });
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `game_sessions_${new Date().toISOString().split('T')[0]}.csv`;
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(url);
      document.body.removeChild(a);
      toast.success('Ekspor berhasil');
    } catch (error) {
      toast.error('Gagal mengekspor CSV');
    } finally {
      setIsExporting(false);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold tracking-tight">Sesi Permainan</h2>
          <p className="text-muted-foreground">Pantau dan analisis sesi menggambar pemain.</p>
        </div>
        <Button onClick={handleExportCSV} disabled={isExporting} variant="outline">
          <Download className="mr-2 h-4 w-4" /> {isExporting ? 'Mengekspor...' : 'Ekspor CSV'}
        </Button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <ModelAccuracyChart />
        <FocusScoreChart />
      </div>

      <div className="flex items-center justify-between">
        <div className="relative w-full max-w-sm">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Cari berdasarkan username atau hewan..."
            className="pl-8"
            value={filters.search}
            onChange={(e) => updateFilter('search', e.target.value)}
          />
        </div>
      </div>

      <SessionsTable 
        sessions={data?.data || []} 
        isLoading={isLoading} 
        onViewDetail={setSelectedSessionId}
      />

      {data?.meta && data.meta.total > 0 && (
        <Pagination
          page={page}
          limit={limit}
          total={data.meta.total}
          onPageChange={setPage}
        />
      )}

      <SessionDetailModal
        sessionId={selectedSessionId}
        onClose={() => setSelectedSessionId(null)}
      />
    </div>
  );
}
