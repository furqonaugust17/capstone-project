import { Animal } from '@/types';
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
import { Edit2, Trash2 } from 'lucide-react';
import Link from 'next/link';
import { formatDate, truncateText } from '@/lib/utils';
import { TableSkeleton } from '@/components/common/loading-spinner';
import { EmptyState } from '@/components/common/empty-state';
import { useRouter } from 'next/navigation';
import Image from 'next/image';

interface AnimalsTableProps {
  animals: Animal[];
  isLoading: boolean;
  onDelete: (id: string) => void;
}

export function AnimalsTable({ animals, isLoading, onDelete }: AnimalsTableProps) {
  const router = useRouter();

  if (isLoading) {
    return <TableSkeleton rows={5} columns={6} />;
  }

  if (animals.length === 0) {
    return (
      <EmptyState
        title="Hewan tidak ditemukan"
        description="Coba sesuaikan filter atau kueri penelusuran Anda."
      />
    );
  }

  return (
    <div className="rounded-md border">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead className="w-20">Pratinjau</TableHead>
            <TableHead>Hewan</TableHead>
            <TableHead>Status</TableHead>
            <TableHead>Dibuat Pada</TableHead>
            <TableHead className="text-right">Aksi</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {animals.map((animal) => (
            <TableRow key={animal.id}>
              <TableCell>
                <div className="h-12 w-12 rounded-md bg-zinc-100 overflow-hidden relative">
                  {animal.thumbnailUrl ? (
                    <img
                      src={animal.thumbnailUrl}
                      alt={animal.name}
                      className="h-full w-full object-cover"
                    />
                  ) : (
                    <div className="flex h-full w-full items-center justify-center text-xs text-zinc-400">
                      N/A
                    </div>
                  )}
                </div>
              </TableCell>
              <TableCell>
                <div className="flex flex-col">
                  <span className="font-medium">{animal.name}</span>
                  <span className="text-xs text-muted-foreground">{truncateText(animal.description || '', 50)}</span>
                </div>
              </TableCell>
              <TableCell>
                <Badge variant={animal.isActive ? 'outline' : 'secondary'} className={animal.isActive ? 'border-green-500 text-green-500' : ''}>
                  {animal.isActive ? 'Aktif' : 'Tidak Aktif'}
                </Badge>
              </TableCell>
              <TableCell>{formatDate(animal.createdAt)}</TableCell>
              <TableCell className="text-right">
                <div className="flex justify-end gap-2">
                  <Button variant="ghost" size="icon" onClick={() => router.push(`/animals/${animal.id}`)}>
                    <Edit2 className="h-4 w-4 text-blue-500" />
                  </Button>
                  <Button variant="ghost" size="icon" onClick={() => onDelete(animal.id.toString())}>
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
