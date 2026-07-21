import { useState, useCallback } from 'react';
import { toast } from 'sonner';

export function useApi<T, P extends any[]>(
  apiFunction: (...args: P) => Promise<T>,
  options?: {
    onSuccess?: (data: T) => void;
    onError?: (error: any) => void;
    successMessage?: string;
  }
) {
  const [data, setData] = useState<T | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [error, setError] = useState<any>(null);

  const execute = useCallback(
    async (...args: P) => {
      try {
        setIsLoading(true);
        setError(null);
        const result = await apiFunction(...args);
        setData(result);
        if (options?.successMessage) {
          toast.success(options.successMessage);
        }
        if (options?.onSuccess) {
          options.onSuccess(result);
        }
        return result;
      } catch (err: any) {
        setError(err);
        const message = err.response?.data?.message || err.message || 'An error occurred';
        toast.error(message);
        if (options?.onError) {
          options.onError(err);
        }
        throw err;
      } finally {
        setIsLoading(false);
      }
    },
    [apiFunction, options]
  );

  return {
    data,
    isLoading,
    error,
    execute,
    setData,
  };
}
