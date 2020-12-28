//
//  NKTextLine.h
//  iOSStudy
//
//  Created by Knox on 2020/12/28.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>


NS_ASSUME_NONNULL_BEGIN

@interface NKTextLine : NSObject

@property (nonatomic, assign, readonly) CTLineRef CTLine; /// CoreText line
@property (nonatomic, assign, readonly) NSRange range; // string range

@property (nonatomic, assign, readonly) BOOL vertical;

@property (nonatomic, assign, readonly) CGRect bounds;
@property (nonatomic, assign, readonly) CGSize size;



@property (nonatomic, assign, readonly) CGFloat ascent;
@property (nonatomic, assign, readonly) CGFloat descent;
@property (nonatomic, assign, readonly) CGFloat leading;
@property (nonatomic, assign, readonly) CGFloat lineWidth;  ///< line width
@property (nonatomic, assign, readonly) CGFloat trailingWhitespaceWidth;

@property (nonatomic) CGPoint position;   ///< baseline position

+ (instancetype)lineWithCTLine:(CTLineRef)CTLine position:(CGPoint)position vertical:(BOOL)isVertical;



@end

NS_ASSUME_NONNULL_END
