//
//  FindLocationViewController.m
//  NavigationDemo
//
//  Created by zengyan.bu on 17/3/28.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  查找VC

#define kSearchViewHeight (64.0f)
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kNavigationBarHeight (64.0f)
#define kButtonWidth (60.0f)
#define kDistanceX (15)
#define kViewWidth (100.0f)
#define kCellHeight (176.0f/4)
#define kMainTableViewHeight (300.f)
#define kMainCellHeight (44.0f)

#import "FindLocationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "CustomMAAnnotationView.h"
#import "HeaderSearchView.h"
#import "CityView.h"

@interface FindLocationViewController ()<MAMapViewDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)   MAMapView           *mapView;
@property (nonatomic, strong)   MACircle            *circle;
@property (nonatomic, strong)   AMapSearchAPI       *search;
@property (nonatomic, strong)   NSMutableArray      *poiAnnotations;
@property (nonatomic, strong)   AMapPOIAroundSearchRequest *aroundRequest;
@property (nonatomic, strong)   HeaderSearchView    *searchView;
@property (nonatomic, strong)   CityView            *cityView;
@property (nonatomic, strong)   CityView            *typeView;
@property (nonatomic, strong)   NSMutableArray      *customViewArray;
/// 显示位置信息的tableView
@property (nonatomic, strong)   UITableView         *mainTableView;
@property (nonatomic, strong)   NSMutableArray      *mainDataArray;
@property (nonatomic, strong)   NSMutableArray      *mainSubTitleArray;
/// 展开button
@property (nonatomic, strong)   UIButton            *openButton;
@property (nonatomic, strong)   UIView              *openBgView;

@end

@implementation FindLocationViewController
{
    MAPointAnnotation *pointAnnotation;
    AMapPOIKeywordsSearchRequest *request;
    
    UIButton *cityBtn;
    UIButton *typeBtn;
    
    NSString *_keywords;
    NSString *_cityStr;
    NSString *_typeStr;
}


- (NSMutableArray *)customViewArray{
    if (!_customViewArray) {
        _customViewArray = [[NSMutableArray alloc] init];
    }
    return _customViewArray;
}

/// 位置列表信息
- (NSMutableArray *)mainDataArray{
    if (!_mainDataArray) {
        _mainDataArray = [[NSMutableArray alloc] init];
    }
    return _mainDataArray;
}
- (NSMutableArray *)mainSubTitleArray{
    if (!_mainSubTitleArray) {
        _mainSubTitleArray = [[NSMutableArray alloc] init];
    }
    return _mainSubTitleArray;
}

- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kMainTableViewHeight, kScreenWidth, kMainTableViewHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMainCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr];
    }
    cell.textLabel.text = [_mainDataArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.text = [_mainSubTitleArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:9];
    return cell;
}



- (NSMutableArray *)poiAnnotations{
    if (!_poiAnnotations) {
        _poiAnnotations = [[NSMutableArray alloc] init];
    }
    return _poiAnnotations;
}

- (CityView *)cityView{
    if (!_cityView) {
        NSMutableArray *cityArray = [NSMutableArray arrayWithObjects:@"北京",@"上海",@"广州",@"深圳", nil];
        _cityView = [[CityView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight*2, kViewWidth, kViewWidth*2) dataArray:cityArray];
    }
    return _cityView;
}

- (CityView *)typeView{
    if (!_typeView) {
        NSMutableArray *cityArray = [NSMutableArray arrayWithObjects:@"商场",@"公司",@"公园", @"地铁站",@"小区",@"火车站",@"机场",@"景点",@"美食",nil];
        _typeView = [[CityView alloc] initWithFrame:CGRectMake(kScreenWidth - kViewWidth, kNavigationBarHeight, kViewWidth, kViewWidth*2) dataArray:cityArray];
    }
    return _typeView;
}

- (void)btnSelected{
    [self showOrHiddenCityView];
}

