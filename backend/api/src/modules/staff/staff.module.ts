import { Controller, Get, Module } from '@nestjs/common';

@Controller('staff')
class StaffController {
  @Get('dashboard')
  getDashboard() {
    return {
      supportQueue: 13,
      escalationQueue: 3,
      sameDayActions: 7,
    };
  }
}

@Module({
  controllers: [StaffController],
})
export class StaffModule {}
