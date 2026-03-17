import { Body, Controller, Get, Module, Post } from '@nestjs/common';

@Controller('itineraries')
class ItinerariesController {
  @Get()
  listItineraries() {
    return {
      items: [
        {
          id: 'itinerary_1',
          title: '7 Days in Egypt',
          totalItems: 5,
        },
      ],
    };
  }

  @Post()
  createItinerary(@Body() body: Record<string, unknown>) {
    return {
      id: 'itinerary_created',
      ...body,
    };
  }
}

@Module({
  controllers: [ItinerariesController],
})
export class ItinerariesModule {}
