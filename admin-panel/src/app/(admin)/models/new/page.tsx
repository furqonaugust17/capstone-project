"use client";

import { useRouter } from 'next/navigation';
import { modelService } from '@/services/model.service';
import { useApi } from '@/hooks/use-api';
import { ModelForm } from '@/components/forms/model-form';
import { Button } from '@/components/ui/button';
import { ArrowLeft } from 'lucide-react';

export default function CreateModelPage() {
  const router = useRouter();
  
  const { execute: createModel, isLoading } = useApi(modelService.createModel, {
    successMessage: 'Model berhasil ditambahkan',
    onSuccess: () => {
      router.push('/models');
    }
  });

  const handleSubmit = async (data: any) => {
    const formData = new FormData();
    Object.keys(data).forEach((key) => {
      if (data[key] !== undefined && data[key] !== null) {
        if (key === 'file' && data[key]) {
          formData.append(key, data[key]);
        } else {
          formData.append(key, data[key].toString());
        }
      }
    });
    await createModel(formData);
  };

  return (
    <div className="space-y-6 max-w-4xl">
      <div className="flex items-center gap-4">
        <Button variant="ghost" size="icon" onClick={() => router.push('/models')}>
          <ArrowLeft className="h-4 w-4" />
        </Button>
        <div>
          <h2 className="text-2xl font-bold tracking-tight">Tambah Model Baru</h2>
          <p className="text-muted-foreground">Unggah model klasifikasi ML baru.</p>
        </div>
      </div>

      <div className="p-6 border rounded-lg bg-white dark:bg-zinc-950">
        <ModelForm onSubmit={handleSubmit} isLoading={isLoading} />
      </div>
    </div>
  );
}
