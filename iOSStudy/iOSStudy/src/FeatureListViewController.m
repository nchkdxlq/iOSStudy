//
//  FeatureListViewController.m
//  iOSStudy
//
//  Created by Knox on 2020/12/27.
//

#import "FeatureListViewController.h"
#import "YYKitViewController.h"
#import "MDHTMLViewController.h"
#import "NKTextViewController.h"
#import "SDWebImageViewController.h"
#import "NKRunLoopViewController.h"
#import "NKGCDViewController.h"
#import "NKTimerViewController.h"

#import "LaunchImageHelper.h"

static NSString * const kDataSourceClassKey = @"dataSourceClassKey";
static NSString * const kDataSourceTitleKey = @"dataSourceTitleKey";

@interface FeatureListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, id> *> *dataSource;

@end

@implementation FeatureListViewController


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FeatureList";
    
    [self setupSubView];
    
    [self setupData];
    
    [NSRunLoop currentRunLoop];
}

- (void)setupSubView {
    [self.view addSubview:self.tableView];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}



- (void)setupData {
    _dataSource = @[
                    @{kDataSourceClassKey:YYKitViewController.class, kDataSourceTitleKey:@"YYKit"},
                    @{kDataSourceClassKey:MDHTMLViewController.class, kDataSourceTitleKey:@"MDHTMLLabel"},
                    @{kDataSourceClassKey:NKTextViewController.class, kDataSourceTitleKey:@"NKText"},
                    @{kDataSourceClassKey:SDWebImageViewController.class, kDataSourceTitleKey:@"SDWebImage"},
                    @{kDataSourceClassKey:NKRunLoopViewController.class, kDataSourceTitleKey:@"RunLoop"},
                    @{kDataSourceClassKey:NKGCDViewController.class, kDataSourceTitleKey:@"GCD"},
                    @{kDataSourceClassKey:NKTimerViewController.class, kDataSourceTitleKey:@"Timer"}
                ];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Class vcClass = [self viewControllerClassTypeAtIndexPath:indexPath];
    if (vcClass) {
        UIViewController *vc = [[vcClass alloc] init];
        vc.title = [self titleAtIndexPath:indexPath];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = [self titleAtIndexPath:indexPath];
    return cell;
}



- (Class)viewControllerClassTypeAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource[indexPath.row] objectForKey:kDataSourceClassKey];
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource[indexPath.row] objectForKey:kDataSourceTitleKey];
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
