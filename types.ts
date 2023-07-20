import { ColorValue, StyleProp, TextStyle } from 'react-native';

export interface Highlight {
  start: number;
  end: number;
  id: string;
  color?: ColorValue;
}

export type onWordPressIOSNativeEvent = {
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

export interface HighlightRectsCalculatedNativeEvent {
  nativeEvent: {
    rects: Array<{
      id: string;
      rect: {
        x: number;
        y: number;
        width: number;
        height: number;
      };
    }>;
  };
}

export interface SelectionChangeNativeEvent {
  nativeEvent: { selection: Selection };
}

export type RNSelectableTextProps = {
  children: any;
  style: StyleProp<TextStyle>;
  highlights?: Highlight[];
  onWordPress: (event: onWordPressIOSNativeEvent) => void;
  onTextSelectionChange: (event: SelectionChangeNativeEvent) => void;
  onHighlightRectsCalculated?: (
    event: HighlightRectsCalculatedNativeEvent
  ) => void;
};
