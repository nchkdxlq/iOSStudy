//
//  NKLabel.h
//  iOSStudy
//
//  Created by Knox on 2020/12/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NKLabel : UIView

@property (nullable, nonatomic, copy) NSString *text; // default is nil

@property (nullable, nonatomic, copy) NSAttributedString *attributedText; // default is nil

@property (nullable, nonatomic, strong) UIColor *textColor;

@property (nullable, nonatomic, strong) UIFont *font;

@property (nonatomic, assign) NSInteger numberOfLine;

@end

NS_ASSUME_NONNULL_END
