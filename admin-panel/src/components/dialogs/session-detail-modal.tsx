import { useEffect, useState } from 'react';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { gameSessionService } from '@/services/game-session.service';
import { GameSession } from '@/types';
import { toast } from 'sonner';
import { formatDate } from '@/lib/utils';
import { Badge } from '@/components/ui/badge';
import Link from 'next/link';

interface SessionDetailModalProps {
  sessionId: string | null;
  onClose: () => void;
}

export function SessionDetailModal({ sessionId, onClose }: SessionDetailModalProps) {
  const [session, setSession] = useState<GameSession | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    if (sessionId) {
      fetchSession(sessionId);
    } else {
      setSession(null);
    }
  }, [sessionId]);

  const fetchSession = async (id: string) => {
    setIsLoading(true);
    try {
      const data = await gameSessionService.getSessionById(id);
      setSession(data);
    } catch (error) {
      toast.error('Gagal memuat detail sesi');
      onClose();
    } finally {
      setIsLoading(false);
    }
  };

  const formatDuration = (seconds: number) => {
    const m = Math.floor(seconds / 60);
    const s = Math.floor(seconds % 60);
    return `${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
  };

  return (
    <Dialog open={!!sessionId} onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="sm:max-w-[500px]">
        <DialogHeader>
          <DialogTitle>Detail Sesi Permainan</DialogTitle>
          <DialogDescription>
            Analisis detail dari sesi menggambar.
          </DialogDescription>
        </DialogHeader>

        <div className="py-4">
          {isLoading ? (
            <div className="flex justify-center items-center py-8">Memuat...</div>
          ) : session ? (
            <div className="space-y-6">
              <div className="grid grid-cols-2 gap-4 text-sm">
                <div>
                  <span className="text-muted-foreground block mb-1">User</span>
                  {session.user ? (
                    <Link href={`/users/${session.user.id}`} className="font-medium text-blue-600 dark:text-blue-400 hover:underline">
                      {session.user.username}
                    </Link>
                  ) : (
                    'Tidak diketahui'
                  )}
                </div>
                <div>
                  <span className="text-muted-foreground block mb-1">Tanggal Dimainkan</span>
                  <span className="font-medium">{formatDate(session.startedAt)}</span>
                </div>
                <div>
                  <span className="text-muted-foreground block mb-1">Hewan</span>
                  <span className="font-medium">{session.animal?.name || 'Tidak diketahui'}</span>
                </div>
                <div>
                  <span className="text-muted-foreground block mb-1">Model Digunakan</span>
                  <span className="font-medium">
                    {session.model?.name} {session.model?.version ? `(v${session.model.version})` : ''}
                  </span>
                </div>
              </div>

              <div className="border-t dark:border-zinc-800 pt-4">
                <h4 className="text-sm font-semibold mb-3">Hasil Prediksi</h4>
                <div className="grid grid-cols-2 gap-4 text-sm bg-zinc-50 dark:bg-zinc-900 p-3 rounded-md border border-transparent dark:border-zinc-800">
                  <div>
                    <span className="text-muted-foreground block mb-1">Label</span>
                    <Badge variant={session.predictionLabel.toLowerCase() === session.animal?.name.toLowerCase() ? 'default' : 'destructive'}>
                      {session.predictionLabel}
                    </Badge>
                  </div>
                  <div>
                    <span className="text-muted-foreground block mb-1">Kepercayaan</span>
                    <span className="font-medium">{Math.round(session.confidenceScore * 100)}%</span>
                  </div>
                </div>
              </div>

              <div className="border-t dark:border-zinc-800 pt-4">
                <h4 className="text-sm font-semibold mb-3">Skor & Performa</h4>
                <div className="space-y-2 text-sm bg-zinc-50 dark:bg-zinc-900 p-3 rounded-md border border-transparent dark:border-zinc-800">
                  <div className="flex justify-between items-center">
                    <span className="text-muted-foreground">Durasi Menggambar</span>
                    <span className="font-medium">{formatDuration(session.drawingDuration)}</span>
                  </div>
                  <div className="flex justify-between items-center">
                    <span className="text-muted-foreground">Skor Fokus</span>
                    <span className="font-medium">{Math.round(session.focusScore)}%</span>
                  </div>
                  <div className="flex justify-between items-center pt-2 border-t dark:border-zinc-800 font-semibold text-base mt-2">
                    <span>Total Skor Permainan</span>
                    <span className="text-primary">{session.gameScore}</span>
                  </div>
                </div>
              </div>
            </div>
          ) : (
            <div className="text-center text-muted-foreground py-8">Sesi tidak ditemukan</div>
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
}