- (void)btnSelectedForType{
    [self showOrHiddenTypeView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor blackColor];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    //    self.navigationController.navigationBar.tintColor
    self.navigationItem.title = @"位置搜索";
    
    cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame = CGRectMake(0, kNavigationBarHeight, kSearchViewHeight, kSearchViewHeight);
    [cityBtn setTitle:@"上海" forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cityBtn addTarget:self action:@selector(btnSelected) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:cityBtn];
//    self.navigationItem.leftBarButtonItem = leftItem;
    [self.view addSubview:cityBtn];
    
    typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    typeBtn.frame = CGRectMake(0, 0, 64, 64);
    [typeBtn setTitle:@"商场" forState:UIControlStateNormal];
    [typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [typeBtn addTarget:self action:@selector(btnSelectedForType) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:typeBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    /// 城市列表
    _keywords = @"华润";
    _cityStr = @"上海";
    _typeStr = @"商场";
    
    
    
    
    [self poiAnnotations];
    self.searchView = [[HeaderSearchView alloc] initWithFrame:CGRectMake(kDistanceX + kButtonWidth, kNavigationBarHeight, kScreenWidth - kDistanceX - kButtonWidth, kSearchViewHeight) placeholder:@"请输入关键字"];
    [self.view addSubview:self.searchView];
    
    __weak typeof(self) weakSelf = self;
    self.searchView.searchBlock = ^(NSString *keywords){
        [weakSelf requestOfKeywords:keywords];
    };
    
    
    /// 1.适配HTTPS
    [AMapServices sharedServices].enableHTTPS = YES;
    
    
    /// 2.添加地图视图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0,kNavigationBarHeight + kSearchViewHeight , kScreenWidth, kScreenHeight - kSearchViewHeight - kMainTableViewHeight)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    /// 3.显示定位(显示小蓝点)：此时需要配置info.plist文件
    /*
     *  持续获取地理位置 	NSLocationAlwaysUsageDescription
     *  使用时获取地理位置 	NSLocationWhenInUseUsageDescription
     */
    //    [_mapView setZoomLevel:18 animated:YES];
    
    
    
    // 后台持续定位
    _mapView.pausesLocationUpdatesAutomatically = YES;
    _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    
    
    
    // sousuo
    
    // 城市
    [self.view addSubview:self.cityView];
    self.cityView.citySelectedBlock = ^(NSString *cityName){
        [weakSelf requestForCity:cityName];
    };
    self.cityView.hidden = YES;
    
    // 分类
    [self.view addSubview:self.typeView];
    self.typeView.citySelectedBlock = ^(NSString *typeStr){
        [weakSelf requestOfTypes:typeStr];
    };
    self.typeView.hidden = YES;
    
    /*
     /// 4.开启室内地图模式
     
     _mapView.showsIndoorMap = YES;
     
     /// 地图上显示控件控制
     /// 5.调整地图logo的位置（不可以消除）
     _mapView.logoCenter = CGPointMake(kScreenWidth/2, 450);
     
     /// 6.地图指南针属性
     _mapView.showsCompass = YES;    // 默认yes，隐藏是no
     _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 22); // 指南针位置
     
     /// 7.比例尺控件
     _mapView.showsScale = YES;
     _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, 20); // 比例尺位置
     
     /// 8.手势交互
     
     //MAMapView.zoomEnabled  此属性用于缩放手势的开启和关闭
     
     // MAMapView.scrollEnabled    此属性用于地图拖动的开启和关闭
     
     // MAMapView.rotateEnabled    此属性用于地图旋转的开启和关闭
     
     // MAMapView.rotateCameraEnabled  此属性用于地图Camera旋转的开启和关闭
     
     // 1).缩放手势
     _mapView.zoomEnabled = YES;  // 是否支持缩放开关
     [_mapView setZoomLevel:17.5 animated:YES];    // 缩放级范围(3-19)
     
     // 2).拖动手势
     
     _mapView.scrollEnabled = YES;   // 是否支持拖动
     //        地图平移时，缩放级别不变，可通过改变地图的中心点来移动地图，示例代码如下：
     //        [_mapView setCenterCoordinate:CGPointMake(0, 0) animated:YES];
     // 3)旋转手势
     */
    
    
    /// 9.添加折线
    /*
     CLLocationCoordinate2D commonPolylineCoords[4];
     commonPolylineCoords[0].latitude = 39.832136;
     commonPolylineCoords[0].longitude = 116.34095;
     
     commonPolylineCoords[1].latitude = 39.832136;
     commonPolylineCoords[1].longitude = 116.42095;
     
     commonPolylineCoords[2].latitude = 39.902136;
     commonPolylineCoords[2].longitude = 116.42095;
     
     commonPolylineCoords[3].latitude = 39.902136;
     commonPolylineCoords[3].longitude = 116.44095;
     */
    // 构造折线对象
    //    MAPolyline *commonPolyLine = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:4];
    // 地图上添加折线对象
    //    [_mapView addOverlay:commonPolyLine];
    
    /// 10.绘制圆：MACircle （由经纬度和半径构成）
    //    _circle = [MACircle circleWithCenterCoordinate:commonPolylineCoords[0] radius:6000];
    //    [_mapView addOverlay:_circle];
    
    /// 11.搜索POI（兴趣点）
    
    // 1) 初始化
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    // 2）设置关键字检索参数
    request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.cityLimit = YES;
    request.requireSubPOIs = YES;
    //    request.city = @"上海";
    //    request.types = @"商场";
    // 3) 发起POI搜索
    //    [self.search AMapPOIKeywordsSearch:request];
    [self sendRequest];
    
    
    /// 12.设置周边检索
    /*
     self.search = [[AMapSearchAPI alloc]init];
     self.search.delegate = self;
     _aroundRequest = [[AMapPOIAroundSearchRequest alloc] init];
     _aroundRequest.location = [AMapGeoPoint locationWithLatitude:31.294267000000001 longitude:121.440347];
     _aroundRequest.keywords = @"美食";
     _aroundRequest.sortrule = NO;    // 按距离排序
     _aroundRequest.requireExtension = YES;   // 是否返回扩展信息
     [self.search AMapPOIAroundSearch:_aroundRequest];
     */
    
    /// 13.设置多边形检索
    /*
     self.search = [[AMapSearchAPI alloc] init];
     self.search.delegate = self;
     // 设置检索参数
     // 将要传入的多边形的点
     NSArray *points = [NSArray arrayWithObjects:
     [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476],
     [AMapGeoPoint locationWithLatitude:39.890459 longitude:116.581476],
     nil];
     // 实例化多边形
     AMapGeoPolygon *polygon = [AMapGeoPolygon polygonWithPoints:points];
     // 多边形检索请求
     AMapPOIPolygonSearchRequest *polygonSearchRequest = [[AMapPOIPolygonSearchRequest alloc] init];
     polygonSearchRequest.polygon = polygon;
     polygonSearchRequest.keywords = @"美食";
     polygonSearchRequest.requireExtension = YES;    // 是否返回扩展信息
     [self.search AMapPOIPolygonSearch:polygonSearchRequest];
     */
    
    /// 14.通过podid搜索
    /*
     self.search = [[AMapSearchAPI alloc] init];
     self.search.delegate = self;
     AMapPOIIDSearchRequest *idRequset = [[AMapPOIIDSearchRequest alloc] init];
     idRequset.uid = @"B000A8WBJ0";
     idRequset.requireExtension = YES;
     [self.search AMapPOIIDSearch:idRequset];
     */
    
    /// 15.根据输入给出提示语
    /*
     self.search = [[AMapSearchAPI alloc] init];
     self.search.delegate = self;
     AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
     tipsRequest.keywords = @"宝尊电商";
     tipsRequest.city = @"上海";
     tipsRequest.cityLimit = YES;
     [self.search AMapInputTipsSearch:tipsRequest];
     */
    
    /// 16.地理编码（地址转坐标）
    /*
     self.search = [[AMapSearchAPI alloc] init];
     self.search.delegate = self;
     AMapGeocodeSearchRequest *geocodeRequest = [[AMapGeocodeSearchRequest alloc] init];
     geocodeRequest.address = @"上海市静安区万荣路1268号"; // 设置地理编码参数
     [self.search AMapGeocodeSearch:geocodeRequest];       // 发起地理编码查询
     
     */
    
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    //    [self.view addGestureRecognizer:tap];
    _mapView.showsUserLocation = YES;
    //    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    
    [self.view addSubview:self.mainTableView];
}

- (void)tapClick{
    //    [self hiddenKeyboard];
    //    [self showOrHiddenTypeView];
    //    [self showOrHiddenCityView];
}




- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.mapView.showTraffic = NO;
    
    // 标注大头针
    //    pointAnnotation = [[MAPointAnnotation alloc] init];
    //    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
    //    pointAnnotation.title = @"宝尊电商";
    //    pointAnnotation.subtitle = @"云立方B栋";
    //    [_mapView addAnnotation:pointAnnotation];
    //
    //    [self.poiAnnotations addObject:pointAnnotation];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.mapView.showTraffic = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MAMapViewDelegate

/// 1.绘制标注图
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        CustomMAAnnotationView *annotationView = (CustomMAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = (CustomMAAnnotationView *)[[CustomMAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        // 系统自带
        
        //        annotationView.canShowCallout = YES;    // 设置气泡可以弹出，默认为NO
        //        annotationView.animatesDrop = YES;      // 设置标注动画显示，默认为NO
        //        annotationView.draggable = YES;         // 设置标注可以拖动，默认为NO
        //        annotationView.pinColor = MAPinAnnotationColorPurple;
        // 自定义图片
        annotationView.image = [UIImage imageNamed:@"ic_location@2x.png"];
        //        annotationView.backgroundColor = [UIColor blackColor];x
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
//        annotationView setsel
        [self.customViewArray addObject:annotationView];
        return annotationView;
    }
    return nil;
}

/// 2.绘制折线图、圆 MAOverlay:多有地图覆盖层的基类
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineRenderer *polyLineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        polyLineRenderer.lineWidth = 6.0f;
        polyLineRenderer.strokeColor = [UIColor blueColor];
        polyLineRenderer.lineJoinType = kMALineJoinRound;
        polyLineRenderer.lineCapType = kMALineCapRound;
        return polyLineRenderer;
    }
    
    if ([overlay isKindOfClass:[MACircle class]]) {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        //        circleRenderer.lineWidth = 6.0f;
        //        circleRenderer.strokeColor = [UIColor redColor];
        //        circleRenderer.fillColor = [UIColor clearColor];
        return circleRenderer;
    }
    return nil;
}

/// 3.当位置更新时，会进定位回调，通过回调函数，能获取到定位点的经纬度坐标，示例代码如下：
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    //    _aroundRequest.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        _circle.coordinate = userLocation.coordinate;
        _circle.radius = 600;
        //        _aroundRequest.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        pointAnnotation.coordinate = userLocation.coordinate;
    }
}

