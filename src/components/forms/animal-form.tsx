"use client";

import { useState, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { Animal } from '@/types';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
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
import { Loader2, ImageOff } from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';

const formSchema = z.object({
  name: z.string().min(2, 'Nama minimal 2 karakter').max(100),
  description: z.string().max(500).optional().nullable(),
  difficulty: z.enum(['easy', 'medium', 'hard']),
  funFact: z.string().max(500).optional().nullable(),
  drawingTips: z.array(z.string()).max(3, "Maksimal 3 tips menggambar").optional().nullable(),
  thumbnail: z.any().optional(),
  hintImage: z.any().optional(),
  traceImage: z.any().optional(),
  is_active: z.boolean().default(true),
});

type AnimalFormValues = z.infer<typeof formSchema>;

interface AnimalFormProps {
  initialData?: Partial<Animal>;
  onSubmit: (data: AnimalFormValues) => Promise<void>;
  isLoading: boolean;
  isEditMode?: boolean;
}

export function AnimalForm({ initialData, onSubmit, isLoading, isEditMode }: AnimalFormProps) {
  const [thumbnailPreview, setThumbnailPreview] = useState<string | null>(initialData?.thumbnailUrl || null);
  const [hintImagePreview, setHintImagePreview] = useState<string | null>(initialData?.hintImageUrl || null);
  const [traceImagePreview, setTraceImagePreview] = useState<string | null>(initialData?.traceImageUrl || null);

  useEffect(() => {
    return () => {
      [thumbnailPreview, hintImagePreview, traceImagePreview].forEach((p) => {
        if (p && p.startsWith('blob:')) URL.revokeObjectURL(p);
      });
    };
  }, [thumbnailPreview, hintImagePreview, traceImagePreview]);

  const form = useForm<AnimalFormValues>({
    resolver: zodResolver(formSchema) as any,
    defaultValues: {
      name: initialData?.name || '',
      description: initialData?.description || '',
      funFact: initialData?.funFact || '',
      drawingTips: initialData?.drawingTips?.length ? [...initialData.drawingTips, '', '', ''].slice(0, 3) : ['', '', ''],
      difficulty: (initialData?.difficulty as any) || 'easy',
      thumbnail: undefined,
      hintImage: undefined,
      traceImage: undefined,
      is_active: initialData?.isActive ?? true,
    } as any,
  });

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit((data) => {
        const sanitizedData = {
          ...data,
          drawingTips: data.drawingTips?.filter((tip) => tip && tip.trim() !== '') || [],
        };
        return onSubmit(sanitizedData as any);
      })} className="space-y-8">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="space-y-6">
            <FormField
              control={form.control as any}
              name="name"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Nama Hewan</FormLabel>
                  <FormControl>
                    <Input placeholder="mis. Gajah" {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control as any}
              name="description"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Deskripsi</FormLabel>
                  <FormControl>
                    <Textarea
                      placeholder="Deskripsi singkat tentang hewan"
                      className="resize-none h-24"
                      {...field}
                      value={field.value || ''}
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control as any}
              name="funFact"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Fakta Menarik</FormLabel>
                  <FormControl>
                    <Textarea
                      placeholder="Fakta menarik tentang hewan ini"
                      className="resize-none h-20"
                      {...field}
                      value={field.value || ''}
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <div className="space-y-4">
              <FormLabel>Tips Menggambar (Maks 3)</FormLabel>
              {[0, 1, 2].map((index) => (
                <FormField
                  key={index}
                  control={form.control as any}
                  name={`drawingTips.${index}`}
                  render={({ field }) => (
                    <FormItem>
                      <FormControl>
                        <Input placeholder={`Tip ${index + 1}`} {...field} value={field.value || ''} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              ))}
            </div>

            <FormField
              control={form.control as any}
              name="difficulty"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Tingkat Kesulitan</FormLabel>
                  <Select onValueChange={field.onChange} defaultValue={field.value}>
                    <FormControl>
                      <SelectTrigger>
                        <SelectValue placeholder="Pilih tingkat kesulitan" />
                      </SelectTrigger>
                    </FormControl>
                    <SelectContent>
                      <SelectItem value="easy">Mudah</SelectItem>
                      <SelectItem value="medium">Sedang</SelectItem>
                      <SelectItem value="hard">Sulit</SelectItem>
                    </SelectContent>
                  </Select>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control as any}
              name="is_active"
              render={({ field }) => (
                <FormItem className="flex flex-row items-center justify-between rounded-lg border p-4">
                  <div className="space-y-0.5">
                    <FormLabel className="text-base">Status Aktif</FormLabel>
                    <FormDescription>
                      Apakah hewan ini tersedia untuk dimainkan di dalam permainan?
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

          <div className="space-y-6">
            <Card>
              <CardContent className="pt-6 space-y-4">
                <FormField
                  control={form.control as any}
                  name="thumbnail"
                  render={({ field: { value, onChange, ...fieldProps } }) => (
                    <FormItem>
                      <FormLabel>Gambar Thumbnail</FormLabel>
                      <FormControl>
                        <Input
                          {...fieldProps}
                          type="file"
                          accept="image/svg+xml"
                          onChange={(e) => {
                            const file = e.target.files?.[0];
                            if (file) {
                              onChange(file);
                              setThumbnailPreview(URL.createObjectURL(file));
                            } else {
                              onChange(undefined);
                              setThumbnailPreview(initialData?.thumbnailUrl || null);
                            }
                          }}
                        />
                      </FormControl>
                      <FormMessage />
                      {thumbnailPreview ? (
                        <div className="mt-2 h-32 w-32 rounded-md overflow-hidden bg-zinc-100 border flex items-center justify-center">
                          <img
                            src={thumbnailPreview}
                            alt="Thumbnail preview"
                            className="object-cover h-full w-full"
                          />
                        </div>
                      ) : (
                        <div className="mt-2 h-32 w-32 rounded-md border flex items-center justify-center text-zinc-400">
                          <ImageOff className="h-6 w-6 mb-1" />
                        </div>
                      )}
                    </FormItem>
                  )}
                />

                <FormField
                  control={form.control as any}
                  name="hintImage"
                  render={({ field: { value, onChange, ...fieldProps } }) => (
                    <FormItem>
                      <FormLabel>Gambar Petunjuk</FormLabel>
                      <FormControl>
                        <Input
                          {...fieldProps}
                          type="file"
                          accept="image/png,image/jpeg,image/svg+xml"
                          onChange={(e) => {
                            const file = e.target.files?.[0];
                            if (file) {
                              onChange(file);
                              setHintImagePreview(URL.createObjectURL(file));
                            } else {
                              onChange(undefined);
                              setHintImagePreview(initialData?.hintImageUrl || null);
                            }
                          }}
                        />
                      </FormControl>
                      <FormMessage />
                      {hintImagePreview ? (
                        <div className="mt-2 h-32 w-32 rounded-md overflow-hidden bg-zinc-100 border flex items-center justify-center">
                          <img
                            src={hintImagePreview}
                            alt="Hint preview"
                            className="object-contain h-full w-full p-2"
                          />
                        </div>
                      ) : (
                        <div className="mt-2 h-32 w-32 rounded-md border flex items-center justify-center text-zinc-400">
                          <ImageOff className="h-6 w-6 mb-1" />
                        </div>
                      )}
                    </FormItem>
                  )}
                />

                <FormField
                  control={form.control as any}
                  name="traceImage"
                  render={({ field: { value, onChange, ...fieldProps } }) => (
                    <FormItem>
                      <FormLabel>Gambar Garis Bentuk</FormLabel>
                      <FormControl>
                        <Input
                          {...fieldProps}
                          type="file"
                          accept="image/png,image/jpeg,image/svg+xml"
                          onChange={(e) => {
                            const file = e.target.files?.[0];
                            if (file) {
                              onChange(file);
                              setTraceImagePreview(URL.createObjectURL(file));
                            } else {
                              onChange(undefined);
                              setTraceImagePreview(initialData?.traceImageUrl || null);
                            }
                          }}
                        />
                      </FormControl>
                      <FormMessage />
                      {traceImagePreview ? (
                        <div className="mt-2 h-32 w-32 rounded-md overflow-hidden bg-zinc-100 border flex items-center justify-center">
                          <img
                            src={traceImagePreview}
                            alt="Trace preview"
                            className="object-contain h-full w-full p-2"
                          />
                        </div>
                      ) : (
                        <div className="mt-2 h-32 w-32 rounded-md border flex items-center justify-center text-zinc-400">
                          <ImageOff className="h-6 w-6 mb-1" />
                        </div>
                      )}
                    </FormItem>
                  )}
                />
              </CardContent>
            </Card>
          </div>
        </div>

        <div className="flex justify-end gap-4">
          <Button type="button" variant="outline" onClick={() => window.history.back()}>
            Batal
          </Button>
          <Button type="submit" disabled={isLoading}>
            {isLoading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
            {isEditMode ? 'Simpan Perubahan' : 'Tambah Hewan'}
          </Button>
        </div>
      </form>
    </Form>
  );
}
