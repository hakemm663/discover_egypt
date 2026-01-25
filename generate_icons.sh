#!/bin/bash

# This script converts the SVG logo to PNG format in different sizes
# You can run this manually or use online converters

echo "To generate app icons from SVG:"
echo "1. Use online converter like https://convertio.co/svg-png/"
echo "2. Convert app_icon_new.svg to PNG at 1024x1024"
echo "3. Use https://appicon.co/ to generate all required sizes"
echo "4. Replace the generated icons in android/app/src/main/res/mipmap-* folders"

# Alternative: Use ImageMagick if installed
# convert assets/icons/app_icon_new.svg -resize 1024x1024 assets/icons/app_icon.png