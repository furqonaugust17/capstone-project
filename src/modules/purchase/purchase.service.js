'use strict';
const prisma = require('../../config/database');

const purchaseItem = async (userId, itemId) => {
  return await prisma.$transaction(async (tx) => {
    const item = await tx.shopItem.findUnique({ where: { id: itemId } });
    if (!item || !item.isActive) {
      const error = new Error('Shop item not found or unavailable');
      error.statusCode = 404;
      throw error;
    }

    const user = await tx.user.findUnique({ where: { id: userId } });
    if (user.totalPoint < item.price) {
      const error = new Error('Insufficient points');
      error.statusCode = 400;
      throw error;
    }

    // For avatar, frame, theme, sticker, they might be non-stackable or stackable
    // Assuming we just increment quantity for now
    const existingInventory = await tx.userInventory.findUnique({
      where: {
        userId_itemId: {
          userId,
          itemId,
        }
      }
    });

    if (existingInventory) {
      const error = new Error('You already own this item');
      error.statusCode = 400;
      throw error;
    } else {
      await tx.userInventory.create({
        data: {
          userId,
          itemId,
          quantity: 1,
        }
      });
    }

    await tx.user.update({
      where: { id: userId },
      data: { totalPoint: { decrement: item.price } }
    });

    await tx.purchaseHistory.create({
      data: {
        userId,
        itemId,
        price: item.price,
      }
    });

    return { message: 'Item purchased successfully', item };
  });
};

module.exports = {
  purchaseItem,
};
