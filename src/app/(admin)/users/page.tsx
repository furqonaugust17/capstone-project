"use client";

import { useEffect, useState } from 'react';
import { userService } from '@/services/user.service';
import { usePagination } from '@/hooks/use-pagination';
import { useFilters } from '@/hooks/use-filters';
import { useApi } from '@/hooks/use-api';
import { UsersTable } from '@/components/tables/users-table';
import { Pagination } from '@/components/common/pagination';
import { DeleteConfirmDialog } from '@/components/dialogs/delete-confirm';
import { Input } from '@/components/ui/input';
import { Search } from 'lucide-react';
import { DEFAULT_PAGE_SIZE } from '@/lib/constants';

export default function UsersPage() {
  const { page, limit, setPage } = usePagination(1, DEFAULT_PAGE_SIZE);
  const { filters, debouncedFilters, updateFilter } = useFilters({ search: '' });
  
  const { data, isLoading, execute: fetchUsers } = useApi(userService.getUsers);
  const { execute: deleteUser, isLoading: isDeleting } = useApi(userService.deleteUser, {
    successMessage: 'Pengguna berhasil dihapus',
  });

  const [deleteId, setDeleteId] = useState<string | null>(null);

  useEffect(() => {
    fetchUsers({
      page,
      limit,
      search: debouncedFilters.search || undefined,
    });
  }, [page, limit, debouncedFilters, fetchUsers]);

  const handleDelete = async () => {
    if (deleteId) {
      await deleteUser(deleteId);
      setDeleteId(null);
      // Refresh list
      fetchUsers({ page, limit, search: debouncedFilters.search || undefined });
    }
  };

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold tracking-tight">Pengguna</h2>
        <p className="text-muted-foreground">Kelola pengguna aplikasi Anda.</p>
      </div>

      <div className="flex items-center justify-between">
        <div className="relative w-full max-w-sm">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Cari pengguna..."
            className="pl-8"
            value={filters.search}
            onChange={(e) => updateFilter('search', e.target.value)}
          />
        </div>
      </div>

      <UsersTable 
        users={data?.data || []} 
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
        title="Hapus Pengguna"
        description="Apakah Anda yakin ingin menghapus pengguna ini? Tindakan ini tidak dapat dibatalkan."
      />
    </div>
  );
}
