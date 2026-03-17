import { Controller, Get, Module } from '@nestjs/common';

@Controller('support')
class SupportController {
  @Get('tickets')
  listTickets() {
    return {
      items: [
        {
          id: 'ticket_1',
          subject: 'Airport pickup timing changed',
          status: 'new',
        },
      ],
    };
  }
}

@Module({
  controllers: [SupportController],
})
export class SupportModule {}
