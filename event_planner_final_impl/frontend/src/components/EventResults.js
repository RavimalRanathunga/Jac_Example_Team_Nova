import React from 'react';
import './EventResults.css';

function EventResults({ eventData, onReset }) {
  const { event_details, analysis, checklist, budget } = eventData;

  // Helper function to convert string to HTML with line breaks
  const formatText = (text) => {
    return text.split('\n').map((line, index) => (
      <React.Fragment key={index}>
        {line}
        <br />
      </React.Fragment>
    ));
  };

  return (
    <div className="results-container">
      <div className="results-header">
        <h2>Your Event Plan</h2>
        <button className="reset-button" onClick={onReset}>Plan Another Event</button>
      </div>

      <div className="result-card">
        <h3>Event Details</h3>
        <p>{event_details}</p>
      </div>

      <div className="result-card">
        <h3>Event Analysis</h3>
        <div className="formatted-text">{formatText(analysis)}</div>
      </div>

      <div className="result-card">
        <h3>Planning Checklist</h3>
        <div className="formatted-text">{formatText(checklist)}</div>
      </div>

      <div className="result-card">
        <h3>Budget Recommendation</h3>
        <div className="formatted-text">{formatText(budget)}</div>
      </div>
    </div>
  );
}

export default EventResults;