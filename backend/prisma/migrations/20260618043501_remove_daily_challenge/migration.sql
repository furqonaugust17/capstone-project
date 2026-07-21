/*
  Warnings:

  - You are about to drop the `daily_challenges` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `user_daily_challenges` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "daily_challenges" DROP CONSTRAINT "daily_challenges_animalId_fkey";

-- DropForeignKey
ALTER TABLE "user_daily_challenges" DROP CONSTRAINT "user_daily_challenges_challengeId_fkey";

-- DropForeignKey
ALTER TABLE "user_daily_challenges" DROP CONSTRAINT "user_daily_challenges_userId_fkey";

-- DropTable
DROP TABLE "daily_challenges";

-- DropTable
DROP TABLE "user_daily_challenges";
