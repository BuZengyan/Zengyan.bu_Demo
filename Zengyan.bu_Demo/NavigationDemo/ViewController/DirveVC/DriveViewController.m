//
//  DriveViewController.m
//  NavigationDemo
//
//  Created by zengyan.bu on 17/3/29.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  驾车导航

#define kDistanceX (15.0f)
#define kButtonWidth (80)
#define kBgViewHeight (80.0f)
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//系统版本号是否大于8.0
#define IS_SystemVersionGreaterThanEight  ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0)


#import "DriveViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "CustomMAAnnotationView.h"
#import <MapKit/MapKit.h>

@interface DriveViewController ()<MAMapViewDelegate,AMapSearchDelegate>

/* mapView */
@property (nonatomic, strong)   MAMapView *mapView;
/* search */
@property (nonatomic, strong)   AMapSearchAPI *search;
/* 文字显示背景View */
@property (nonatomic, strong)   UIView *bgView;
/* 显示文字label */
@property (nonatomic, strong)   UILabel *label;
/* 跳转button */
@property (nonatomic, strong)   UIButton *stipButton;
/* 导航终点坐标 */
@property (nonatomic, assign)   CLLocationCoordinate2D  coordinate;
/* 导航起点坐标 */
@property (nonatomic, assign)   CLLocationCoordinate2D userLocation;
/* 地理编码 */
@property (nonatomic, strong)   AMapGeocodeSearchRequest *request;
/* 数据源 */
@property (nonatomic, strong)   NSMutableArray *annototionArray;

@end

@implementation DriveViewController

- (NSMutableArray *)annototionArray{
    if (!_annototionArray) {
        _annototionArray = [[NSMutableArray alloc] init];
    }
    return _annototionArray;
}


- (MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight )];
        _mapView.delegate = self;
    }
    return _mapView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kBgViewHeight, kScreenWidth, kBgViewHeight)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.6;
    }
    return _bgView;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(kDistanceX, kScreenHeight - kBgViewHeight, kScreenWidth - kDistanceX*3 - kButtonWidth, kBgViewHeight)];
        _label.font = [UIFont systemFontOfSize:16];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.numberOfLines = 0;
        _label.backgroundColor = [UIColor clearColor];
    }
    return _label;
}

- (void)btnClick:(UIButton *)btn{
    //系统版本高于8.0，使用UIAlertController
    if (IS_SystemVersionGreaterThanEight) {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"导航到设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
        // 1.自带地图
        [alertController addAction:[UIAlertAction actionWithTitle:@"自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 自带地图");
        
            // 上海市经纬度 30.403153 120.511221
            MKMapItem *currentLocation =[[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.userLocation.latitude, self.userLocation.longitude) addressDictionary:nil]];
;

            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:nil]];
            
            [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                       MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
            
            
        }]];
        
        // 2.判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSLog(@"alertController -- 高德地图");
                NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",self.coordinate.latitude,self.coordinate.longitude]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:urlsting] options:@{} completionHandler:nil];
                
            }]];
        }
        
        // 3.判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
            [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSLog(@"alertController -- 百度地图");
                NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",self.coordinate.latitude,self.coordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting] options:@{} completionHandler:nil];
                
            }]];
        }
    
        // 4.腾讯地图，如果安装了腾讯地图，可以使用腾讯地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
            NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
            qqMapDic[@"title"] = @"腾讯地图";
            NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",self.coordinate.latitude, self.coordinate.longitude]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            qqMapDic[@"url"] = urlString;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        }
        
        //添加取消选项
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [alertController dismissViewControllerAnimated:YES completion:nil];
            
        }]];
        
        //显示alertController
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (UIButton *)stipButton{
    if (!_stipButton) {
        _stipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _stipButton.frame = CGRectMake(kScreenWidth - kDistanceX - kButtonWidth, kScreenHeight - kBgViewHeight, kButtonWidth, kBgViewHeight);
        [_stipButton setBackgroundColor: [UIColor clearColor]];
        [_stipButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_stipButton setTitle:@"导航" forState:UIControlStateNormal];
        [_stipButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _stipButton;
}

- (AMapSearchAPI *)search{
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

- (AMapGeocodeSearchRequest *)request{
    if (!_request) {
        _request = [[AMapGeocodeSearchRequest alloc] init];
        _request.city = @"上海市";
        _request.address = @"万荣路1268号";
    }
    return _request;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"调用外部导航demo";
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.label];
    [self.view addSubview:self.stipButton];
    
    //导航到深圳火车站 30.403153 120.511221
//    self.coordinate = CLLocationCoordinate2DMake(22.53183, 114.117206);
    self.coordinate = CLLocationCoordinate2DMake(30.403153, 120.511221);

    [self.search AMapGeocodeSearch:self.request];
    
    [self.mapView setZoomLevel:17];
    
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow];
}

#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *customAnnotationViewStr = @"customAnnotationViewStr";
        CustomMAAnnotationView *customAnnotationView= (CustomMAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:customAnnotationViewStr];
        if (customAnnotationView == nil) {
            customAnnotationView = [[CustomMAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customAnnotationViewStr];
        }
        customAnnotationView.image = [UIImage imageNamed:@"ic_location@2x.png"];
        return customAnnotationView;
    }
    return nil;
}

#pragma mark - 地理编码请求回调代理
/// 1.
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    if (response.geocodes.count == 0) {
        return;
    }
    
    [self.mapView removeAnnotations:self.annototionArray];
    [self.annototionArray removeAllObjects];
    
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MAPointAnnotation *anntotion = [[MAPointAnnotation alloc] init];
        [anntotion setCoordinate:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
        anntotion.title = obj.city;
        anntotion.subtitle = obj.formattedAddress;
        self.label.text = obj.formattedAddress;
        self.userLocation = CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude);
        [_annototionArray addObject:anntotion];
    }];
    
    [self showPOIAnntotionsWith:_annototionArray];
}

#pragma mark - 地图上展示搜索地点
- (void)showPOIAnntotionsWith:(NSMutableArray *)anntotions{
    [self.mapView addAnnotations:anntotions];
    
    if (anntotions.count == 1) {
        self.mapView.centerCoordinate = [(MAPointAnnotation *)[anntotions objectAtIndex:0] coordinate];
    }else{
        [self.mapView showAnnotations:anntotions animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
