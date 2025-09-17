# Types Directory

This directory contains all TypeScript type definitions for the web application.

## Structure

- `allotment.ts` - Types for the Allotment split-pane component
- `common.ts` - Common types used across the application
- `app.ts` - Application-specific types
- `index.ts` - Main export file for all types

## Usage

Import types from the main index file:

```typescript
import { AllotmentRef, Theme, ApiResponse } from '../types';
```

Or import specific types from individual files:

```typescript
import { AllotmentRef } from '../types/allotment';
import { Theme } from '../types/common';
```

## Type Categories

### Allotment Types
- `AllotmentRef` - Reference type for Allotment component methods
- `AllotmentProps` - Props for the main Allotment component
- `AllotmentPaneProps` - Props for individual panes

### Common Types
- `ApiResponse<T>` - Generic API response wrapper
- `PaginationParams` - Pagination parameters
- `Theme` - Theme variants (light, dark, system)
- `Size` - Size variants for UI components
- `Color` - Color variants for UI components
- `LoadingState` - Loading state management
- `FormState<T>` - Form state management
- `ToastNotification` - Toast notification structure

### App Types
- `AppConfig` - Application configuration
- `PageMetadata` - Page metadata for SEO
- `LayoutProps` - Layout component props
- `BaseComponentProps` - Base props for all components
- `AllotmentDemoConfig` - Configuration for Allotment demo
- `AppState` - Global application state
- `AppContextType` - React context type for app state

## Best Practices

1. **Use specific types** - Avoid `any` type, use proper TypeScript types
2. **Generic types** - Use generics for reusable type definitions
3. **Optional properties** - Use `?` for optional properties
4. **Union types** - Use union types for variants (e.g., `'light' | 'dark'`)
5. **Interface extension** - Extend interfaces when building upon existing types
6. **Documentation** - Add JSDoc comments for complex types

## Adding New Types

When adding new types:

1. Determine the appropriate file (common.ts for general types, app.ts for app-specific)
2. Add JSDoc comments for documentation
3. Export from the main index.ts file
4. Update this README if adding new categories