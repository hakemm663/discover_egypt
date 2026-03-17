import { Body, Controller, Get, Module, Put } from '@nestjs/common';

@Controller('notifications')
class NotificationsController {
  @Get('preferences')
  getPreferences() {
    return {
      push: true,
      email: false,
      promotions: true,
    };
  }

  @Put('preferences')
  updatePreferences(@Body() body: Record<string, unknown>) {
    return {
      updated: true,
      ...body,
    };
  }
}

@Module({
  controllers: [NotificationsController],
})
export class NotificationsModule {}
