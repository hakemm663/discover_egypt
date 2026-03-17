import { Body, Controller, Get, Module, Post, Query } from '@nestjs/common';

@Controller('reviews')
class ReviewsController {
  @Get()
  listReviews(@Query('listingId') listingId?: string) {
    return {
      listingId: listingId ?? 'listing_1',
      items: [
        {
          id: 'review_1',
          rating: 5,
          comment: 'Outstanding host and very smooth booking.',
        },
      ],
    };
  }

  @Post()
  createReview(@Body() body: Record<string, unknown>) {
    return {
      id: 'review_created',
      moderationStatus: 'published',
      ...body,
    };
  }
}

@Module({
  controllers: [ReviewsController],
})
export class ReviewsModule {}
