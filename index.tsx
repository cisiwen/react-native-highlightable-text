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
  RNSelectableTextProps,
  Selection,
  SelectionChangeNativeEvent,
  onHighlightPressIOSNativeEvent,
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
  onSelectionChange?: (selection: Selection) => void;
  onHighlightPress?: (id: string) => void;
}

export const HighlightableText = ({
  value,
  style,
  highlights,
  highlightColor,
  prependToChild,
  appendToChildren,
  onSelectionChange,
  onHighlightPress,
}: HighlightableTextProps) => {
  const onSelectionNative = (event: SelectionChangeNativeEvent) => {
    onSelectionChange?.(event.nativeEvent.selection);
  };

  const onHighlightPressNative = (event: onHighlightPressIOSNativeEvent) => {
    if (highlights.length === 0) return;

    const { clickedRangeStart, clickedRangeEnd } = event.nativeEvent;
    const mergedHighlights = combineHighlights(highlights);

    const highlightInRange = mergedHighlights.find(
      ({ start, end }) =>
        clickedRangeStart >= start - 1 && clickedRangeEnd <= end + 1
    );

    if (highlightInRange) {
      onHighlightPress?.(highlightInRange.id);
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
      key={v4()}
      style={style}
      onHighlightPress={
        Platform.OS === 'ios' ? onHighlightPressNative : () => {}
      }
      onTextSelectionChange={onSelectionNative}
    >
      <Text>{textValue}</Text>
    </RNSelectableText>
  );
};
