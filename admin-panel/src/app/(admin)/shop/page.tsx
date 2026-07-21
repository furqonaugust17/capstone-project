"use client";

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { shopService } from '@/services/shop.service';
import { usePagination } from '@/hooks/use-pagination';
import { useFilters } from '@/hooks/use-filters';
import { useApi } from '@/hooks/use-api';
import { ShopItemsTable } from '@/components/tables/shop-items-table';
import { Pagination } from '@/components/common/pagination';
import { DeleteConfirmDialog } from '@/components/dialogs/delete-confirm';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Search, Plus } from 'lucide-react';
import { DEFAULT_PAGE_SIZE } from '@/lib/constants';

export default function ShopPage() {
  const router = useRouter();
  const { page, limit, setPage } = usePagination(1, DEFAULT_PAGE_SIZE);
  const { filters, debouncedFilters, updateFilter } = useFilters({
    search: '',
    category: 'All',
    rarity: 'All',
  });

  const { data, isLoading, execute: fetchItems } = useApi(shopService.getItems);
  const { execute: deleteItem, isLoading: isDeleting } = useApi(shopService.deleteItem, {
    successMessage: 'Item toko berhasil dihapus',
  });

  const [deleteId, setDeleteId] = useState<string | null>(null);

  useEffect(() => {
    fetchItems({
      page,
      limit,
      search: debouncedFilters.search || undefined,
      category: debouncedFilters.category !== 'All' ? debouncedFilters.category : undefined,
      rarity: debouncedFilters.rarity !== 'All' ? debouncedFilters.rarity : undefined,
    });
  }, [page, limit, debouncedFilters, fetchItems]);

  const handleDelete = async () => {
    if (deleteId) {
      await deleteItem(deleteId);
      setDeleteId(null);
      fetchItems({
        page,
        limit,
        search: debouncedFilters.search || undefined,
        category: debouncedFilters.category !== 'All' ? debouncedFilters.category : undefined,
        rarity: debouncedFilters.rarity !== 'All' ? debouncedFilters.rarity : undefined,
      });
    }
  };

  const handleCategoryChange = (value: string | null) => {
    if (value) {
      updateFilter('category', value);
      setPage(1);
    }
  };

  const handleRarityChange = (value: string | null) => {
    if (value) {
      updateFilter('rarity', value);
      setPage(1);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold tracking-tight">Item Toko</h2>
          <p className="text-muted-foreground">Kelola item toko di dalam permainan Anda.</p>
        </div>
        <Button onClick={() => router.push('/shop/new')}>
          <Plus className="mr-2 h-4 w-4" /> Tambah Item
        </Button>
      </div>

      <div className="flex items-center gap-4">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Cari item berdasarkan nama..."
            className="pl-8"
            value={filters.search}
            onChange={(e) => updateFilter('search', e.target.value)}
          />
        </div>
        
        <Select value={filters.category} onValueChange={handleCategoryChange}>
          <SelectTrigger className="w-[180px]">
            <SelectValue placeholder="Kategori" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="All">Semua Kategori</SelectItem>
            <SelectItem value="AVATAR">Avatar</SelectItem>
            <SelectItem value="FRAME">Frame</SelectItem>
            <SelectItem value="STICKER">Sticker</SelectItem>
            <SelectItem value="THEME">Theme</SelectItem>
          </SelectContent>
        </Select>

        <Select value={filters.rarity} onValueChange={handleRarityChange}>
          <SelectTrigger className="w-[180px]">
            <SelectValue placeholder="Kelangkaan" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="All">Semua Kelangkaan</SelectItem>
            <SelectItem value="COMMON">Common</SelectItem>
            <SelectItem value="RARE">Rare</SelectItem>
            <SelectItem value="EPIC">Epic</SelectItem>
            <SelectItem value="LEGENDARY">Legendary</SelectItem>
          </SelectContent>
        </Select>
      </div>

      <ShopItemsTable
        items={data?.data || []}
        isLoading={isLoading}
        onEdit={(id) => router.push(`/shop/${id}`)}
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
        title="Hapus Item Toko"
        description="Apakah Anda yakin ingin menghapus item toko ini? Tindakan ini tidak dapat dibatalkan."
      />
    </div>
  );
}
