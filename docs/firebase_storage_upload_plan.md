# Firebase Storage upload plan (Discover Egypt)

Use this structure when uploading files to your Firebase Storage bucket:

- `users/{uid}/avatar/{fileName}`
- `catalog/hotels/{hotelId}/{fileName}`
- `catalog/tours/{tourId}/{fileName}`
- `catalog/cars/{carId}/{fileName}`
- `catalog/restaurants/{restaurantId}/{fileName}`
- `bookings/{uid}/{bookingId}/{fileName}`
- `support/{uid}/{ticketId}/{fileName}`

## Example upload paths

```text
catalog/hotels/hotel_001/cover.jpg
catalog/hotels/hotel_001/gallery_1.jpg
catalog/tours/tour_001/cover.jpg
catalog/cars/car_001/cover.jpg
catalog/restaurants/rest_001/cover.jpg
users/USER_UID/avatar/profile.jpg
bookings/USER_UID/booking_001/id_proof.pdf
support/USER_UID/ticket_001/screenshot.png
```

## Important

- Storage security rules are defined in `storage.rules`.
- Public app media should be uploaded under `catalog/...`.
- User-private files should be uploaded under `users/...`, `bookings/...`, or `support/...`.


## Console upload checklist

1. Open Firebase Console -> Storage -> Files.
2. Click **Upload file** and select the destination path from this document.
3. For catalog images, upload under `catalog/<category>/<itemId>/...`.
4. For user files, always include the real authenticated UID in the path.

## Permission notes (from `storage.rules`)

- `catalog/...` uploads require a signed-in user with custom claim `admin: true`.
- `users/{uid}/avatar/...` accepts images only, max **5 MB**.
- `catalog/...` accepts images only, max **10 MB**.
- `bookings/...` and `support/...` accept files up to **15 MB**.
- Any other folder/path is blocked by default.

If an upload is denied, verify the path and file type/size first, then verify the Firebase Auth user and admin custom claim.
