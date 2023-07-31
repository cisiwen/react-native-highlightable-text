#import <React/RCTBaseTextInputViewManager.h>
NS_ASSUME_NONNULL_BEGIN

@interface RNSelectableTextManager : RCTBaseTextInputViewManager

@property (nonnull, nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSArray<NSDictionary *> *highlights;
@property (nonatomic, copy) RCTDirectEventBlock onWordPress;
@property (nonatomic, copy) RCTDirectEventBlock onTextSelectionChange;
@property (nonatomic, copy) RCTDirectEventBlock onHighlightRectsCalculated;

@end

NS_ASSUME_NONNULL_END
