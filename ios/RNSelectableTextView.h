#if __has_include(<RCTText/RCTBaseTextInputView.h>)
#import <RCTText/RCTBaseTextInputView.h>
#else
#import "RCTBaseTextInputView.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface RNSelectableTextView : RCTBaseTextInputView <UITextViewDelegate>

@property (nonnull, nonatomic, copy) NSString *value;
@property (nonatomic, copy) RCTDirectEventBlock onWordPress;
@property (nonatomic, copy) RCTDirectEventBlock onTextSelectionChange;

@end

NS_ASSUME_NONNULL_END
