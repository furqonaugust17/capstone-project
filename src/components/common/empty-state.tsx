import { FileQuestion } from 'lucide-react';

interface EmptyStateProps {
  title: string;
  description: string;
  action?: React.ReactNode;
}

export function EmptyState({ title, description, action }: EmptyStateProps) {
  return (
    <div className="flex flex-col items-center justify-center p-8 text-center bg-zinc-50 border border-dashed rounded-lg dark:bg-zinc-900/50 dark:border-zinc-800">
      <div className="flex h-20 w-20 items-center justify-center rounded-full bg-zinc-100 dark:bg-zinc-800 mb-4">
        <FileQuestion className="h-10 w-10 text-zinc-400" />
      </div>
      <h3 className="mb-1 text-lg font-semibold">{title}</h3>
      <p className="mb-4 text-sm text-zinc-500 max-w-sm">{description}</p>
      {action && <div>{action}</div>}
    </div>
  );
}
