#import <React/RCTTextSelection.h>
#import <React/RCTUITextView.h>
#import <React/RCTTextAttributes.h>
#import <React/RCTUtils.h>
#import <React/RCTBaseTextInputView.h>
#import <React/RCTMultilineTextInputView.h>


NS_ASSUME_NONNULL_BEGIN

@interface RNSelectableTextView : RCTBaseTextInputView <UITextViewDelegate>

@property (nonnull, nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSArray<NSDictionary *> *highlights;
@property (nonatomic, copy) RCTDirectEventBlock onWordPress;
@property (nonatomic, copy) RCTDirectEventBlock onTextSelectionChange;
@property (nonatomic, copy) RCTDirectEventBlock onHighlightRectsCalculated;

@end

NS_ASSUME_NONNULL_END
