"use client";

import { useEffect } from 'react';
import { useRouter, useParams } from 'next/navigation';
import { animalService } from '@/services/animal.service';
import { useApi } from '@/hooks/use-api';
import { AnimalForm } from '@/components/forms/animal-form';
import { Button } from '@/components/ui/button';
import { ArrowLeft } from 'lucide-react';
import { LoadingSpinner } from '@/components/common/loading-spinner';

export default function EditAnimalPage() {
  const router = useRouter();
  const params = useParams();
  const id = params.id as string;
  
  const { data: animal, isLoading: isFetching, execute: fetchAnimal } = useApi(animalService.getAnimalById);
  
  const { execute: updateAnimal, isLoading: isUpdating } = useApi(animalService.updateAnimal, {
    successMessage: 'Hewan berhasil diperbarui',
    onSuccess: () => {
      router.push('/animals');
    }
  });

  useEffect(() => {
    if (id) {
      fetchAnimal(id);
    }
  }, [id, fetchAnimal]);

  const handleSubmit = async (data: any) => {
    const formData = new FormData();
    Object.keys(data).forEach((key) => {
      const value = data[key];
      if (value !== undefined && value !== null) {
        if (key === 'drawingTips' && Array.isArray(value)) {
          value.forEach(tip => formData.append('drawingTips', tip));
        } else if (value instanceof File) {
          formData.append(key, value);
        } else {
          formData.append(key, value.toString());
        }
      }
    });
    await updateAnimal(id, formData as any);
  };

  if (isFetching) {
    return <LoadingSpinner />;
  }

  if (!animal) {
    return <div className="p-8 text-center">Hewan tidak ditemukan</div>;
  }

  return (
    <div className="space-y-6 max-w-4xl">
      <div className="flex items-center gap-4">
        <Button variant="ghost" size="icon" onClick={() => router.push('/animals')}>
          <ArrowLeft className="h-4 w-4" />
        </Button>
        <div>
          <h2 className="text-2xl font-bold tracking-tight">Edit Hewan</h2>
          <p className="text-muted-foreground">Perbarui detail untuk {animal.name}.</p>
        </div>
      </div>

      <div className="p-6 border rounded-lg bg-white dark:bg-zinc-950">
        <AnimalForm 
          initialData={animal} 
          onSubmit={handleSubmit} 
          isLoading={isUpdating} 
          isEditMode 
        />
      </div>
    </div>
  );
}
