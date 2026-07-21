import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { LeaderboardEntry } from '@/types';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Medal, TrendingUp } from 'lucide-react';
import Link from 'next/link';
import { cn } from '@/lib/utils';
import { Skeleton } from '@/components/ui/skeleton';

interface LeaderboardTableProps {
  entries: LeaderboardEntry[];
  isLoading: boolean;
}

export function LeaderboardTable({ entries, isLoading }: LeaderboardTableProps) {
  if (isLoading) {
    return (
      <div className="border rounded-md">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead className="w-[60px]">Peringkat</TableHead>
              <TableHead>Pemain</TableHead>
              <TableHead className="w-[120px] text-right">Total Skor</TableHead>
              <TableHead className="w-[100px] text-right">Permainan</TableHead>
              <TableHead className="w-[100px] text-right">Tertinggi</TableHead>
              <TableHead className="w-[80px] text-right">Fokus Rata-rata</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {Array.from({ length: 5 }).map((_, index) => (
              <TableRow key={index}>
                <TableCell><Skeleton className="h-6 w-6 rounded-full" /></TableCell>
                <TableCell>
                  <div className="flex items-center gap-3">
                    <Skeleton className="h-8 w-8 rounded-full" />
                    <div className="space-y-2">
                      <Skeleton className="h-4 w-[100px]" />
                      <Skeleton className="h-3 w-[80px]" />
                    </div>
                  </div>
                </TableCell>
                <TableCell className="text-right"><Skeleton className="h-5 w-[60px] ml-auto" /></TableCell>
                <TableCell className="text-right"><Skeleton className="h-4 w-[50px] ml-auto" /></TableCell>
                <TableCell className="text-right"><Skeleton className="h-4 w-[50px] ml-auto" /></TableCell>
                <TableCell className="text-right"><Skeleton className="h-5 w-[40px] ml-auto" /></TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    );
  }

  if (!entries || entries.length === 0) {
    return (
      <div className="border rounded-md py-12 flex flex-col items-center justify-center text-zinc-500">
        <Medal className="h-12 w-12 text-zinc-300 mb-4" />
        <p>Tidak ada data papan peringkat yang tersedia.</p>
        <p className="text-sm">Buat snapshot atau tunggu pemain mengirimkan skor.</p>
      </div>
    );
  }

  // Calculate average of highest scores to determine when to show TrendingUp icon
  const validEntries = entries.filter(e => typeof e.highestScore === 'number');
  const avgOfHighestScores = validEntries.length > 0 
    ? validEntries.reduce((acc, curr) => acc + curr.highestScore, 0) / validEntries.length 
    : 0;

  return (
    <div className="border rounded-md bg-white dark:bg-zinc-950">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead className="w-[60px] text-center">Peringkat</TableHead>
            <TableHead>Pemain</TableHead>
            <TableHead className="w-[120px] text-right">Total Skor</TableHead>
            <TableHead className="w-[100px] text-right">Permainan</TableHead>
            <TableHead className="w-[100px] text-right">Tertinggi</TableHead>
            <TableHead className="w-[80px] text-right">Fokus Rata-rata</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {entries.map((entry) => {
            const isRank1 = entry.rank === 1;
            const isRank2 = entry.rank === 2;
            const isRank3 = entry.rank === 3;
            const totalScore = entry.totalScore ?? 0;
            const totalGames = entry.totalGames ?? 0;
            const highestScore = entry.highestScore ?? 0;
            const averageFocus = entry.averageFocus ?? 0;

            const focusPercentage = averageFocus * 100;
            let focusColor = 'text-green-600';
            if (focusPercentage < 50) focusColor = 'text-red-600';
            else if (focusPercentage < 80) focusColor = 'text-amber-600';

            return (
              <TableRow 
                key={entry.userId}
                className={cn(
                  "transition-colors",
                  isRank1 && "bg-amber-50/50 hover:bg-amber-100/50 dark:bg-amber-950/20 border-l-4 border-l-amber-500",
                  isRank2 && "bg-zinc-50 hover:bg-zinc-100/80 dark:bg-zinc-800/20 border-l-4 border-l-zinc-400",
                  isRank3 && "bg-orange-50/30 hover:bg-orange-100/50 dark:bg-orange-950/20 border-l-4 border-l-orange-600",
                  !isRank1 && !isRank2 && !isRank3 && "border-l-4 border-l-transparent"
                )}
              >
                <TableCell className="text-center font-medium">
                  {isRank1 && <span className="text-2xl" title="Rank 1">🥇</span>}
                  {isRank2 && <span className="text-2xl" title="Rank 2">🥈</span>}
                  {isRank3 && <span className="text-2xl" title="Rank 3">🥉</span>}
                  {!isRank1 && !isRank2 && !isRank3 && <span className="text-zinc-500">#{entry.rank}</span>}
                </TableCell>
                <TableCell>
                  <div className="flex items-center gap-3">
                    <Avatar className={cn("h-9 w-9", isRank1 && "h-10 w-10 border-2 border-amber-400")}>
                      <AvatarImage src={entry.avatarUrl || ''} />
                      <AvatarFallback className="bg-zinc-200 text-zinc-600">
                        {(entry.displayName || entry.username || 'U').charAt(0).toUpperCase()}
                      </AvatarFallback>
                    </Avatar>
                    <div className="flex flex-col">
                      <Link href={`/users/${entry.userId}`} className="font-semibold text-zinc-900 dark:text-zinc-100 hover:text-blue-600 dark:hover:text-blue-400 hover:underline">
                        {entry.username}
                      </Link>
                      {entry.displayName && (
                        <span className="text-xs text-zinc-500">{entry.displayName}</span>
                      )}
                    </div>
                  </div>
                </TableCell>
                <TableCell className="text-right">
                  <span className={cn(
                    "font-bold text-base",
                    isRank1 && "text-amber-700 dark:text-amber-500",
                    !isRank1 && "text-zinc-900 dark:text-zinc-100"
                  )}>
                    {totalScore.toLocaleString()}
                  </span>
                </TableCell>
                <TableCell className="text-right text-zinc-600">
                  {totalGames.toLocaleString()} <span className="text-xs text-zinc-400">permainan</span>
                </TableCell>
                <TableCell className="text-right text-zinc-600 flex items-center justify-end gap-1">
                  {highestScore > avgOfHighestScores && <TrendingUp className="h-3 w-3 text-green-500" />}
                  {highestScore.toLocaleString()}
                </TableCell>
                <TableCell className="text-right font-medium">
                  <span className={focusColor}>
                    {focusPercentage.toFixed(0)}%
                  </span>
                </TableCell>
              </TableRow>
            );
          })}
        </TableBody>
      </Table>
    </div>
  );
}
