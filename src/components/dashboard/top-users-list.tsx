"use client";

import { useEffect, useState } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { leaderboardService } from '@/services/leaderboard.service';
import { LeaderboardEntry } from '@/types';
import { Trophy } from 'lucide-react';

export function TopUsersList() {
  const [users, setUsers] = useState<LeaderboardEntry[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchTopUsers = async () => {
      try {
        const response = await leaderboardService.getLive({ limit: 5 });
        setUsers(response || []);
      } catch (error) {
        console.error('Failed to fetch top users', error);
      } finally {
        setIsLoading(false);
      }
    };
    fetchTopUsers();
  }, []);

  return (
    <Card className="flex flex-col h-full">
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Trophy className="h-5 w-5 text-yellow-500" />
          Top Players
        </CardTitle>
        <CardDescription>Players with the highest total points.</CardDescription>
      </CardHeader>
      <CardContent className="flex-1">
        {isLoading ? (
          <div className="flex h-full items-center justify-center">
            <div className="h-8 w-8 animate-spin rounded-full border-b-2 border-primary" />
          </div>
        ) : users.length > 0 ? (
          <div className="space-y-6">
            {users.map((user, index) => (
              <div key={user.userId} className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="flex h-8 w-8 items-center justify-center rounded-full bg-muted font-bold text-sm text-muted-foreground">
                    {index + 1}
                  </div>
                  <Avatar className="h-9 w-9">
                    <AvatarImage src={user.avatarUrl || ''} alt={user.username} />
                    <AvatarFallback>{(user.displayName || user.username).charAt(0).toUpperCase()}</AvatarFallback>
                  </Avatar>
                  <div className="flex flex-col">
                    <span className="text-sm font-medium leading-none">{user.displayName || user.username}</span>
                    <span className="text-xs text-muted-foreground">@{user.username}</span>
                  </div>
                </div>
                <div className="font-medium text-sm">
                  {(user.totalScore || 0).toLocaleString()} pts
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="flex h-full items-center justify-center text-muted-foreground">
            No players found
          </div>
        )}
      </CardContent>
    </Card>
  );
}
