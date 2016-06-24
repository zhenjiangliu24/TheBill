//
//  MapViewController.m
//  TheBill
//
//  Created by Zhenjiang Liu on 16/5/19.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Record+Annotation.h"
#import "DetailViewController.h"


@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.0f;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    [self prepareLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBar.barTintColor = APP_MAIN_COLOR;
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}

- (void)prepareLocation
{
    for (Record *record in self.records) {
        if (record.latitude && record.longitude) {
            [self.mapView addAnnotation:record];
        }
    }
}

#pragma mark - location delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    self.currentLocation = locations.lastObject;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1;
    span.longitudeDelta = 0.1;
    region.span = span;
    region.center = self.currentLocation.coordinate;
    [self.mapView setRegion:region animated:YES];
    
}

#pragma mark - map view delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    static NSString *reuseID = @"recordAnnotationView";
    MKPinAnnotationView *view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];
        view.canShowCallout = YES;
        view.enabled = YES;
        if ([annotation isKindOfClass:[Record class]]) {
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            Record *record = (Record *)annotation;
            UIImage *image = [UIImage imageNamed:record.recordType.icon];
            icon.image = image;
            view.leftCalloutAccessoryView = icon;
        }
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
    }else{
        view.annotation = annotation;
    }
    return view;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    UINavigationController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"detail_navi"];
    DetailViewController *detailVC = (DetailViewController *)navi.topViewController;
    Record *record = nil;
    if ([view.annotation isKindOfClass:[Record class]]) {
        record = (Record *)view.annotation;
        detailVC.myRecord = record;
        detailVC.user = self.user;
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
