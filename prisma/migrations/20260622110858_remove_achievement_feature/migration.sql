/*
  Warnings:

  - You are about to drop the `achievements` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `user_achievements` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "user_achievements" DROP CONSTRAINT "user_achievements_achievementId_fkey";

-- DropForeignKey
ALTER TABLE "user_achievements" DROP CONSTRAINT "user_achievements_userId_fkey";

-- DropTable
DROP TABLE "achievements";

-- DropTable
DROP TABLE "user_achievements";

-- DropEnum
DROP TYPE "TriggerType";
