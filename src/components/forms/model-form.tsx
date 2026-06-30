"use client";

import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { MLModel } from '@/types';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Switch } from '@/components/ui/switch';
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Loader2 } from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';

const formSchema = z.object({
  name: z.string().min(2, 'Nama minimal 2 karakter').max(100),
  version: z.string().min(1, 'Versi wajib diisi'),
  file: z.any().optional(), // For file upload
  framework: z.enum(['tflite', 'h5', 'pb']),
  accuracy: z.number().min(0).max(1).optional().nullable(),
  is_active: z.boolean().default(false),
});

type ModelFormValues = z.infer<typeof formSchema>;

interface ModelFormProps {
  initialData?: Partial<MLModel>;
  onSubmit: (data: ModelFormValues) => Promise<void>;
  isLoading: boolean;
  isEditMode?: boolean;
}

export function ModelForm({ initialData, onSubmit, isLoading, isEditMode }: ModelFormProps) {
  const form = useForm<ModelFormValues>({
    resolver: zodResolver(formSchema) as any,
    defaultValues: {
      name: initialData?.name || '',
      version: initialData?.version || '',
      framework: (initialData?.framework as any) || 'tflite',
      accuracy: initialData?.accuracy || undefined,
      is_active: initialData?.isActive ?? false,
    } as any,
  });

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit as any)} className="space-y-8">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="space-y-6">
            <FormField
              control={form.control as any}
              name="name"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Nama Model</FormLabel>
                  <FormControl>
                    <Input placeholder="mis. Klasifikasi Utama" {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control as any}
              name="version"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Versi</FormLabel>
                  <FormControl>
                    <Input placeholder="mis. 1.0.0" {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control as any}
              name="framework"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Framework Model</FormLabel>
                  <Select onValueChange={field.onChange} defaultValue={field.value}>
                    <FormControl>
                      <SelectTrigger>
                        <SelectValue placeholder="Pilih framework" />
                      </SelectTrigger>
                    </FormControl>
                    <SelectContent>
                      <SelectItem value="tflite">TFLite</SelectItem>
                      <SelectItem value="h5">H5 (Keras)</SelectItem>
                      <SelectItem value="pb">PB (TensorFlow)</SelectItem>
                    </SelectContent>
                  </Select>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control as any}
              name="accuracy"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Akurasi (0.0 - 1.0)</FormLabel>
                  <FormControl>
                    <Input
                      type="number"
                      step="0.01"
                      min="0"
                      max="1"
                      placeholder="mis. 0.95"
                      {...field}
                      onChange={(e) => field.onChange(e.target.value ? parseFloat(e.target.value) : undefined)}
                      value={field.value ?? ''}
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
          </div>

          <div className="space-y-6">
            <Card>
              <CardContent className="pt-6 space-y-4">
                <FormField
                  control={form.control as any}
                  name="file"
                  render={({ field: { value, onChange, ...fieldProps } }) => (
                    <FormItem>
                      <FormLabel>File Model (.tflite)</FormLabel>
                      <FormControl>
                        <Input
                          type="file"
                          accept=".tflite"
                          onChange={(e) => onChange(e.target.files && e.target.files.length > 0 ? e.target.files[0] : undefined)}
                          {...fieldProps}
                        />
                      </FormControl>
                      <FormDescription>
                        Unggah file model .tflite.
                      </FormDescription>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </CardContent>
            </Card>

            <FormField
              control={form.control as any}
              name="is_active"
              render={({ field }) => (
                <FormItem className="flex flex-row items-center justify-between rounded-lg border p-4 bg-zinc-50 dark:bg-zinc-900/50">
                  <div className="space-y-0.5">
                    <FormLabel className="text-base">Status Aktif</FormLabel>
                    <FormDescription>
                      Apakah ini model yang sedang aktif? Mengaktifkan ini akan menonaktifkan model lainnya secara otomatis.
                    </FormDescription>
                  </div>
                  <FormControl>
                    <Switch
                      checked={field.value}
                      onCheckedChange={field.onChange}
                    />
                  </FormControl>
                </FormItem>
              )}
            />
          </div>
        </div>

        <div className="flex justify-end gap-4">
          <Button type="button" variant="outline" onClick={() => window.history.back()}>
            Batal
          </Button>
          <Button type="submit" disabled={isLoading}>
            {isLoading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
            {isEditMode ? 'Simpan Perubahan' : 'Unggah Model'}
          </Button>
        </div>
      </form>
    </Form>
  );
}
