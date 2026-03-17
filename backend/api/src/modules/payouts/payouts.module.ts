import { Controller, Get, Module } from '@nestjs/common';

@Controller('payouts')
class PayoutsController {
  @Get('summary')
  getPayoutSummary() {
    return {
      pending: 1240,
      processing: 860,
      paidOut: 8420,
      currency: 'USD',
    };
  }
}

@Module({
  controllers: [PayoutsController],
})
export class PayoutsModule {}
