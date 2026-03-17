import { Controller, Get, Module } from '@nestjs/common';

@Controller('admin')
class AdminController {
  @Get('dashboard')
  getDashboard() {
    return {
      approvalsPending: 9,
      payoutsPending: 4,
      disputesOpen: 2,
    };
  }
}

@Module({
  controllers: [AdminController],
})
export class AdminModule {}
