import { Body, Controller, Get, Module, Param, Post, Query } from '@nestjs/common';

@Controller('listings')
class ListingsController {
  @Get()
  listListings(@Query('category') category?: string, @Query('city') city?: string) {
    return {
      items: [
        {
          id: 'listing_1',
          category: category ?? 'hotel',
          city: city ?? 'Cairo',
          title: 'Giza Reserve Hotel',
        },
      ],
      meta: {
        page: 1,
        pageSize: 20,
        totalCount: 1,
      },
    };
  }

  @Get(':id')
  getListing(@Param('id') id: string) {
    return {
      id,
      category: 'hotel',
      title: 'Giza Reserve Hotel',
      rating: 4.9,
      cancellationPolicy: 'Free cancellation up to 48 hours before arrival.',
    };
  }

  @Post()
  createListing(@Body() body: Record<string, unknown>) {
    return {
      id: 'listing_created',
      moderationStatus: 'pending_review',
      ...body,
    };
  }
}

@Module({
  controllers: [ListingsController],
})
export class ListingsModule {}
