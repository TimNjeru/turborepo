"use client";

import React, { useRef } from "react";
import { Allotment } from "allotment";
import "allotment/dist/style.css";

const AllotmentDemo = () => {
  const ref = useRef<any>(null);

  const handleReset = () => {
    ref.current?.reset();
  };

  const handleResize = () => {
    ref.current?.resize([100, 200, 300]);
  };

  return (
    <div style={{ height: "500px", border: "1px solid #ccc", margin: "20px 0" }}>
      <div style={{ padding: "10px", borderBottom: "1px solid #ccc", background: "#f5f5f5" }}>
        <h3>Allotment Split-Pane Demo</h3>
        <button onClick={handleReset} style={{ marginRight: "10px" }}>
          Reset Panes
        </button>
        <button onClick={handleResize}>
          Resize to [100, 200, 300]
        </button>
      </div>
      
      <Allotment ref={ref} defaultSizes={[200, 300, 200]}>
        <Allotment.Pane minSize={150} maxSize={400}>
          <div style={{ 
            padding: "20px", 
            background: "#e3f2fd", 
            height: "100%",
            overflow: "auto"
          }}>
            <h4>Left Pane</h4>
            <p>This is the left pane with a minimum size of 150px and maximum of 400px.</p>
            <p>You can resize this pane by dragging the separator.</p>
            <div style={{ height: "200px", background: "#bbdefb", margin: "10px 0", padding: "10px" }}>
              <p>Scrollable content area</p>
              <p>Line 1</p>
              <p>Line 2</p>
              <p>Line 3</p>
              <p>Line 4</p>
              <p>Line 5</p>
            </div>
          </div>
        </Allotment.Pane>
        
        <Allotment.Pane snap>
          <div style={{ 
            padding: "20px", 
            background: "#f3e5f5", 
            height: "100%",
            overflow: "auto"
          }}>
            <h4>Middle Pane (Snappable)</h4>
            <p>This pane can be snapped to zero by double-clicking the separator.</p>
            <p>It has snap behavior enabled.</p>
            <div style={{ height: "150px", background: "#e1bee7", margin: "10px 0", padding: "10px" }}>
              <p>Content area</p>
            </div>
          </div>
        </Allotment.Pane>
        
        <Allotment.Pane preferredSize="30%">
          <div style={{ 
            padding: "20px", 
            background: "#e8f5e8", 
            height: "100%",
            overflow: "auto"
          }}>
            <h4>Right Pane</h4>
            <p>This pane has a preferred size of 30%.</p>
            <p>It will attempt to maintain this size when possible.</p>
            <div style={{ height: "100px", background: "#c8e6c9", margin: "10px 0", padding: "10px" }}>
              <p>Another content area</p>
            </div>
          </div>
        </Allotment.Pane>
      </Allotment>
    </div>
  );
};

export default AllotmentDemo; 