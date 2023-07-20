import React, { ReactNode } from 'react';
import {
  ColorValue,
  Platform,
  StyleProp,
  Text,
  TextStyle,
  requireNativeComponent,
} from 'react-native';
import { v4 } from 'uuid';
import {
  Highlight,
  HighlightRectsCalculatedNativeEvent,
  RNSelectableTextProps,
  Selection,
  SelectionChangeNativeEvent,
  onWordPressIOSNativeEvent,
} from './types';
import { combineHighlights, mapHighlightsRanges } from './utils';

const RNSelectableText =
  requireNativeComponent<RNSelectableTextProps>('RNSelectableText');

interface HighlightableTextProps {
  value: string;
  style?: StyleProp<TextStyle>;
  highlights: Highlight[];
  highlightColor?: ColorValue;
  prependToChild?: ReactNode;
  appendToChildren?: ReactNode;
  onWordPress?: (event: onWordPressIOSNativeEvent['nativeEvent']) => void;
  onSelectionChange?: (selection: Selection) => void;
  onHighlightPress?: (id: string) => void;
  onHighlightRectsCalculated?: (
    event: HighlightRectsCalculatedNativeEvent
  ) => void;
}

export const HighlightableText = ({
  value,
  style,
  highlights,
  highlightColor,
  prependToChild,
  appendToChildren,
  onWordPress,
  onSelectionChange,
  onHighlightPress,
  onHighlightRectsCalculated,
}: HighlightableTextProps) => {
  const onSelectionNative = (event: SelectionChangeNativeEvent) => {
    onSelectionChange?.(event.nativeEvent.selection);
  };

  const onWordPressNative = (event: onWordPressIOSNativeEvent) => {
    if (highlights.length === 0) {
      onWordPress?.(event.nativeEvent);
      return;
    }

    const { clickedRangeStart, clickedRangeEnd } = event.nativeEvent;
    const mergedHighlights = combineHighlights(highlights);

    const highlightInRange = mergedHighlights.find(
      ({ start, end }) =>
        clickedRangeStart >= start - 1 && clickedRangeEnd <= end + 1
    );

    if (highlightInRange) {
      onHighlightPress?.(highlightInRange.id);
    } else {
      onWordPress?.(event.nativeEvent);
    }
  };

  let textValue: ReactNode[] = [value];

  if (highlights.length > 0) {
    textValue = mapHighlightsRanges(value, highlights).map(
      ({ id, isHighlight, text, color }) => (
        <Text
          key={v4()}
          selectable
          style={
            isHighlight ? { backgroundColor: color ?? highlightColor } : {}
          }
          onPress={isHighlight ? () => onHighlightPress?.(id ?? '') : undefined}
        >
          {text}
        </Text>
      )
    );
  }

  if (appendToChildren) {
    textValue.push(appendToChildren);
  }

  if (prependToChild) textValue = [prependToChild, ...textValue];

  return (
    <RNSelectableText
      // change key to force re-render whenever highlights change
      key={JSON.stringify(highlights)}
      style={style}
      highlights={highlights}
      onWordPress={Platform.OS === 'ios' ? onWordPressNative : () => {}}
      onTextSelectionChange={onSelectionNative}
      onHighlightRectsCalculated={onHighlightRectsCalculated}
    >
      <Text>{textValue}</Text>
    </RNSelectableText>
  );
};
