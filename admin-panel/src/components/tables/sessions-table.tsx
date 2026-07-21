import { GameSession } from '@/types';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Button } from '@/components/ui/button';
import { Eye } from 'lucide-react';
import Link from 'next/link';
import { formatDate } from '@/lib/utils';
import { TableSkeleton } from '@/components/common/loading-spinner';
import { EmptyState } from '@/components/common/empty-state';
import { Badge } from '@/components/ui/badge';

interface SessionsTableProps {
  sessions: GameSession[];
  isLoading: boolean;
  onViewDetail: (id: string) => void;
}

export function SessionsTable({ sessions, isLoading, onViewDetail }: SessionsTableProps) {
  if (isLoading) {
    return <TableSkeleton rows={5} columns={8} />;
  }

  if (sessions.length === 0) {
    return (
      <EmptyState
        title="Sesi permainan tidak ditemukan"
        description="Coba sesuaikan filter atau kueri penelusuran Anda."
      />
    );
  }

  const formatDuration = (seconds: number) => {
    const m = Math.floor(seconds / 60);
    const s = Math.floor(seconds % 60);
    return `${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
  };

  return (
    <div className="rounded-md border">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Pengguna</TableHead>
            <TableHead>Hewan</TableHead>
            <TableHead>Model</TableHead>
            <TableHead>Skor</TableHead>
            <TableHead>Fokus</TableHead>
            <TableHead>Kepercayaan</TableHead>
            <TableHead>Durasi</TableHead>
            <TableHead>Tanggal</TableHead>
            <TableHead className="text-right">Aksi</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {sessions.map((session) => (
            <TableRow key={session.id}>
              <TableCell>
                {session.user ? (
                  <Link href={`/users/${session.user.id}`} className="font-medium text-blue-600 dark:text-blue-400 hover:underline">
                    {session.user.username}
                  </Link>
                ) : (
                  <span className="text-muted-foreground">Tidak diketahui</span>
                )}
              </TableCell>
              <TableCell>{session.animal?.name || 'Tidak diketahui'}</TableCell>
              <TableCell>
                <div className="flex flex-col">
                  <span>{session.model?.name || 'Tidak diketahui'}</span>
                  {session.model?.version && <span className="text-xs text-muted-foreground">v{session.model.version}</span>}
                </div>
              </TableCell>
              <TableCell>
                <Badge variant="secondary">{session.gameScore}</Badge>
              </TableCell>
              <TableCell>{Math.round(session.focusScore)}%</TableCell>
              <TableCell>{Math.round(session.confidenceScore * 100)}%</TableCell>
              <TableCell>{formatDuration(session.drawingDuration)}</TableCell>
              <TableCell>{formatDate(session.startedAt)}</TableCell>
              <TableCell className="text-right">
                <Button variant="ghost" size="icon" onClick={() => onViewDetail(session.id.toString())}>
                  <Eye className="h-4 w-4 text-blue-500" />
                </Button>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  );
}
