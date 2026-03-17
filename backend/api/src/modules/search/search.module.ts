import { Controller, Get, Module, Query } from '@nestjs/common';

@Controller('search')
class SearchController {
  @Get()
  search(@Query('query') query?: string, @Query('category') category?: string) {
    return {
      query: query ?? '',
      category: category ?? 'all',
      items: [
        {
          id: 'listing_1',
          title: 'Giza Reserve Hotel',
          category: 'hotel',
        },
      ],
    };
  }
}

@Module({
  controllers: [SearchController],
})
export class SearchModule {}
