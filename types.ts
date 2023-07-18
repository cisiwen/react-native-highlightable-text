import { ColorValue, StyleProp, TextStyle } from 'react-native';

export interface Highlight {
  start: number;
  end: number;
  id: string;
  color?: ColorValue;
}

export type onHighlightPressIOSNativeEvent = {
  nativeEvent: { clickedRangeStart: number; clickedRangeEnd: number };
};

export interface Selection {
  start: number;
  end: number;
  rect: {
    x: number;
    y: number;
    width: number;
    height: number;
  };
}

export interface SelectionChangeNativeEvent {
  nativeEvent: { selection: Selection };
}

export type RNSelectableTextProps = {
  children: any;
  style: StyleProp<TextStyle>;
  onHighlightPress: (event: onHighlightPressIOSNativeEvent) => void;
  onTextSelectionChange: (event: SelectionChangeNativeEvent) => void;
};
