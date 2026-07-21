"use client";

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { animalService } from '@/services/animal.service';
import { usePagination } from '@/hooks/use-pagination';
import { useFilters } from '@/hooks/use-filters';
import { useApi } from '@/hooks/use-api';
import { AnimalsTable } from '@/components/tables/animals-table';
import { Pagination } from '@/components/common/pagination';
import { DeleteConfirmDialog } from '@/components/dialogs/delete-confirm';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Search, Plus } from 'lucide-react';
import { DEFAULT_PAGE_SIZE } from '@/lib/constants';

export default function AnimalsPage() {
  const router = useRouter();
  const { page, limit, setPage } = usePagination(1, DEFAULT_PAGE_SIZE);
  const { filters, debouncedFilters, updateFilter } = useFilters({ search: '' });

  const { data, isLoading, execute: fetchAnimals } = useApi(animalService.getAnimals);
  const { execute: deleteAnimal, isLoading: isDeleting } = useApi(animalService.deleteAnimal, {
    successMessage: 'Hewan berhasil dihapus',
  });

  const [deleteId, setDeleteId] = useState<string | null>(null);

  useEffect(() => {
    fetchAnimals({
      page,
      limit,
      search: debouncedFilters.search || undefined,
    });

  }, [page, limit, debouncedFilters, fetchAnimals]);

  const handleDelete = async () => {
    if (deleteId) {
      await deleteAnimal(deleteId as any); // id is number in backend
      setDeleteId(null);
      fetchAnimals({ page, limit, search: debouncedFilters.search || undefined });
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold tracking-tight">Hewan</h2>
          <p className="text-muted-foreground">Kelola kamus hewan untuk permainan.</p>
        </div>
        <Button onClick={() => router.push('/animals/new')}>
          <Plus className="mr-2 h-4 w-4" /> Tambah Hewan
        </Button>
      </div>

      <div className="flex items-center justify-between">
        <div className="relative w-full max-w-sm">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Cari hewan berdasarkan nama..."
            className="pl-8"
            value={filters.search}
            onChange={(e) => updateFilter('search', e.target.value)}
          />
        </div>
        {/* P1D-04: Filter Panel Placeholder */}
      </div>

      <AnimalsTable
        animals={data?.data || []}
        isLoading={isLoading}
        onDelete={(id) => setDeleteId(id)}
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
        title="Hapus Hewan"
        description="Apakah Anda yakin ingin menghapus hewan ini? Tindakan ini tidak dapat dibatalkan."
      />
    </div>
  );
}
