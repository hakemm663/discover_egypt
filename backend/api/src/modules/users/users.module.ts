import { Controller, Get, Module } from '@nestjs/common';

@Controller('users')
class UsersController {
  @Get('profile')
  getUserProfile() {
    return {
      loyaltyTier: 'gold',
      walletBalance: 120.5,
      notificationPreferences: {
        push: true,
        email: false,
        promotions: true,
      },
    };
  }
}

@Module({
  controllers: [UsersController],
})
export class UsersModule {}
