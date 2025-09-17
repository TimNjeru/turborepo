/**
 * Application-specific types
 */

import { Theme } from './common';

/**
 * Application configuration
 */
export interface AppConfig {
  name: string;
  version: string;
  environment: 'development' | 'staging' | 'production';
  apiUrl: string;
  features: {
    darkMode: boolean;
    analytics: boolean;
    notifications: boolean;
    multiLanguage: boolean;
  };
}

/**
 * Page metadata
 */
export interface PageMetadata {
  title: string;
  description: string;
  keywords?: string[];
  ogImage?: string;
  noIndex?: boolean;
}

/**
 * Layout props
 */
export interface LayoutProps {
  children: React.ReactNode;
  metadata?: PageMetadata;
  className?: string;
}

/**
 * Component props with common styling
 */
export interface BaseComponentProps {
  className?: string;
  style?: React.CSSProperties;
  id?: string;
  'data-testid'?: string;
}

/**
 * Allotment demo specific types
 */
export interface AllotmentDemoConfig {
  defaultSizes: number[];
  minSizes: number[];
  maxSizes: number[];
  snapEnabled: boolean;
  vertical: boolean;
}

export interface PaneConfig {
  id: string;
  title: string;
  content: string;
  backgroundColor: string;
  minSize?: number;
  maxSize?: number;
  preferredSize?: number | string;
  snap?: boolean;
}

/**
 * Theme image props
 */
export interface ThemeImageProps {
  srcLight: string;
  srcDark: string;
  alt: string;
  width: number;
  height: number;
  className?: string;
  priority?: boolean;
}

/**
 * Button props with app-specific styling
 */
export interface AppButtonProps {
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  loading?: boolean;
  disabled?: boolean;
  onClick?: () => void;
  children: React.ReactNode;
  className?: string;
}

/**
 * Card component props
 */
export interface CardProps {
  title?: string;
  subtitle?: string;
  children: React.ReactNode;
  className?: string;
  hoverable?: boolean;
  clickable?: boolean;
  onClick?: () => void;
}

/**
 * Feature flag configuration
 */
export interface FeatureFlags {
  allotmentDemo: boolean;
  darkMode: boolean;
  analytics: boolean;
  notifications: boolean;
  experimentalFeatures: boolean;
}

/**
 * Application state
 */
export interface AppState {
  theme: Theme;
  featureFlags: FeatureFlags;
  isLoading: boolean;
  error: string | null;
  user: {
    isAuthenticated: boolean;
    preferences: Record<string, unknown>;
  } | null;
}

/**
 * Application context type
 */
export interface AppContextType {
  state: AppState;
  actions: {
    setTheme: (theme: Theme) => void;
    setLoading: (loading: boolean) => void;
    setError: (error: string | null) => void;
    toggleFeatureFlag: (flag: keyof FeatureFlags) => void;
  };
}