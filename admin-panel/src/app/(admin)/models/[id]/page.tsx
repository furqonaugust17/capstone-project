"use client";

import { useEffect } from 'react';
import { useRouter, useParams } from 'next/navigation';
import { modelService } from '@/services/model.service';
import { useApi } from '@/hooks/use-api';
import { ModelForm } from '@/components/forms/model-form';
import { Button } from '@/components/ui/button';
import { ArrowLeft } from 'lucide-react';
import { LoadingSpinner } from '@/components/common/loading-spinner';

export default function EditModelPage() {
  const router = useRouter();
  const params = useParams();
  const id = params.id as string;

  const { data: model, isLoading: isFetching, execute: fetchModel } = useApi(modelService.getModelById);

  const { execute: updateModel, isLoading: isUpdating } = useApi(modelService.updateModel, {
    successMessage: 'Model berhasil diperbarui',
    onSuccess: () => {
      router.push('/models');
    }
  });

  useEffect(() => {
    if (id) {
      fetchModel(id);
    }
  }, [id, fetchModel]);

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
    await updateModel(id, formData);
  };

  if (isFetching) {
    return <LoadingSpinner />;
  }

  if (!model) {
    return <div className="p-8 text-center">Model tidak ditemukan</div>;
  }

  return (
    <div className="space-y-6 max-w-4xl">
      <div className="flex items-center gap-4">
        <Button variant="ghost" size="icon" onClick={() => router.push('/models')}>
          <ArrowLeft className="h-4 w-4" />
        </Button>
        <div>
          <h2 className="text-2xl font-bold tracking-tight">Edit Model</h2>
          <p className="text-muted-foreground">Perbarui detail untuk model {model.name} v{model.version}.</p>
        </div>
      </div>

      <div className="p-6 border rounded-lg bg-white dark:bg-zinc-950">
        <ModelForm
          initialData={model}
          onSubmit={handleSubmit}
          isLoading={isUpdating}
          isEditMode
        />
      </div>
    </div>
  );
}
