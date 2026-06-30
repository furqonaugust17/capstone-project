"use client";

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { cn } from '@/lib/utils';
import {
  LayoutDashboard,
  Users,
  Cat,
  Cpu,
  Gamepad2,
  ShoppingBag,
  BarChart3,
  Medal,
  ChevronLeft,
  Menu,
} from 'lucide-react';
import { useState, useEffect } from 'react';

const navItems = [
  { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
  { name: 'Pengguna', href: '/users', icon: Users },
  { name: 'Hewan', href: '/animals', icon: Cat },
  { name: 'Model AI', href: '/models', icon: Cpu },
  { name: 'Sesi Permainan', href: '/game-sessions', icon: Gamepad2 },
  { name: 'Toko', href: '/shop', icon: ShoppingBag },
  { name: 'Statistik', href: '/statistics', icon: BarChart3 },
  { name: 'Papan Peringkat', href: '/leaderboard', icon: Medal },
];

export function Sidebar({ mobileOpen, setMobileOpen }: { mobileOpen: boolean; setMobileOpen: (o: boolean) => void }) {
  const pathname = usePathname();
  const [collapsed, setCollapsed] = useState(false);

  useEffect(() => {
    const saved = localStorage.getItem('sidebar_collapsed');
    if (saved) setCollapsed(saved === 'true');
  }, []);

  const toggleCollapsed = () => {
    const newVal = !collapsed;
    setCollapsed(newVal);
    localStorage.setItem('sidebar_collapsed', newVal.toString());
  };

  const content = (
    <div className="flex h-full flex-col bg-zinc-950 text-zinc-50 transition-all duration-300">
      <div className="flex h-16 items-center justify-between px-4 border-b border-zinc-800">
        {!collapsed && (
          <Link href="/dashboard" className="text-lg font-bold tracking-tight text-white flex items-center gap-2">
            <Cat className="h-6 w-6 text-blue-500" />
            <span className="truncate">AniDraw Admin</span>
          </Link>
        )}
        {collapsed && (
          <Cat className="h-6 w-6 text-blue-500 mx-auto" />
        )}
        <button onClick={toggleCollapsed} className="hidden md:block p-1 hover:bg-zinc-800 rounded">
          {collapsed ? <Menu className="h-4 w-4" /> : <ChevronLeft className="h-4 w-4" />}
        </button>
      </div>

      <div className="flex-1 overflow-y-auto py-4">
        <nav className="space-y-1 px-2">
          {navItems.map((item) => {
            const isActive = pathname.startsWith(item.href);
            return (
              <Link
                key={item.name}
                href={item.href}
                className={cn(
                  'flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors',
                  isActive
                    ? 'bg-blue-600 text-white'
                    : 'text-zinc-400 hover:bg-zinc-800 hover:text-white',
                  collapsed && 'justify-center px-0 py-3'
                )}
                title={collapsed ? item.name : undefined}
                onClick={() => setMobileOpen(false)}
              >
                <item.icon className={cn('h-5 w-5 flex-shrink-0', isActive ? 'text-white' : 'text-zinc-400 group-hover:text-white')} />
                {!collapsed && <span className="truncate">{item.name}</span>}
              </Link>
            );
          })}
        </nav>
      </div>
    </div>
  );

  return (
    <>
      {/* Desktop Sidebar */}
      <aside className={cn('hidden md:block h-screen fixed top-0 left-0 z-40 transition-all duration-300', collapsed ? 'w-16' : 'w-64')}>
        {content}
      </aside>

      {/* Mobile Sidebar overlay */}
      {mobileOpen && (
        <div className="fixed inset-0 z-40 md:hidden bg-black/80" onClick={() => setMobileOpen(false)}>
          <aside className="fixed inset-y-0 left-0 w-64 max-w-[80%] bg-zinc-950 shadow-xl" onClick={(e) => e.stopPropagation()}>
            {content}
          </aside>
        </div>
      )}
    </>
  );
}
