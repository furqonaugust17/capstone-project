"use client";

import { useRouter, useParams } from 'next/navigation';
import { useEffect } from 'react';
import { shopService } from '@/services/shop.service';
import { useApi } from '@/hooks/use-api';
import { ShopItemForm } from '@/components/forms/shop-item-form';
import { Button } from '@/components/ui/button';
import { ArrowLeft } from 'lucide-react';
import { LoadingSpinner } from '@/components/common/loading-spinner';
import { ShopItemFormValues } from '@/lib/validators';

export default function EditShopItemPage() {
  const router = useRouter();
  const params = useParams();
  const id = params.id as string;

  const { data: item, isLoading: isFetching, execute: fetchItem } = useApi(shopService.getItemById);
  const { execute: updateItem, isLoading: isUpdating } = useApi(shopService.updateItem, {
    successMessage: 'Item toko berhasil diperbarui',
    onSuccess: () => router.push('/shop'),
  });

  useEffect(() => {
    if (id) fetchItem(id);
  }, [id, fetchItem]);

  const handleSubmit = async (data: ShopItemFormValues) => {
    const formData = new FormData();
    Object.keys(data).forEach((key) => {
      const value = data[key as keyof ShopItemFormValues];
      if (value !== undefined && value !== null) {
        if (key === 'file' && value instanceof File) {
          formData.append(key, value);
        } else {
          formData.append(key, value.toString());
        }
      }
    });
    await updateItem(id, formData);
  };

  if (isFetching) {
    return <LoadingSpinner text="Memuat data item toko..." />;
  }

  if (!item) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[400px]">
        <p className="text-zinc-500 mb-4">Item toko tidak ditemukan atau telah dihapus.</p>
        <Button variant="outline" onClick={() => router.push('/shop')}>
          Kembali ke Daftar Toko
        </Button>
      </div>
    );
  }

  return (
    <div className="space-y-6 max-w-4xl mx-auto">
      <div className="flex items-center gap-4">
        <Button variant="outline" size="icon" onClick={() => router.push('/shop')}>
          <ArrowLeft className="h-4 w-4" />
        </Button>
        <div>
          <h2 className="text-2xl font-bold tracking-tight">Edit Item Toko</h2>
          <p className="text-muted-foreground">Ubah detail untuk item toko ini.</p>
        </div>
      </div>

      <div className="bg-white dark:bg-zinc-950 border border-zinc-200 dark:border-zinc-800 rounded-lg p-6 shadow-sm">
        <ShopItemForm 
          initialData={item}
          onSubmit={handleSubmit} 
          isLoading={isUpdating} 
          isEditMode={true} 
        />
      </div>
    </div>
  );
}
