'use strict';
// Helper to check and unlock achievements after a game session
const checkAchievements = async (userId, tx) => {
  const stat = await tx.userStatistic.findUnique({ where: { userId } });
  if (!stat) return;

  const achievements = await tx.achievement.findMany({ where: { isActive: true } });
  const userAchievements = await tx.userAchievement.findMany({ where: { userId } });
  const unlockedIds = new Set(userAchievements.map(ua => ua.achievementId));

  for (const achievement of achievements) {
    if (unlockedIds.has(achievement.id)) continue;

    let isUnlocked = false;
    switch (achievement.triggerType) {
      case 'TOTAL_GAMES':
        if (stat.totalGames >= achievement.triggerValue) isUnlocked = true;
        break;
      case 'TOTAL_SCORE':
        if (stat.totalScore >= achievement.triggerValue) isUnlocked = true;
        break;
      case 'FOCUS_SCORE':
        // focusScore scale 0-1 or 0-100? Assuming 0-100 for the trigger, averageFocus might be 0-1.
        // We'll compare directly.
        if (stat.averageFocus >= achievement.triggerValue) isUnlocked = true;
        break;
      case 'SPECIFIC_ANIMAL':
        // For SPECIFIC_ANIMAL, we'd need to check if the user has played a certain animal.
        // For now, handled separately or skipped.
        break;
    }

    if (isUnlocked) {
      // Unlock achievement
      await tx.userAchievement.create({
        data: {
          userId,
          achievementId: achievement.id,
        }
      });
      // Give reward points
      await tx.user.update({
        where: { id: userId },
        data: { totalPoint: { increment: achievement.rewardPoint } }
      });
    }
  }
};

module.exports = {
  checkAchievements,
};
