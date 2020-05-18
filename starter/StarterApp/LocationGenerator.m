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
+ (CLLocationCoordinate2D)generateLocationNearLatitude:(double)latitude longitude:(double)longitude {
  const double extent = 0.1;
  double lat = latitude + extent * [self randomScale];
  double lng = longitude + extent * [self randomScale];
  CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lat, lng);
  return location;
}

// Returns a random value between -1.0 and 1.0.
+ (double)randomScale {
  return (double)arc4random() / UINT32_MAX * 2.0 - 1.0;
}

@end
