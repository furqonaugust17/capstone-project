"use client";

import { useState, useEffect } from 'react';
import { Sidebar } from './sidebar';
import { Header } from './header';
import { cn } from '@/lib/utils';

export function MainLayout({ children }: { children: React.ReactNode }) {
  const [mobileOpen, setMobileOpen] = useState(false);
  const [collapsed, setCollapsed] = useState(false);

  useEffect(() => {
    const handleStorageChange = () => {
      const saved = localStorage.getItem('sidebar_collapsed');
      if (saved) setCollapsed(saved === 'true');
    };
    
    // Check initial
    handleStorageChange();

    // Listen to changes (from Sidebar)
    window.addEventListener('storage', handleStorageChange);
    
    // Custom event since storage event only fires across tabs
    const interval = setInterval(handleStorageChange, 500);

    return () => {
      window.removeEventListener('storage', handleStorageChange);
      clearInterval(interval);
    };
  }, []);

  return (
    <div className="min-h-screen bg-zinc-50 dark:bg-zinc-900">
      <Sidebar mobileOpen={mobileOpen} setMobileOpen={setMobileOpen} />
      
      <div className={cn("transition-all duration-300 flex flex-col min-h-screen", collapsed ? 'md:pl-16' : 'md:pl-64')}>
        <Header setMobileOpen={setMobileOpen} />
        <main className="flex-1 p-4 md:p-6 overflow-x-hidden">
          {children}
        </main>
      </div>
    </div>
  );
}
