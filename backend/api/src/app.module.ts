import { Module } from '@nestjs/common';

import { AdminModule } from './modules/admin/admin.module';
import { AuthModule } from './modules/auth/auth.module';
import { AvailabilityModule } from './modules/availability/availability.module';
import { BookingsModule } from './modules/bookings/bookings.module';
import { ItinerariesModule } from './modules/itineraries/itineraries.module';
import { ListingsModule } from './modules/listings/listings.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { PayoutsModule } from './modules/payouts/payouts.module';
import { ReviewsModule } from './modules/reviews/reviews.module';
import { SearchModule } from './modules/search/search.module';
import { StaffModule } from './modules/staff/staff.module';
import { SupportModule } from './modules/support/support.module';
import { UsersModule } from './modules/users/users.module';
import { VendorsModule } from './modules/vendors/vendors.module';

@Module({
  imports: [
    AuthModule,
    UsersModule,
    VendorsModule,
    ListingsModule,
    AvailabilityModule,
    SearchModule,
    BookingsModule,
    PaymentsModule,
    PayoutsModule,
    ReviewsModule,
    ItinerariesModule,
    NotificationsModule,
    AdminModule,
    StaffModule,
    SupportModule,
  ],
})
export class AppModule {}
