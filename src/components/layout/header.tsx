"use client";

import { usePathname } from 'next/navigation';
import { Menu } from 'lucide-react';
import { UserMenu } from '@/components/common/user-menu';
import { ThemeToggle } from '@/components/common/theme-toggle';
import { Button } from '@/components/ui/button';

export function Header({ setMobileOpen }: { setMobileOpen: (o: boolean) => void }) {
  const pathname = usePathname();

  // Simple breadcrumbs generation based on pathname
  const generateBreadcrumbs = () => {
    const paths = pathname.split('/').filter(Boolean);
    if (paths.length === 0) return 'Dashboard';
    
    const translateMap: Record<string, string> = {
      'users': 'Pengguna',
      'animals': 'Hewan',
      'models': 'Model AI',
      'game-sessions': 'Sesi Permainan',
      'shop': 'Toko',
      'statistics': 'Statistik',
      'leaderboard': 'Papan Peringkat',
      'new': 'Baru',
    };
    
    return paths.map((p) => {
      if (translateMap[p]) return translateMap[p];
      return p.charAt(0).toUpperCase() + p.slice(1).replace('-', ' ');
    }).join(' / ');
  };

  return (
    <header className="sticky top-0 z-30 flex h-16 w-full items-center justify-between border-b border-zinc-200 bg-white px-4 dark:border-zinc-800 dark:bg-zinc-950">
      <div className="flex items-center gap-4">
        <Button
          variant="ghost"
          size="icon"
          className="md:hidden"
          onClick={() => setMobileOpen(true)}
        >
          <Menu className="h-5 w-5" />
          <span className="sr-only">Toggle Navigasi</span>
        </Button>
        <h1 className="text-lg font-semibold capitalize hidden sm:block">
          {generateBreadcrumbs()}
        </h1>
      </div>

      <div className="flex items-center gap-4">
        <ThemeToggle />
        <UserMenu />
      </div>
    </header>
  );
}
