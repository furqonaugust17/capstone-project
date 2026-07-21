import { useEffect, useRef } from 'react';

export function useAutoRefresh(
  callback: () => void,
  intervalMs: number | null,
) {
  const savedCallback = useRef(callback);

  useEffect(() => {
    savedCallback.current = callback;
  }, [callback]);

  useEffect(() => {
    if (!intervalMs) return;

    const tick = () => {
      // Don't refresh if tab is hidden
      if (!document.hidden) {
        savedCallback.current();
      }
    };

    const id = setInterval(tick, intervalMs);
    return () => clearInterval(id);
  }, [intervalMs]);
}
