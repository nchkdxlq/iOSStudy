//
//  NKChatListViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/12/8.
//

#import "NKChatListViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "NKChat.h"
#import "iOSStudy-Swift.h"
#import "UINavigationBar+NKExtension.h"

@interface NKChatListViewController () <ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) ASTableNode *tableNode;

@property (nonatomic, strong) NSArray<NKChat *> *chatList;

@property (nonatomic, strong) NSMutableArray<NKChatCellNode *> *nodeList;

@property (nonatomic, strong) NSMutableSet<NSIndexPath *> *avoidFlickerIndexPaths;

@end

@implementation NKChatListViewController

- (NSMutableSet<NSIndexPath *> *)avoidFlickerIndexPaths {
    if (_avoidFlickerIndexPaths == nil) {
        _avoidFlickerIndexPaths = [NSMutableSet set];
    }
    return _avoidFlickerIndexPaths;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.node.backgroundColor = [UIColor whiteColor];
    
    [self setupTableNode];
    [self loadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat offSetY = 1371;
        self.tableNode.contentOffset = CGPointMake(0, offSetY);
    });
}

- (void)setupTableNode {
    self.tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    self.tableNode.view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableNode.contentInset = UIEdgeInsetsMake(0, 0, UIWindow.keyWindowSafeAreaInset.bottom, 0);
    self.tableNode.automaticallyAdjustsContentOffset = NO;
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
    [self.node addSubnode:self.tableNode];
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat offSetX = [self.navigationController.navigationBar fullHeight];
    self.tableNode.frame = CGRectMake(0, offSetX, width, height - offSetX);
}

- (void)loadData {
    NKChat *chat1 = [NKChat new];
    chat1.identifier = NSUUID.UUID.UUIDString;
    chat1.name = @"张学友 - 四大天王";
    chat1.avatar = @"天空_草坪";
    chat1.desc = @"明天就周末了，有什么安排呀？明天就周末了，有什么安排呀？明天就周末了，有什么安排呀？明天就周末了，有什么安排呀？";
    chat1.updateTime = [NSDate date];
    self.chatList = @[chat1];
    
    NSInteger count = 30;
    NSMutableArray<NKChatCellNode *> *nodeList = [NSMutableArray arrayWithCapacity:count];
    while (count > 0) {
        count--;
        NKChatCellNode *cellNode = [[NKChatCellNode alloc] initWithChat:chat1];
        [nodeList addObject:cellNode];
    }
    self.nodeList = nodeList;
}


- (void)reloadIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (indexPaths.count == 0) return;
    
    [self.avoidFlickerIndexPaths addObjectsFromArray:indexPaths];
    [self.tableNode reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - ASTableDelegate

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return 30; // self.chatList.count;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableNode deselectRowAtIndexPath:indexPath animated:false];
    NSLog(@"indexPath = %@", indexPath);
    
    if (indexPath.row == 0) {
        [self reloadIndexPaths:[tableNode indexPathsForVisibleRows]];
    } else {
        [self reloadIndexPaths:@[indexPath]];
    }
}


- (void)reloadIndexPath_v1:(NSIndexPath *)indexPath {
    
    [self.tableNode reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)reloadIndexPath_v2:(NSIndexPath *)indexPath {
    NKChat *chat1 = [NKChat new];
    chat1.identifier = NSUUID.UUID.UUIDString;
    chat1.name = @"张学友 - 四大天王";
    chat1.avatar = @"天空_草坪";
    chat1.desc = [NSString stringWithFormat:@"%u - 明天就周末了，有什么安排呀？", arc4random() % 100];
    chat1.updateTime = [NSDate date];
    NKChatCellNode *cellNode = [[NKChatCellNode alloc] initWithChat:chat1];
    cellNode.neverShowPlaceholders = YES;
    self.nodeList[indexPath.row] = cellNode;

    [self.tableNode reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // NSLog(@"contentOffset = %@", NSStringFromCGPoint(scrollView.contentOffset));
}


#pragma mark - ASTableDataSource


- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
#if 1
    NKChat *chat = self.chatList.firstObject;
    NKChatCellNode *cellNode = [[NKChatCellNode alloc] initWithChat:chat];
    if ([self.avoidFlickerIndexPaths containsObject:indexPath]) {
        cellNode.neverShowPlaceholders = YES;
        [self.avoidFlickerIndexPaths removeObject:indexPath];
    }
    return cellNode;
#else
    // 复用node 可以解决 reloadData cell闪烁问题
    return self.nodeList[indexPath.row];
#endif
}

@end
