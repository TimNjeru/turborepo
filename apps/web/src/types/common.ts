/**
 * Common types used throughout the application
 */

/**
 * Generic API response wrapper
 */
export interface ApiResponse<T = unknown> {
  data: T;
  success: boolean;
  message?: string;
  error?: string;
}

/**
 * Pagination parameters
 */
export interface PaginationParams {
  page: number;
  limit: number;
  offset?: number;
}

/**
 * Paginated response
 */
export interface PaginatedResponse<T> extends ApiResponse<T[]> {
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
    hasNext: boolean;
    hasPrev: boolean;
  };
}

/**
 * Theme types
 */
export type Theme = 'light' | 'dark' | 'system';

/**
 * Size variants for UI components
 */
export type Size = 'xs' | 'sm' | 'md' | 'lg' | 'xl';

/**
 * Color variants for UI components
 */
export type Color = 'primary' | 'secondary' | 'success' | 'warning' | 'error' | 'info';

/**
 * Button variants
 */
export type ButtonVariant = 'filled' | 'outline' | 'subtle' | 'light' | 'gradient';

/**
 * Loading states
 */
export type LoadingState = 'idle' | 'loading' | 'success' | 'error';

/**
 * Generic loading state with data
 */
export interface LoadingStateWithData<T = unknown> {
  state: LoadingState;
  data?: T;
  error?: string;
}

/**
 * Form field validation
 */
export interface ValidationError {
  field: string;
  message: string;
}

/**
 * Form state
 */
export interface FormState<T = Record<string, unknown>> {
  values: T;
  errors: ValidationError[];
  isSubmitting: boolean;
  isDirty: boolean;
  isValid: boolean;
}

/**
 * Modal/Dialog state
 */
export interface ModalState {
  isOpen: boolean;
  title?: string;
  content?: React.ReactNode;
  onClose?: () => void;
}

/**
 * Toast notification
 */
export interface ToastNotification {
  id: string;
  type: 'success' | 'error' | 'warning' | 'info';
  title: string;
  message?: string;
  duration?: number;
  action?: {
    label: string;
    onClick: () => void;
  };
}

/**
 * User preferences
 */
export interface UserPreferences {
  theme: Theme;
  language: string;
  notifications: {
    email: boolean;
    push: boolean;
    inApp: boolean;
  };
  privacy: {
    analytics: boolean;
    cookies: boolean;
  };
}

/**
 * Navigation item
 */
export interface NavigationItem {
  id: string;
  label: string;
  href: string;
  icon?: React.ComponentType<{ size?: number; className?: string }>;
  children?: NavigationItem[];
  external?: boolean;
  disabled?: boolean;
}

/**
 * Breadcrumb item
 */
export interface BreadcrumbItem {
  label: string;
  href?: string;
  current?: boolean;
}

/**
 * Table column definition
 */
export interface TableColumn<T = unknown> {
  key: keyof T | string;
  title: string;
  dataIndex?: keyof T;
  render?: (value: unknown, record: T, index: number) => React.ReactNode;
  sortable?: boolean;
  filterable?: boolean;
  width?: number | string;
  align?: 'left' | 'center' | 'right';
}

/**
 * Sort configuration
 */
export interface SortConfig {
  key: string;
  direction: 'asc' | 'desc';
}

/**
 * Filter configuration
 */
export interface FilterConfig {
  key: string;
  value: unknown;
  operator: 'equals' | 'contains' | 'startsWith' | 'endsWith' | 'gt' | 'lt' | 'gte' | 'lte';
}