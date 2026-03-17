import { Controller, Get, Module } from '@nestjs/common';

import { AppRole } from '../../common/enums/app-role.enum';

@Controller('auth')
class AuthController {
  @Get('me')
  getProfile() {
    return {
      id: 'user_demo_1',
      email: 'traveler@discoveregypt.app',
      fullName: 'Demo Traveler',
      primaryRole: AppRole.Tourist,
      roles: [AppRole.Tourist],
    };
  }
}

@Module({
  controllers: [AuthController],
})
export class AuthModule {}
