"use client";

import { useEffect, useState } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Activity } from 'lucide-react';
import { gameSessionService } from '@/services/game-session.service';
import { GameSession } from '@/types';
import { formatDate } from '@/lib/utils';
import { Badge } from '@/components/ui/badge';
import Link from 'next/link';

export function RecentSessionsList() {
  const [sessions, setSessions] = useState<GameSession[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchRecentSessions = async () => {
      try {
        const response = await gameSessionService.getSessions({ limit: 5 });
        setSessions(response.data || []);
      } catch (error) {
        console.error('Failed to fetch recent sessions', error);
      } finally {
        setIsLoading(false);
      }
    };
    fetchRecentSessions();
  }, []);

  return (
    <Card className="flex flex-col h-full">
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Activity className="h-5 w-5 text-blue-500" />
          Recent Game Sessions
        </CardTitle>
        <CardDescription>Latest drawing sessions from all players.</CardDescription>
      </CardHeader>
      <CardContent className="flex-1">
        {isLoading ? (
          <div className="flex h-full items-center justify-center">
            <div className="h-8 w-8 animate-spin rounded-full border-b-2 border-primary" />
          </div>
        ) : sessions.length > 0 ? (
          <div className="space-y-6">
            {sessions.map((session) => (
              <div key={session.id} className="flex items-center justify-between border-b pb-4 last:border-0 last:pb-0">
                <div className="flex items-center gap-4">
                  <Avatar className="h-10 w-10">
                    <AvatarImage src={session.user?.avatarUrl || ''} alt={session.user?.username || 'User'} />
                    <AvatarFallback>{session.user?.displayName?.charAt(0).toUpperCase() || 'U'}</AvatarFallback>
                  </Avatar>
                  <div className="flex flex-col gap-1">
                    <span className="text-sm font-medium leading-none">
                      {session.user ? (
                        <Link href={`/users/${session.user.id}`} className="hover:underline">
                          {session.user.displayName}
                        </Link>
                      ) : (
                        'Unknown User'
                      )}
                    </span>
                    <span className="text-xs text-muted-foreground flex items-center gap-2">
                      <span>Drawn: {session.animal?.name || 'Unknown'}</span>
                      <span className="h-1 w-1 rounded-full bg-zinc-300 dark:bg-zinc-700"></span>
                      <span>Model: {session.model?.name}</span>
                    </span>
                  </div>
                </div>
                <div className="flex flex-col items-end gap-1">
                  <Badge variant={session.predictionLabel.toLowerCase() === session.animal?.name.toLowerCase() ? 'default' : 'destructive'} className="text-[10px]">
                    {session.gameScore} pts
                  </Badge>
                  <span className="text-[10px] text-muted-foreground">
                    {formatDate(session.startedAt).split(',')[0]}
                  </span>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="flex h-full items-center justify-center text-muted-foreground">
            No recent sessions found
          </div>
        )}
      </CardContent>
    </Card>
  );
}
