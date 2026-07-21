import { Loader2 } from 'lucide-react';
import { Skeleton } from '@/components/ui/skeleton';

export function LoadingSpinner({ text }: { text?: string }) {
  return (
    <div className="flex flex-col w-full items-center justify-center p-8 gap-3">
      <Loader2 className="h-8 w-8 animate-spin text-zinc-400" />
      {text && <p className="text-sm text-zinc-500">{text}</p>}
    </div>
  );
}

export function TableSkeleton({ rows = 5, columns = 4 }: { rows?: number; columns?: number }) {
  return (
    <div className="w-full space-y-3">
      <div className="flex items-center space-x-4 pb-4">
        {Array.from({ length: columns }).map((_, i) => (
          <Skeleton key={`header-${i}`} className="h-6 w-full" />
        ))}
      </div>
      {Array.from({ length: rows }).map((_, i) => (
        <div key={`row-${i}`} className="flex items-center space-x-4">
          {Array.from({ length: columns }).map((_, j) => (
            <Skeleton key={`cell-${i}-${j}`} className="h-10 w-full" />
          ))}
        </div>
      ))}
    </div>
  );
}
