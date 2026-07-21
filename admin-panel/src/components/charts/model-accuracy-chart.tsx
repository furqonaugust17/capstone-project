"use client";

import { useEffect, useState } from 'react';
import { Bar, BarChart, ResponsiveContainer, XAxis, YAxis, Tooltip, CartesianGrid } from 'recharts';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { useApi } from '@/hooks/use-api';
import { modelService } from '@/services/model.service';
import { Loader2 } from 'lucide-react';

export function ModelAccuracyChart() {
  const { data: rawData, isLoading, execute } = useApi(modelService.getModels);
  const [isMounted, setIsMounted] = useState(false);

  useEffect(() => {
    setIsMounted(true);
    // Fetch top 10 models
    execute({ limit: 10 });
  }, [execute]);

  // Format the data to use accuracy percentage
  const data = rawData?.data 
    ? rawData.data
        .filter(model => model.isActive)
        .map(model => ({
          name: model.name,
          score: Math.round(model.accuracy * 100) // Convert 0.95 -> 95
        }))
    : [];

  return (
    <Card>
      <CardHeader>
        <CardTitle>Model Accuracy</CardTitle>
        <CardDescription>Average prediction score per active model</CardDescription>
      </CardHeader>
      <CardContent>
        <div className="h-[300px] w-full flex items-center justify-center">
          {isLoading ? (
            <Loader2 className="h-8 w-8 animate-spin text-zinc-500" />
          ) : isMounted && data.length > 0 ? (
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={data}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#e5e7eb" />
                <XAxis dataKey="name" fontSize={12} tickLine={false} axisLine={false} />
                <YAxis fontSize={12} tickLine={false} axisLine={false} tickFormatter={(value) => `${value}%`} />
                <Tooltip cursor={{ fill: 'rgba(0,0,0,0.05)' }} contentStyle={{ borderRadius: '8px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)' }} />
                <Bar dataKey="score" fill="#3b82f6" radius={[4, 4, 0, 0]} />
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
