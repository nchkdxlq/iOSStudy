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

@end

@implementation NKChatListViewController

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
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat offSetX = [self.navigationController.navigationBar fullHeight];
    self.tableNode.view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableNode.automaticallyAdjustsContentOffset = NO;
    self.tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    [self.node addSubnode:self.tableNode];
    self.tableNode.frame = CGRectMake(0, offSetX, width, height - offSetX);
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
}

- (void)loadData {
    NKChat *chat1 = [NKChat new];
    chat1.identifier = NSUUID.UUID.UUIDString;
    chat1.name = @"张学友 - 四大天王";
    chat1.avatar = @"天空_草坪";
    chat1.desc = @"明天就周末了，有什么安排呀？明天就周末了，有什么安排呀？明天就周末了，有什么安排呀？明天就周末了，有什么安排呀？";
    chat1.updateTime = [NSDate date];
    self.chatList = @[chat1];
}

#pragma mark - ASTableDelegate

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return 30; // self.chatList.count;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableNode deselectRowAtIndexPath:indexPath animated:false];
    NSLog(@"indexPath = %@", indexPath);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // NSLog(@"contentOffset = %@", NSStringFromCGPoint(scrollView.contentOffset));
}


#pragma mark - ASTableDataSource

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NKChat *chat = self.chatList[indexPath.row];
    NKChat *chat = self.chatList.firstObject;
    return ^{
        NKChatCellNode *cellNode = [[NKChatCellNode alloc] initWithChat:chat];
        return cellNode;
    };
}


@end