/// 4.检索成功，在回调中处理POI：当检索成功时，会进到 onPOISearchDone 回调函数中，通过解析 AMapPOISearchResponse 对象把检索结果在地图上绘制点展示出来
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if (response.pois.count == 0) {
        return;
    }
    
    // 说明:
    /*
     1）可以在回调中解析 response，获取 POI 信息。
     2）response.pois 可以获取到 AMapPOI 列表，POI 详细信息可参考 AMapPOI 类。
     3）若当前城市查询不到所需 POI 信息，可以通过 response.suggestion.cities 获取当前 POI 搜索的建议城市。
     4）如果搜索关键字明显为误输入，则可通过 response.suggestion.keywords 属性得到搜索关键词建议。
     */
    [self.mapView removeAnnotations:_poiAnnotations];
    [_mainDataArray removeAllObjects];
    [_customViewArray removeAllObjects];
    [_mainSubTitleArray removeAllObjects];
    [_poiAnnotations removeAllObjects];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        [annotation setCoordinate:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
        [annotation setTitle:obj.name];
        [annotation setSubtitle:obj.address];
        
//        NSString *str = [NSString stringWithFormat:@"%@ —— %@",obj.name,obj.address];
        [self.mainDataArray addObject:obj.name];
        [self.mainSubTitleArray addObject:obj.address];
        [_poiAnnotations addObject:annotation];
    }];

    [self showPOIAnnotations];
    [self.mainTableView reloadData];
}

