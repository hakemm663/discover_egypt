import { Body, Controller, Module, Post } from '@nestjs/common';

@Controller('availability')
class AvailabilityController {
  @Post('check')
  checkAvailability(@Body() body: Record<string, unknown>) {
    return {
      available: true,
      checkedAgainst: body,
    };
  }
}

@Module({
  controllers: [AvailabilityController],
})
export class AvailabilityModule {}
