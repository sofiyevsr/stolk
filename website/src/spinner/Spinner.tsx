import React from "react";

function Spinner() {
  return (
    <div className="flex items-center justify-center h-96">
      <div className="w-20 h-20 border-t-4 border-blue-900 rounded-full animate-spin" />
    </div>
  );
}

export default Spinner;
