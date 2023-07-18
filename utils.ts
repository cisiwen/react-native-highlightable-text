import memoize from 'fast-memoize';
import { Highlight } from './types';

export const combineHighlights = memoize((numbers: Highlight[]) => {
  return numbers
    .sort((a, b) => a.start - b.start || a.end - b.end)
    .reduce(function (combined, next) {
      if (!combined.length || combined[combined.length - 1].end < next.start) {
        combined.push(next);
      } else {
        const prev = combined.pop();
        if (prev) {
          combined.push({
            start: prev.start,
            end: Math.max(prev.end, next.end),
            id: next.id,
            color: prev.color,
          });
        }
      }
      return combined;
    }, [] as Highlight[]);
});

export const mapHighlightsRanges = (value: string, highlights: Highlight[]) => {
  const combinedHighlights = combineHighlights(highlights);

  if (combinedHighlights.length === 0)
    return [
      { isHighlight: false, text: value, id: undefined, color: undefined },
    ];

  const data = [
    {
      isHighlight: false,
      text: value.slice(0, combinedHighlights[0].start),
      id: combinedHighlights[0].id,
      color: combinedHighlights[0].color,
    },
  ];

  combinedHighlights.forEach(({ start, end, id, color }, idx) => {
    data.push({
      isHighlight: true,
      text: value.slice(start, end),
      id: id,
      color: color,
    });

    if (combinedHighlights[idx + 1]) {
      data.push({
        isHighlight: false,
        text: value.slice(end, combinedHighlights[idx + 1].start),
        id: combinedHighlights[idx + 1].id,
        color: combinedHighlights[idx + 1].color,
      });
    }
  });

  data.push({
    isHighlight: false,
    text: value.slice(
      combinedHighlights[combinedHighlights.length - 1].end,
      value.length
    ),
    id: combinedHighlights[combinedHighlights.length - 1].id,
    color: combinedHighlights[combinedHighlights.length - 1].color,
  });

  return data.filter((x) => x.text);
};
