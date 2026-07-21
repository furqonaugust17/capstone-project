"use client";

import { useRouter } from 'next/navigation';
import { shopService } from '@/services/shop.service';
import { useApi } from '@/hooks/use-api';
import { ShopItemForm } from '@/components/forms/shop-item-form';
import { Button } from '@/components/ui/button';
import { ArrowLeft } from 'lucide-react';
import { ShopItemFormValues } from '@/lib/validators';

export default function CreateShopItemPage() {
  const router = useRouter();

  const { execute: createItem, isLoading } = useApi(shopService.createItem, {
    successMessage: 'Item toko berhasil ditambahkan',
    onSuccess: () => router.push('/shop'),
  });

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
    await createItem(formData);
  };

  return (
    <div className="space-y-6 max-w-4xl">
      <div className="flex items-center gap-4">
        <Button variant="outline" size="icon" onClick={() => router.push('/shop')}>
          <ArrowLeft className="h-4 w-4" />
        </Button>
        <div>
          <h2 className="text-2xl font-bold tracking-tight">Tambah Item Toko Baru</h2>
          <p className="text-muted-foreground">Buat item baru untuk toko di dalam permainan.</p>
        </div>
      </div>

      <div className="bg-white dark:bg-zinc-950 border border-zinc-200 dark:border-zinc-800 rounded-lg p-6 shadow-sm">
        <ShopItemForm
          onSubmit={handleSubmit}
          isLoading={isLoading}
          isEditMode={false}
        />
      </div>
    </div>
  );
}
