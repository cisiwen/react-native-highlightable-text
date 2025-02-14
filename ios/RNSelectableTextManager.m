#import "RNSelectableTextView.h"
#import "RNSelectableTextManager.h"

@implementation RNSelectableTextManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
    RNSelectableTextView *selectable = [[RNSelectableTextView alloc] initWithBridge:self.bridge];
    return selectable;
}

RCT_EXPORT_VIEW_PROPERTY(value, NSString);
RCT_EXPORT_VIEW_PROPERTY(highlights, NSArray<NSDictionary *>);
RCT_EXPORT_VIEW_PROPERTY(onWordPress, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTextSelectionChange, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onHighlightRectsCalculated, RCTDirectEventBlock)

#pragma mark - Multiline <TextInput> (aka TextView) specific properties

#if !TARGET_OS_TV
RCT_REMAP_VIEW_PROPERTY(dataDetectorTypes, backedTextInputView.dataDetectorTypes, UIDataDetectorTypes)
#endif

@end
