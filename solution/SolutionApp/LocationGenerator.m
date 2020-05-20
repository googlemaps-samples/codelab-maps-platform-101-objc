/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#import "LocationGenerator.h"

@implementation LocationGenerator

+(NSArray<GMSMarker *> *)generateMarkersNear:(CLLocationCoordinate2D)location count:(int)count {
  NSMutableArray *markerArray = [[NSMutableArray alloc] init];
  for (int index = 1; index <= count; ++index) {
    const double extent = 0.1;
    double lat = location.latitude + extent * [self randomScale];
    double lng = location.longitude + extent * [self randomScale];
    CLLocationCoordinate2D randomLocation = CLLocationCoordinate2DMake(lat, lng);
    GMSMarker *marker = [GMSMarker markerWithPosition:randomLocation];
    marker.icon = [UIImage imageNamed:@"custom_pin.png"];
    [markerArray addObject:marker];
  }
  return markerArray;
}

// Returns a random value between -1.0 and 1.0.
+ (double)randomScale {
  return (double)arc4random() / UINT32_MAX * 2.0 - 1.0;
}

@end
