"use client";

import { useRouter } from 'next/navigation';
import { animalService } from '@/services/animal.service';
import { useApi } from '@/hooks/use-api';
import { AnimalForm } from '@/components/forms/animal-form';
import { Button } from '@/components/ui/button';
import { ArrowLeft } from 'lucide-react';
import Link from 'next/link';

export default function CreateAnimalPage() {
  const router = useRouter();
  
  const { execute: createAnimal, isLoading } = useApi(animalService.createAnimal, {
    successMessage: 'Hewan berhasil ditambahkan',
    onSuccess: () => {
      router.push('/animals');
    }
  });

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
    await createAnimal(formData as any);
  };

  return (
    <div className="space-y-6 max-w-4xl">
      <div className="flex items-center gap-4">
        <Button variant="ghost" size="icon" onClick={() => router.push('/animals')}>
          <ArrowLeft className="h-4 w-4" />
        </Button>
        <div>
          <h2 className="text-2xl font-bold tracking-tight">Tambah Hewan Baru</h2>
          <p className="text-muted-foreground">Buat hewan baru untuk kamus permainan.</p>
        </div>
      </div>

      <div className="p-6 border rounded-lg bg-white dark:bg-zinc-950">
        <AnimalForm onSubmit={handleSubmit} isLoading={isLoading} />
      </div>
    </div>
  );
}
