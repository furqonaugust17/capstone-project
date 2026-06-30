"use client";

import { useEffect, useState } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { userService } from '@/services/user.service';
import { useApi } from '@/hooks/use-api';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { ArrowLeft, Trash2, ImageOff } from 'lucide-react';
import Link from 'next/link';
import Image from 'next/image';
import { LoadingSpinner } from '@/components/common/loading-spinner';
import { DeleteConfirmDialog } from '@/components/dialogs/delete-confirm';
import { formatDate } from '@/lib/utils';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { analyticsService } from '@/services/analytics.service';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { gameSessionService } from '@/services/game-session.service';
import { SessionsTable } from '@/components/tables/sessions-table';
import { SessionDetailModal } from '@/components/dialogs/session-detail-modal';

export default function UserDetailPage() {
  const params = useParams();
  const router = useRouter();
  const id = params.id as string;
  
  const { data: user, isLoading, execute: fetchUser } = useApi(userService.getUserById);
  const { data: inventory, isLoading: isInventoryLoading, execute: fetchInventory } = useApi(userService.getUserInventory);
  const { data: purchases, isLoading: isPurchasesLoading, execute: fetchPurchases } = useApi(userService.getUserPurchases);
  const { data: analytics, isLoading: isAnalyticsLoading, execute: fetchAnalytics } = useApi(analyticsService.getUserAnalytics);
  const { data: sessionsResponse, isLoading: isSessionsLoading, execute: fetchSessions } = useApi(gameSessionService.getSessions);
  const { execute: deleteUser, isLoading: isDeleting } = useApi(userService.deleteUser, {
    successMessage: 'Pengguna berhasil dihapus',
  });

  const [showDelete, setShowDelete] = useState(false);
  const [selectedSessionId, setSelectedSessionId] = useState<string | null>(null);

  useEffect(() => {
    if (id) {
      fetchUser(id);
      fetchInventory(id);
      fetchPurchases(id);
      fetchAnalytics(id);
      fetchSessions({ userId: id, limit: 100 });
    }
  }, [id, fetchUser, fetchInventory, fetchPurchases, fetchAnalytics, fetchSessions]);

  const handleDelete = async () => {
    await deleteUser(id);
    setShowDelete(false);
    router.push('/users');
  };

  const getCategoryColor = (category: string) => {
    switch (category) {
      case 'AVATAR': return 'bg-blue-100 text-blue-800';
      case 'FRAME': return 'bg-green-100 text-green-800';
      case 'STICKER': return 'bg-orange-100 text-orange-800';
      case 'THEME': return 'bg-purple-100 text-purple-800';
      default: return '';
    }
  };

  const getRarityColor = (rarity: string) => {
    switch (rarity) {
      case 'COMMON': return 'bg-zinc-200 text-zinc-700';
      case 'RARE': return 'bg-blue-100 text-blue-700';
      case 'EPIC': return 'bg-purple-100 text-purple-700';
      case 'LEGENDARY': return 'bg-amber-100 text-amber-700';
      default: return '';
    }
  };

  if (isLoading) return <LoadingSpinner />;
  if (!user) return <div className="p-8 text-center">Pengguna tidak ditemukan</div>;

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Button variant="ghost" size="icon" onClick={() => router.push('/users')}>
            <ArrowLeft className="h-4 w-4" />
          </Button>
          <h2 className="text-2xl font-bold tracking-tight">Detail Pengguna</h2>
        </div>
        <Button variant="destructive" onClick={() => setShowDelete(true)}>
          <Trash2 className="mr-2 h-4 w-4" /> Hapus Pengguna
        </Button>
      </div>

      <div className="flex items-center gap-6 p-6 border rounded-lg bg-white dark:bg-zinc-950">
        <Avatar className="h-20 w-20">
          <AvatarImage src={user.avatarUrl || ''} />
          <AvatarFallback className="text-2xl">{(user.displayName || 'U').charAt(0).toUpperCase()}</AvatarFallback>
        </Avatar>
        <div>
          <h3 className="text-2xl font-bold">{user.displayName}</h3>
          <p className="text-muted-foreground">@{user.username} • {user.email}</p>
          <p className="text-sm mt-2 font-medium">Bergabung {formatDate(user.createdAt)}</p>
        </div>
      </div>

      <Tabs defaultValue="profile" className="w-full">
        <TabsList className="flex-wrap h-auto mb-2">
          <TabsTrigger value="profile">Profil & Info</TabsTrigger>
          <TabsTrigger value="games">Riwayat Permainan</TabsTrigger>
          <TabsTrigger value="inventory">Inventaris</TabsTrigger>
          <TabsTrigger value="purchases">Pembelian</TabsTrigger>
          <TabsTrigger value="analytics">Analitik</TabsTrigger>
        </TabsList>
        <TabsContent value="profile" className="mt-4">
          <Card>
            <CardHeader>
              <CardTitle>Informasi Profil</CardTitle>
              <CardDescription>Detail akun dasar dan poin.</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <p className="text-sm text-muted-foreground">ID Pengguna</p>
                  <p className="font-medium">{user.id}</p>
                </div>
                <div>
                  <p className="text-sm text-muted-foreground">Total Poin</p>
                  <p className="font-medium text-blue-600 dark:text-blue-400">{user.totalPoint} pts</p>
                </div>
                <div>
                  <p className="text-sm text-muted-foreground">Terakhir Diperbarui</p>
                  <p className="font-medium">{formatDate(user.updatedAt, 'PPpp')}</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
        <TabsContent value="analytics" className="mt-4 space-y-4">
          <div>
            <h3 className="text-lg font-medium">Analitik Pemain</h3>
            <p className="text-sm text-muted-foreground">Data performa detail untuk pemain ini.</p>
          </div>
          
          {isAnalyticsLoading ? (
            <div className="flex justify-center py-8">
              <LoadingSpinner text="Memuat analitik..." />
            </div>
          ) : !analytics ? (
            <div className="text-center py-8 text-zinc-500 border rounded-md">
              Belum ada data analitik yang tersedia untuk pemain ini.
            </div>
          ) : (
            <>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                <Card>
                  <CardHeader className="pb-2">
                    <CardTitle className="text-sm font-medium text-muted-foreground">Total Permainan</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="text-2xl font-bold">{analytics.totalGames || 0}</div>
                  </CardContent>
                </Card>
                <Card>
                  <CardHeader className="pb-2">
                    <CardTitle className="text-sm font-medium text-muted-foreground">Skor Rata-rata</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="text-2xl font-bold">{analytics.averageScore || 0}</div>
                  </CardContent>
                </Card>
                <Card>
                  <CardHeader className="pb-2">
                    <CardTitle className="text-sm font-medium text-muted-foreground">Skor Tertinggi</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="text-2xl font-bold">{analytics.highestScore || 0}</div>
                  </CardContent>
                </Card>
                <Card>
                  <CardHeader className="pb-2">
                    <CardTitle className="text-sm font-medium text-muted-foreground">Waktu Menggambar</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="text-2xl font-bold">
                      {analytics.totalDrawingTime < 60 
                        ? `${analytics.totalDrawingTime}s` 
                        : analytics.totalDrawingTime < 3600 
                          ? `${Math.floor(analytics.totalDrawingTime / 60)}m ${analytics.totalDrawingTime % 60}s`
                          : `${Math.floor(analytics.totalDrawingTime / 3600)}h ${Math.floor((analytics.totalDrawingTime % 3600) / 60)}m`}
                    </div>
                  </CardContent>
                </Card>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <Card>
                  <CardHeader className="pb-2">
                    <CardTitle className="text-sm font-medium flex items-center gap-2">
                      <span>🐱 Hewan Favorit</span>
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="flex items-center gap-4 mt-2">
                      <div className="h-12 w-12 rounded-full bg-zinc-100 flex items-center justify-center overflow-hidden">
                        {analytics.favoriteAnimal?.thumbnailUrl ? (
                          <img src={analytics.favoriteAnimal.thumbnailUrl} alt="Animal" className="w-full h-full object-cover" />
                        ) : (
                          <span className="text-xl">🐱</span>
                        )}
                      </div>
                      <div className="text-xl font-bold">{analytics.favoriteAnimal?.name || 'Tidak ada'}</div>
                    </div>
                  </CardContent>
                </Card>
                <Card>
                  <CardHeader className="pb-2">
                    <CardTitle className="text-sm font-medium flex items-center gap-2">
                      <span>🎯 Fokus Rata-rata</span>
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="mt-2 space-y-2">
                      <div className="flex justify-between text-sm mb-1">
                        <span>Tingkat Fokus</span>
                        <span className="font-bold">{((analytics.averageFocus || 0) * 100).toFixed(1)}%</span>
                      </div>
                      <div className="w-full bg-zinc-200 rounded-full h-2.5">
                        <div 
                          className="bg-green-600 h-2.5 rounded-full" 
                          style={{ width: `${(analytics.averageFocus || 0) * 100}%` }}
                        ></div>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              </div>

              <Card>
                <CardHeader>
                  <CardTitle>Tren Skor Terkini</CardTitle>
                  <CardDescription>Skor permainan dan performa fokus seiring waktu.</CardDescription>
                </CardHeader>
                <CardContent className="h-[300px]">
                  {analytics.recentTrend && analytics.recentTrend.length > 0 ? (
                    <ResponsiveContainer width="100%" height="100%">
                      <LineChart data={analytics.recentTrend} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                        <CartesianGrid strokeDasharray="3 3" vertical={false} />
                        <XAxis 
                          dataKey="createdAt" 
                          tickFormatter={(val) => formatDate(val, 'MMM dd')} 
                          tick={{ fontSize: 12 }} 
                        />
                        <YAxis tick={{ fontSize: 12 }} />
                        <Tooltip 
                          labelFormatter={(val) => formatDate(val, 'PPp')}
                          formatter={(value, name) => [value, name === 'gameScore' ? 'Skor Permainan' : 'Skor Fokus']}
                        />
                        <Line type="monotone" dataKey="gameScore" name="gameScore" stroke="#3b82f6" strokeWidth={2} dot={{ r: 4 }} activeDot={{ r: 6 }} />
                        <Line 
                          type="monotone" 
                          dataKey={(d) => d.focusScore * 100} 
                          name="focusScore" 
                          stroke="#10b981" 
                          strokeWidth={2} 
                          dot={{ r: 4 }} 
                        />
                      </LineChart>
                    </ResponsiveContainer>
                  ) : (
                    <div className="flex items-center justify-center h-full text-zinc-500">Data tren tidak tersedia</div>
                  )}
                </CardContent>
              </Card>
            </>
          )}
        </TabsContent>
        <TabsContent value="games" className="mt-4">
          <Card>
            <CardHeader>
              <CardTitle>Sesi Permainan</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="border rounded-md mt-4">
                <SessionsTable 
                  sessions={sessionsResponse?.data || []} 
                  isLoading={isSessionsLoading} 
                  onViewDetail={setSelectedSessionId}
                />
              </div>
            </CardContent>
          </Card>
        </TabsContent>
        <TabsContent value="inventory" className="mt-4">
          <Card>
            <CardHeader>
              <CardTitle>Inventaris Pemain</CardTitle>
              <CardDescription>Item yang dimiliki oleh pemain ini.</CardDescription>
            </CardHeader>
            <CardContent>
              {isInventoryLoading ? (
                <div className="flex justify-center py-8">
                  <LoadingSpinner text="Memuat inventaris..." />
                </div>
              ) : !inventory || inventory.length === 0 ? (
                <div className="text-center py-8 text-zinc-500 border rounded-md">
                  Pengguna ini tidak memiliki item di inventaris mereka.
                </div>
              ) : (
                <div className="border rounded-md">
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead className="w-[50px]">Gambar</TableHead>
                        <TableHead>Nama Item</TableHead>
                        <TableHead className="w-[100px]">Kategori</TableHead>
                        <TableHead className="w-[100px]">Kelangkaan</TableHead>
                        <TableHead className="w-[60px] text-right">Jml</TableHead>
                        <TableHead className="w-[120px]">Diperoleh</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {inventory.map((inv: any) => (
                        <TableRow key={inv.id}>
                          <TableCell>
                            <div className="h-8 w-8 flex items-center justify-center bg-zinc-100 rounded-md overflow-hidden">
                              {inv.shopItem?.imageUrl ? (
                                <Image
                                  src={inv.shopItem.imageUrl}
                                  alt={inv.shopItem.name || 'Item'}
                                  width={32}
                                  height={32}
                                  className="object-cover w-full h-full"
                                />
                              ) : (
                                <ImageOff className="h-4 w-4 text-zinc-400" />
                              )}
                            </div>
                          </TableCell>
                          <TableCell className="font-medium">
                            {inv.shopItem?.name || `Item #${inv.itemId}`}
                          </TableCell>
                          <TableCell>
                            {inv.shopItem?.category ? (
                              <Badge className={getCategoryColor(inv.shopItem.category)} variant="outline">
                                {inv.shopItem.category}
                              </Badge>
                            ) : '-'}
                          </TableCell>
                          <TableCell>
                            {inv.shopItem?.rarity ? (
                              <Badge className={getRarityColor(inv.shopItem.rarity)} variant="outline">
                                {inv.shopItem.rarity.charAt(0).toUpperCase() + inv.shopItem.rarity.slice(1).toLowerCase()}
                              </Badge>
                            ) : '-'}
                          </TableCell>
                          <TableCell className="text-right">
                            &times;{inv.quantity}
                          </TableCell>
                          <TableCell className="text-sm text-zinc-500">
                            {formatDate(inv.acquiredAt)}
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>
        <TabsContent value="purchases" className="mt-4">
          <Card>
            <CardHeader>
              <CardTitle>Riwayat Pembelian</CardTitle>
              <CardDescription>Semua item yang dibeli oleh pemain ini.</CardDescription>
            </CardHeader>
            <CardContent>
              {isPurchasesLoading ? (
                <div className="flex justify-center py-8">
                  <LoadingSpinner text="Memuat pembelian..." />
                </div>
              ) : !purchases || purchases.length === 0 ? (
                <div className="text-center py-8 text-zinc-500 border rounded-md">
                  Pengguna ini belum memiliki riwayat pembelian.
                </div>
              ) : (
                <div className="border rounded-md">
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead>Nama Item</TableHead>
                        <TableHead className="w-[100px]">Kategori</TableHead>
                        <TableHead className="w-[100px] text-right">Harga Dibayar</TableHead>
                        <TableHead className="w-[150px]">Tanggal Pembelian</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {purchases.map((purchase: any) => (
                        <TableRow key={purchase.id}>
                          <TableCell className="font-medium">
                            {purchase.shopItem?.name || `Item #${purchase.itemId}`}
                          </TableCell>
                          <TableCell>
                            {purchase.shopItem?.category ? (
                              <Badge className={getCategoryColor(purchase.shopItem.category)} variant="outline">
                                {purchase.shopItem.category}
                              </Badge>
                            ) : '-'}
                          </TableCell>
                          <TableCell className="text-right">
                            {purchase.price.toLocaleString('id-ID')} pts
                          </TableCell>
                          <TableCell className="text-sm text-zinc-500">
                            {formatDate(purchase.purchasedAt, 'PPpp')}
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>

      </Tabs>

      <DeleteConfirmDialog
        open={showDelete}
        onOpenChange={setShowDelete}
        onConfirm={handleDelete}
        isLoading={isDeleting}
        title="Hapus Pengguna"
        description={`Apakah Anda yakin ingin menghapus ${user.displayName}? Semua data permainan yang terkait juga akan dihapus permanen.`}
      />

      <SessionDetailModal
        sessionId={selectedSessionId}
        onClose={() => setSelectedSessionId(null)}
      />
    </div>
  );
}
