import { Body, Controller, Get, Module, Param, Post } from '@nestjs/common';

@Controller('vendors')
class VendorsController {
  @Get()
  listVendors() {
    return {
      items: [
        {
          id: 'vendor_1',
          name: 'Golden Nile Experiences',
          status: 'approved',
        },
      ],
    };
  }

  @Get(':id')
  getVendor(@Param('id') id: string) {
    return {
      id,
      name: 'Golden Nile Experiences',
      payoutStatus: 'connected',
      listingsCount: 24,
    };
  }

  @Get(':id/listings')
  listVendorListings(@Param('id') id: string) {
    return {
      vendorId: id,
      items: [
        {
          id: 'listing_1',
          title: 'Private Luxor East & West Bank Tour',
          status: 'approved',
        },
      ],
    };
  }

  @Post()
  createVendor(@Body() body: Record<string, unknown>) {
    return {
      id: 'vendor_created',
      ...body,
    };
  }
}

@Module({
  controllers: [VendorsController],
})
export class VendorsModule {}
