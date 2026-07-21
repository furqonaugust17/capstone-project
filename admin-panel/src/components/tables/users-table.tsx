import { User } from '@/types';
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
import { Eye, Trash2 } from 'lucide-react';
import Link from 'next/link';
import { formatDate } from '@/lib/utils';
import { TableSkeleton } from '@/components/common/loading-spinner';
import { EmptyState } from '@/components/common/empty-state';
import { useRouter } from 'next/navigation';

interface UsersTableProps {
  users: User[];
  isLoading: boolean;
  onDelete: (id: string) => void;
}

export function UsersTable({ users, isLoading, onDelete }: UsersTableProps) {
  const router = useRouter();
  
  if (isLoading) {
    return <TableSkeleton rows={5} columns={6} />;
  }

  if (users.length === 0) {
    return (
      <EmptyState
        title="Pengguna tidak ditemukan"
        description="Coba sesuaikan filter atau kueri penelusuran Anda."
      />
    );
  }

  return (
    <div className="rounded-md border">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Pengguna</TableHead>
            <TableHead>Email</TableHead>
            <TableHead>Total Poin</TableHead>
            <TableHead>Bergabung</TableHead>
            <TableHead className="text-right">Aksi</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {users.map((user) => (
            <TableRow key={user.id}>
              <TableCell>
                <div className="flex flex-col">
                  <span className="font-medium">{user.displayName}</span>
                  <span className="text-xs text-muted-foreground">@{user.username}</span>
                </div>
              </TableCell>
              <TableCell>{user.email}</TableCell>
              <TableCell>{user.totalPoint}</TableCell>
              <TableCell>{formatDate(user.createdAt)}</TableCell>
              <TableCell className="text-right">
                <div className="flex justify-end gap-2">
                  <Button variant="ghost" size="icon" onClick={() => router.push(`/users/${user.id}`)}>
                    <Eye className="h-4 w-4 text-blue-500" />
                  </Button>
                  <Button variant="ghost" size="icon" onClick={() => onDelete(user.id)}>
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
