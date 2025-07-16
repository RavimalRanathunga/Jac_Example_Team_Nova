import React, { useState } from 'react';
import './App.css';
import EventForm from './components/EventForm';
import EventResults from './components/EventResults';

function App() {
  const [eventData, setEventData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const handleSubmit = async (formData) => {
    setLoading(true);
    setError(null);
    
    try {
      const response = await fetch('http://localhost:8000/plan-event/', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      });
      
      if (!response.ok) {
        throw new Error('Failed to process event planning request');
      }
      
      const data = await response.json();
      setEventData(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="app">
      <header>
        <h1>Event Planner Assistant</h1>
      </header>
      <main>
        {!eventData && <EventForm onSubmit={handleSubmit} isLoading={loading} />}
        {loading && <div className="loading">Planning your event...</div>}
        {error && <div className="error">{error}</div>}
        {eventData && <EventResults eventData={eventData} onReset={() => setEventData(null)} />}
      </main>
    </div>
  );
}

export default App;