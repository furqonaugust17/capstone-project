import React from 'react';

export default function AuthLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen w-full flex items-center justify-center bg-zinc-50 dark:bg-zinc-950 px-4">
      <div className="w-full max-w-md space-y-8">
        <div className="text-center">
          <h2 className="mt-6 text-3xl font-extrabold text-zinc-900 dark:text-white">
            Admin Panel
          </h2>
          <p className="mt-2 text-sm text-zinc-600 dark:text-zinc-400">
            Educational Animal Drawing Game
          </p>
        </div>
        {children}
      </div>
    </div>
  );
}
