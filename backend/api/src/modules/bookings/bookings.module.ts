import { Body, Controller, Get, Module, Param, Post } from '@nestjs/common';

@Controller('bookings')
class BookingsController {
  @Get()
  listBookings() {
    return {
      items: [
        {
          id: 'booking_1',
          status: 'confirmed',
          paymentStatus: 'succeeded',
        },
      ],
    };
  }

  @Post()
  createBooking(@Body() body: Record<string, unknown>) {
    return {
      id: 'booking_created',
      status: 'pending_payment',
      ...body,
    };
  }

  @Post(':id/pay')
  payForBooking(@Param('id') id: string) {
    return {
      bookingId: id,
      status: 'requires_action',
      paymentIntentId: 'pi_demo_123',
    };
  }
}

@Module({
  controllers: [BookingsController],
})
export class BookingsModule {}
