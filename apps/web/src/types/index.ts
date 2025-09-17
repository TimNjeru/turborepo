/**
 * Type definitions for the web application
 * 
 * This file exports all types from the types directory for easy importing
 */

// Allotment component types
export * from './allotment';

// Common types used across the application
export * from './common';

// Application-specific types
export * from './app';

// Re-export commonly used React types for convenience
export type { ReactNode, ComponentType, CSSProperties } from 'react';