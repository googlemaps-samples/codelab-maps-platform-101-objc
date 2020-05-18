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

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "LocationGenerator.h"
@import GoogleMapsUtils;

@interface ViewController ()<GMUClusterManagerDelegate, GMSMapViewDelegate>
@end

@implementation ViewController {
  GMSMapView *_mapView;
  GMUClusterManager *_clusterManager;
  GMSCircle *_circ;
}

- (void)loadView {
  // Load the map at set latitude/longitude and zoom level
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:12];
  _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  _mapView.myLocationEnabled = YES;
  _mapView.delegate = self;
  self.view = _mapView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Set up the cluster manager with a supplied icon generator and renderer.
  id<GMUClusterAlgorithm> algorithm =
  [[GMUNonHierarchicalDistanceBasedAlgorithm alloc] init];
  id<GMUClusterIconGenerator> iconGenerator =
  [[GMUDefaultClusterIconGenerator alloc] init];
  id<GMUClusterRenderer> renderer =
  [[GMUDefaultClusterRenderer alloc] initWithMapView:_mapView
                                clusterIconGenerator:iconGenerator];
  _clusterManager =
  [[GMUClusterManager alloc] initWithMap:_mapView
                               algorithm:algorithm
                                renderer:renderer];
  
  // Generate and add random items to the cluster manager.
  [self generateClusterItems];
  //  [_clusterManager setDelegate:self mapDelegate:self];
  // Render clusters from items on the map
  [_clusterManager cluster];
}

// Randomly generates cluster items within some extent of the camera and
// adds them to the cluster manager.
- (void)generateClusterItems {
  const int kClusterItemCount = 100;
  const double kCameraLatitude = -33.8;
  const double kCameraLongitude = 151.2;
  
  NSMutableArray *array = [[NSMutableArray alloc] init];
  
  for (int index = 1; index <= kClusterItemCount; ++index) {
    CLLocationCoordinate2D location = [LocationGenerator generateLocationNearLatitude:kCameraLatitude longitude:kCameraLongitude];
    
    GMSMarker *marker = [GMSMarker markerWithPosition:location];
    marker.title = @"test";
    marker.snippet = @"snippet";
    [array addObject:marker];
    [_clusterManager addItem:marker];
  }
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
  
  CLLocationCoordinate2D position = marker.position;
  [_mapView animateToLocation:position];
  _circ.map = nil;
  
  if ([marker.userData conformsToProtocol:@protocol(GMUCluster)]) {
    [_mapView animateToZoom:_mapView.camera.zoom +1];
    return YES;
  }
  
  // render the radius circle
  _circ = [GMSCircle circleWithPosition:position radius:800];
  _circ.fillColor = [UIColor colorWithRed: 0.67 green: 0.67 blue: 0.67 alpha: 0.5];
  _circ.map = _mapView;
  return NO;
}

@end
