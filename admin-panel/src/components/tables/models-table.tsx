import { MLModel } from '@/types';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Edit2, Trash2, Power } from 'lucide-react';
import { formatDate } from '@/lib/utils';
import { TableSkeleton } from '@/components/common/loading-spinner';
import { EmptyState } from '@/components/common/empty-state';
import { useRouter } from 'next/navigation';

interface ModelsTableProps {
  models: MLModel[];
  isLoading: boolean;
  onDelete: (id: string) => void;
  onActivate: (id: string) => void;
}

export function ModelsTable({ models, isLoading, onDelete, onActivate }: ModelsTableProps) {
  const router = useRouter();

  if (isLoading) {
    return <TableSkeleton rows={5} columns={6} />;
  }

  if (models.length === 0) {
    return (
      <EmptyState
        title="Model ML tidak ditemukan"
        description="Coba sesuaikan filter atau kueri penelusuran Anda."
      />
    );
  }

  return (
    <div className="rounded-md border">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Nama Versi</TableHead>
            <TableHead>Framework</TableHead>
            <TableHead>Akurasi</TableHead>
            <TableHead>Status</TableHead>
            <TableHead>Diterapkan</TableHead>
            <TableHead className="text-right">Aksi</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {models.map((model) => (
            <TableRow key={model.id}>
              <TableCell>
                <div className="flex flex-col">
                  <span className="font-medium">{model.name}</span>
                  <span className="text-xs text-muted-foreground">v{model.version}</span>
                </div>
              </TableCell>
              <TableCell>
                <Badge variant="outline" className="uppercase text-xs">{model.framework}</Badge>
              </TableCell>
              <TableCell>
                {model.accuracy ? `${(model.accuracy * 100).toFixed(1)}%` : 'N/A'}
              </TableCell>
              <TableCell>
                <Badge variant={model.isActive ? 'outline' : 'secondary'} className={model.isActive ? 'border-green-500 text-green-500' : ''}>
                  {model.isActive ? 'Aktif' : 'Tidak Aktif'}
                </Badge>
              </TableCell>
              <TableCell>{formatDate(model.createdAt)}</TableCell>
              <TableCell className="text-right">
                <div className="flex justify-end gap-2">
                  {!model.isActive && (
                    <Button variant="ghost" size="icon" title="Aktifkan Model" onClick={() => onActivate(model.id.toString())}>
                      <Power className="h-4 w-4 text-green-500" />
                    </Button>
                  )}
                  <Button variant="ghost" size="icon" onClick={() => router.push(`/models/${model.id}`)}>
                    <Edit2 className="h-4 w-4 text-blue-500" />
                  </Button>
                  <Button variant="ghost" size="icon" onClick={() => onDelete(model.id.toString())}>
                    <Trash2 className="h-4 w-4 text-red-500" />
                  </Button>
                </div>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  );
}
