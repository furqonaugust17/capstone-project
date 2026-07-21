"use client";

import { useEffect, useState } from 'react';
import { Bar, BarChart, ResponsiveContainer, XAxis, YAxis, Tooltip, CartesianGrid } from 'recharts';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { useApi } from '@/hooks/use-api';
import { analyticsService } from '@/services/analytics.service';
import { Loader2 } from 'lucide-react';

export function FocusScoreChart() {
  const { data: rawData, isLoading, execute } = useApi(analyticsService.getFocusDistribution);
  const [isMounted, setIsMounted] = useState(false);

  useEffect(() => {
    setIsMounted(true);
    execute();
  }, [execute]);

  // Convert object distribution to array format expected by Recharts
  const data = rawData?.distribution 
    ? Object.entries(rawData.distribution).map(([range, count]) => ({
        range,
        count
      }))
    : [];

  return (
    <Card>
      <CardHeader>
        <CardTitle>Focus Score Distribution</CardTitle>
        <CardDescription>Number of sessions per focus score range</CardDescription>
      </CardHeader>
      <CardContent>
        <div className="h-[300px] w-full flex items-center justify-center">
          {isLoading ? (
            <Loader2 className="h-8 w-8 animate-spin text-zinc-500" />
          ) : isMounted && data.length > 0 ? (
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={data}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#e5e7eb" />
                <XAxis dataKey="range" fontSize={12} tickLine={false} axisLine={false} />
                <YAxis fontSize={12} tickLine={false} axisLine={false} />
                <Tooltip cursor={{ fill: 'rgba(0,0,0,0.05)' }} contentStyle={{ borderRadius: '8px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)' }} />
                <Bar dataKey="count" fill="#10b981" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          ) : (
            <div className="text-zinc-500">No data available</div>
          )}
        </div>
      </CardContent>
    </Card>
  );
}