- (void)showPOIAnnotations
{
    [self.mapView addAnnotations:_poiAnnotations];
    
    if (_poiAnnotations.count == 1)
    {
        self.mapView.centerCoordinate = [(MAPointAnnotation *)_poiAnnotations[0] coordinate];
    }
    else
    {
        [self.mapView showAnnotations:_poiAnnotations animated:YES];
    }
}

/// 输入提示语
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    NSLog(@"dddd");
    if (response.tips.count == 0) {
        return;
    }
    [self.mapView removeAnnotations:_poiAnnotations];
    [_poiAnnotations removeAllObjects];
    
    [response.tips enumerateObjectsUsingBlock:^(AMapTip * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        //        [pointAnnotation setCoordinate:CLLocationCoordinate2DMake(obj.location.longitude, obj.location.latitude)];
        [annotation setCoordinate:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
        [annotation setTitle:obj.name];
        [annotation setSubtitle:obj.address];
        [_poiAnnotations addObject:annotation];
    }];
    
    [self showPOIAnnotations];
}

/// 检索失败
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"error = %@",error.userInfo);
}

/// 地理编码查询
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    if (response.geocodes.count == 0) {
        return;
    }
    
    [self.mapView removeAnnotations:_poiAnnotations];
    [_poiAnnotations removeAllObjects];
    [_poiAnnotations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        //        [annotation setCoordinate:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
        //        annotation.title = obj.formattedAddress;
        [_poiAnnotations addObject:annotation];
        
    }];
    [self showPOIAnnotations];
}

