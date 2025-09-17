/**
 * Types for the Allotment component
 */

export interface AllotmentRef {
  /**
   * Reset all panes to their default sizes
   */
  reset(): void;
  
  /**
   * Resize panes to specific sizes
   * @param sizes Array of sizes for each pane
   */
  resize(sizes: number[]): void;
  
  /**
   * Get current sizes of all panes
   * @returns Array of current pane sizes
   */
  getSizes(): number[];
}

export interface AllotmentPaneProps {
  /**
   * Minimum size of the pane in pixels
   */
  minSize?: number;
  
  /**
   * Maximum size of the pane in pixels
   */
  maxSize?: number;
  
  /**
   * Preferred size of the pane (can be a number in pixels or percentage string)
   */
  preferredSize?: number | string;
  
  /**
   * Whether the pane can be snapped to zero by double-clicking
   */
  snap?: boolean;
  
  /**
   * Whether the pane is visible
   */
  visible?: boolean;
  
  /**
   * Children to render in the pane
   */
  children?: React.ReactNode;
}

export interface AllotmentProps {
  /**
   * Ref to access Allotment methods
   */
  ref?: React.Ref<AllotmentRef>;
  
  /**
   * Default sizes for panes (array of numbers)
   */
  defaultSizes?: number[];
  
  /**
   * Whether the splitter is vertical (default: false for horizontal)
   */
  vertical?: boolean;
  
  /**
   * Whether to show the splitter
   */
  showSplitter?: boolean;
  
  /**
   * Splitter size in pixels
   */
  splitterSize?: number;
  
  /**
   * Children (Allotment.Pane components)
   */
  children?: React.ReactNode;
  
  /**
   * CSS class name
   */
  className?: string;
  
  /**
   * CSS style object
   */
  style?: React.CSSProperties;
  
  /**
   * Callback when pane sizes change
   */
  onChange?: (sizes: number[]) => void;
}