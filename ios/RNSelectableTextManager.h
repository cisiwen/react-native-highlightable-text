#if __has_include(<RCTText/RCTBaseTextInputViewManager.h>)
#import <RCTText/RCTBaseTextInputViewManager.h>
#else
#import "RCTBaseTextInputViewManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface RNSelectableTextManager : RCTBaseTextInputViewManager

@property (nonnull, nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSArray<NSDictionary *> *highlights;
@property (nonatomic, copy) RCTDirectEventBlock onWordPress;
@property (nonatomic, copy) RCTDirectEventBlock onTextSelectionChange;
@property (nonatomic, copy) RCTDirectEventBlock onHighlightRectsCalculated;

@end

NS_ASSUME_NONNULL_END
