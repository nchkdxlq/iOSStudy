//
//  NKChatListViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/12/8.
//

#import "NKChatListViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "NKChat.h"
#import "NKChatCellNode.h"

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
    
}


- (void)loadData {
    self.chatList = [NSArray new];
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
