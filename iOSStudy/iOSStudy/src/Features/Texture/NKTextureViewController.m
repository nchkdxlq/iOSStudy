//
//  NKTextureViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/12/7.
//

#import "NKTextureViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "ASTextNodeViewController.h"
#import "NKChatListViewController.h"

@interface NKCatogaryItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong, nullable) Class class;

+ (instancetype)itemWithTitle:(NSString *)title class:(nullable Class)cls;

@end

@implementation NKCatogaryItem

+ (instancetype)itemWithTitle:(NSString *)title class:(Class)cls {
    NKCatogaryItem *item = [NKCatogaryItem new];
    item.title = title;
    item.class = cls;
    return item;
}

@end

/////////////////////////////////////////////

@interface NKTextureViewController () <ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) NSArray<NKCatogaryItem *> *dataSource;

@end

@implementation NKTextureViewController

- (instancetype)init {
    self = [super initWithNode:[ASTableNode new]];
    if (self) {
        self.node.delegate = self;
        self.node.dataSource = self;
        _dataSource = @[
            [NKCatogaryItem itemWithTitle:@"ASTextNode" class:ASTextNodeViewController.class],
            [NKCatogaryItem itemWithTitle:@"Chat" class:NKChatListViewController.class],
            [NKCatogaryItem itemWithTitle:@"ASImageNode" class:nil]
        ];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Texture Catogaries";
    
}

#pragma mark - ASTableDelegate

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}


#pragma mark - ASTableDataSource

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    NKCatogaryItem *item = _dataSource[indexPath.row];
    return ^{
        ASTextCellNode *textCellNode = [ASTextCellNode new];
        textCellNode.text = item.title;
        return textCellNode;
    };
}


- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableNode deselectRowAtIndexPath:indexPath animated:YES];
    
    NKCatogaryItem *item = _dataSource[indexPath.row];
    if (item.class == nil) return;
    
    UIViewController *vc = [item.class new];
    vc.title = item.title;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
