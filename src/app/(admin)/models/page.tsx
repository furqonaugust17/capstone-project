"use client";

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { modelService } from '@/services/model.service';
import { usePagination } from '@/hooks/use-pagination';
import { useFilters } from '@/hooks/use-filters';
import { useApi } from '@/hooks/use-api';
import { ModelsTable } from '@/components/tables/models-table';
import { Pagination } from '@/components/common/pagination';
import { DeleteConfirmDialog } from '@/components/dialogs/delete-confirm';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Search, Plus } from 'lucide-react';
import { DEFAULT_PAGE_SIZE } from '@/lib/constants';

export default function ModelsPage() {
  const router = useRouter();
  const { page, limit, setPage } = usePagination(1, DEFAULT_PAGE_SIZE);
  const { filters, debouncedFilters, updateFilter } = useFilters({ search: '' });
  
  const { data, isLoading, execute: fetchModels } = useApi(modelService.getModels);
  
  const { execute: deleteModel, isLoading: isDeleting } = useApi(modelService.deleteModel, {
    successMessage: 'Model berhasil dihapus',
  });

  const { execute: activateModel, isLoading: isActivating } = useApi(modelService.activateModel, {
    successMessage: 'Model berhasil diaktifkan',
  });

  const [deleteId, setDeleteId] = useState<string | null>(null);

  const loadData = () => {
    fetchModels({
      page,
      limit,
      search: debouncedFilters.search || undefined,
    });
  };

  useEffect(() => {
    loadData();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page, limit, debouncedFilters, fetchModels]);

  const handleDelete = async () => {
    if (deleteId) {
      await deleteModel(deleteId as any); // id is number in backend
      setDeleteId(null);
      loadData();
    }
  };

  const handleActivate = async (id: string) => {
    if (confirm("Apakah Anda yakin ingin mengaktifkan model ini? Model lain mungkin akan dinonaktifkan.")) {
      await activateModel(id as any);
      loadData();
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold tracking-tight">Model Machine Learning</h2>
          <p className="text-muted-foreground">Kelola model klasifikasi untuk permainan.</p>
        </div>
        <Button onClick={() => router.push('/models/new')}>
          <Plus className="mr-2 h-4 w-4" /> Tambah Model
        </Button>
      </div>

      <div className="flex items-center justify-between">
        <div className="relative w-full max-w-sm">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Cari model berdasarkan nama atau versi..."
            className="pl-8"
            value={filters.search}
            onChange={(e) => updateFilter('search', e.target.value)}
          />
        </div>
      </div>

      <ModelsTable 
        models={data?.data || []} 
        isLoading={isLoading || isActivating} 
        onDelete={(id) => setDeleteId(id)}
        onActivate={handleActivate}
      />

      {data?.meta && data.meta.total > 0 && (
        <Pagination
          page={page}
          limit={limit}
          total={data.meta.total}
          onPageChange={setPage}
        />
      )}

      <DeleteConfirmDialog
        open={!!deleteId}
        onOpenChange={(open) => !open && setDeleteId(null)}
        onConfirm={handleDelete}
        isLoading={isDeleting}
        title="Hapus Model"
        description="Apakah Anda yakin ingin menghapus model ini? Tindakan ini tidak dapat dibatalkan."
      />
    </div>
  );
}
