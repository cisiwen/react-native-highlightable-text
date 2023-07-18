# react-native-highlightable-text

Highlightable React native Text View component, supports text selection and showing highlights.

## Demo

<img src="./assets/demo.gif" width="350px" />

## Usage

```javascript
import { HighlightableText } from '@vikalp_p/react-native-highlightable-text';

// Use normally, it is a drop-in replacement for react-native/Text
<HighlightableText
  value={`Lorem ipsum dolor sit amet consectetur adipisicing elit. Sint voluptatibus officiis nisi molestiae officia iure, magnam provident, perspiciatis fugiat ex dolorem! Commodi animi corporis dicta possimus ducimus perferendis, sequi consequuntur?`}
  style={contentStyle}
  highlights={highlights}
  highlightColor={'red'}
  onHighlightPress={onHighlightPress}
  onSelectionChange={onSelectionChange}
/>;
```

## Getting started

`$ npm install @vikalp_p/react-native-highlightable-text`
`$ cd ios && pod install`

## Props

| name                  | description                                                         | type                                        | default |
| --------------------- | ------------------------------------------------------------------- | ------------------------------------------- | ------- |
| **value**             | text content                                                        | string                                      | ""      |
| **style**             | additional styles to be applied to text                             | Object                                      |         |
| **highlights**        | array of text ranges that should be highlighted with an optional id | array({ id: string, start: int, end: int }) | []      |
| **highlightColor**    | highlight color                                                     | string                                      |         |
| **onSelectionChange** | Called when the text selection changes                              | (event: Selection) => void                  |         |
| **onHighlightPress**  | called when the user taps the highlight                             | (id: string) => void                        |         |
| **appendToChildren**  | element to be added in the last line of text                        | ReactNode                                   |         |