#pragma mark - 设置检索关键字
// 1.设置关键字的城市
- (void)requestForCity:(NSString *)cityStr{
    _cityStr = cityStr;
    [self showOrHiddenCityView];
    [cityBtn setTitle:cityStr forState:UIControlStateNormal];
    [self sendRequest];
    
}
// 2.设置关键字
- (void)requestOfKeywords:(NSString *)keyWords{
    _keywords = keyWords == nil ? @"": keyWords;
    [self sendRequest];
}

// 3.设置搜搜分类
- (void)requestOfTypes:(NSString *)typeStr{
    _typeStr = typeStr;
    [self showOrHiddenTypeView];
    [typeBtn setTitle:typeStr forState:UIControlStateNormal];
    [self sendRequest];
}
// 4.发起请求
- (void)sendRequest{
    [self hiddenKeyboard];
    request.keywords = _keywords;
    request.city = _cityStr;
    request.types = _typeStr;
    [self.search AMapPOIKeywordsSearch:request];
}
#pragma mark - 城市列表隐藏或显示
- (void)showOrHiddenCityView{
    if (self.cityView.hidden == YES) {
        self.cityView.hidden = NO;
    }else{
        self.cityView.hidden = YES;
    }
}

#pragma mark - 隐藏或显示分类视图
- (void)showOrHiddenTypeView{
    if (self.typeView.hidden == YES) {
        self.typeView.hidden = NO;
    }else{
        self.typeView.hidden = YES;
    }
}

#pragma mark - 隐藏键盘
- (void)hiddenKeyboard{
    [self.view endEditing:YES];
}


-(void)dealloc{
    NSLog(@"释放？？？");
}

@end
