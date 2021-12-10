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

@interface NKChatListViewController () <ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) NSArray<NKChat *> *chatList;

@end



@implementation NKChatListViewController

- (instancetype)init {
    self = [super initWithNode:[ASTableNode new]];
    if (self) {
        self.node.delegate = self;
        self.node.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self.node reloadData];
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
    return self.chatList.count;
}


#pragma mark - ASTableDataSource

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    NKChat *chat = self.chatList[indexPath.row];
    return ^{
        NKChatCellNode *cellNode = [[NKChatCellNode alloc] initWithChat:chat];
        return cellNode;
    };
}


@end
