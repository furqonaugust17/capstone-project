import { ShopItem } from '@/types';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { ImageOff, MoreHorizontal, PackageOpen, Pencil, Trash2, Loader2 } from 'lucide-react';
import Image from 'next/image';

interface ShopItemsTableProps {
  items: ShopItem[];
  isLoading: boolean;
  onEdit: (id: string) => void;
  onDelete: (id: string) => void;
}

export function ShopItemsTable({
  items,
  isLoading,
  onEdit,
  onDelete,
}: ShopItemsTableProps) {
  const getCategoryColor = (category: string) => {
    switch (category) {
      case 'AVATAR':
        return 'bg-blue-100 text-blue-800 hover:bg-blue-100/80';
      case 'FRAME':
        return 'bg-green-100 text-green-800 hover:bg-green-100/80';
      case 'STICKER':
        return 'bg-orange-100 text-orange-800 hover:bg-orange-100/80';
      case 'THEME':
        return 'bg-purple-100 text-purple-800 hover:bg-purple-100/80';
      default:
        return '';
    }
  };

  const getRarityColor = (rarity: string) => {
    switch (rarity) {
      case 'COMMON':
        return 'bg-zinc-200 text-zinc-700 hover:bg-zinc-200/80';
      case 'RARE':
        return 'bg-blue-100 text-blue-700 hover:bg-blue-100/80';
      case 'EPIC':
        return 'bg-purple-100 text-purple-700 hover:bg-purple-100/80';
      case 'LEGENDARY':
        return 'bg-amber-100 text-amber-700 hover:bg-amber-100/80';
      default:
        return '';
    }
  };

  const capitalize = (str: string) => {
    return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
  };

  const getCategoryLabel = (category: string) => {
    switch (category) {
      case 'FRAME': return 'Bingkai';
      case 'STICKER': return 'Stiker';
      case 'THEME': return 'Tema';
      case 'AVATAR': return 'Avatar';
      default: return capitalize(category);
    }
  };

  const getRarityLabel = (rarity: string) => {
    switch (rarity) {
      case 'COMMON': return 'Biasa';
      case 'RARE': return 'Langka';
      case 'EPIC': return 'Epik';
      case 'LEGENDARY': return 'Legendaris';
      default: return capitalize(rarity);
    }
  };

  if (isLoading) {
    return (
      <div className="flex flex-col items-center justify-center p-8 text-zinc-500">
        <Loader2 className="h-8 w-8 animate-spin mb-4" />
        <p>Memuat item toko...</p>
      </div>
    );
  }

  if (items.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center p-8 text-zinc-500 border rounded-md">
        <PackageOpen className="h-12 w-12 mb-4 text-zinc-400" />
        <p className="text-lg font-medium text-zinc-900">Item toko tidak ditemukan</p>
        <p className="text-sm">Mulai dengan membuat item toko baru.</p>
      </div>
    );
  }

  return (
    <div className="rounded-md border">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead className="w-[60px]">Gambar</TableHead>
            <TableHead>Nama</TableHead>
            <TableHead className="w-[100px]">Kategori</TableHead>
            <TableHead className="w-[100px]">Kelangkaan</TableHead>
            <TableHead className="w-[100px] text-right">Harga</TableHead>
            <TableHead className="w-[80px]">Status</TableHead>
            <TableHead className="w-[80px] text-right">Aksi</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {items.map((item) => (
            <TableRow key={item.id}>
              <TableCell>
                <div className="h-10 w-10 flex items-center justify-center bg-zinc-100 rounded-md overflow-hidden">
                  {item.imageUrl ? (
                    <Image
                      src={item.imageUrl}
                      alt={item.name}
                      width={40}
                      height={40}
                      className="object-cover w-full h-full"
                    />
                  ) : (
                    <ImageOff className="h-5 w-5 text-zinc-400" />
                  )}
                </div>
              </TableCell>
              <TableCell>
                <div className="font-medium">{item.name}</div>
                <div className="text-xs text-zinc-500 truncate max-w-[200px]">
                  {item.description}
                </div>
              </TableCell>
              <TableCell>
                <Badge className={getCategoryColor(item.category)} variant="outline">
                  {getCategoryLabel(item.category)}
                </Badge>
              </TableCell>
              <TableCell>
                <Badge className={getRarityColor(item.rarity)} variant="outline">
                  {getRarityLabel(item.rarity)}
                </Badge>
              </TableCell>
              <TableCell className="text-right whitespace-nowrap">
                {item.price.toLocaleString('id-ID')} pts
              </TableCell>
              <TableCell>
                <Badge variant={item.isActive ? 'default' : 'secondary'}>
                  {item.isActive ? 'Aktif' : 'Tidak Aktif'}
                </Badge>
              </TableCell>
              <TableCell className="text-right">
                <DropdownMenu>
                  <DropdownMenuTrigger className="flex h-8 w-8 items-center justify-center rounded-md text-zinc-500 hover:bg-zinc-100 hover:text-zinc-900 focus:outline-none focus:ring-1 focus:ring-zinc-300">
                    <span className="sr-only">Buka menu</span>
                    <MoreHorizontal className="h-4 w-4" />
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="end">
                    <DropdownMenuItem onClick={() => onEdit(item.id)}>
                      <Pencil className="mr-2 h-4 w-4" />
                      Edit
                    </DropdownMenuItem>
                    <DropdownMenuItem
                      onClick={() => onDelete(item.id)}
                      className="text-red-600 focus:text-red-600"
                    >
                      <Trash2 className="mr-2 h-4 w-4" />
                      Hapus
                    </DropdownMenuItem>
                  </DropdownMenuContent>
                </DropdownMenu>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  );
}
