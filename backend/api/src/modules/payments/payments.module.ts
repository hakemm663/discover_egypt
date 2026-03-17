import { Body, Controller, Module, Post } from '@nestjs/common';

@Controller('payments')
class PaymentsController {
  @Post('checkout')
  createCheckout(@Body() body: Record<string, unknown>) {
    return {
      checkoutId: 'co_demo_123',
      provider: 'stripe_connect',
      ...body,
    };
  }

  @Post('webhooks/stripe')
  handleStripeWebhook(@Body() body: Record<string, unknown>) {
    return {
      received: true,
      eventType: body['type'] ?? 'unknown',
    };
  }
}

@Module({
  controllers: [PaymentsController],
})
export class PaymentsModule {}
