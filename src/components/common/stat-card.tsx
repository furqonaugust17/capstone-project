import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { LucideIcon } from 'lucide-react';
import { cn } from '@/lib/utils';

interface StatCardProps {
  title: string;
  value: string | number;
  icon: LucideIcon;
  trend?: {
    value: number;
    label: string;
  };
  isLoading?: boolean;
}

export function StatCard({ title, value, icon: Icon, trend, isLoading }: StatCardProps) {
  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
        <CardTitle className="text-sm font-medium text-zinc-500 dark:text-zinc-400">
          {title}
        </CardTitle>
        <Icon className="h-4 w-4 text-zinc-400" />
      </CardHeader>
      <CardContent>
        {isLoading ? (
          <div className="h-8 w-24 animate-pulse rounded bg-zinc-200 dark:bg-zinc-800" />
        ) : (
          <>
            <div className="text-2xl font-bold">{value}</div>
            {trend && (
              <p className="mt-1 text-xs text-zinc-500 dark:text-zinc-400">
                <span
                  className={cn(
                    "font-medium",
                    trend.value > 0 ? "text-emerald-500" : trend.value < 0 ? "text-red-500" : ""
                  )}
                >
                  {trend.value > 0 ? "+" : ""}
                  {trend.value}%
                </span>{" "}
                {trend.label}
              </p>
            )}
          </>
        )}
      </CardContent>
    </Card>
  );
}
