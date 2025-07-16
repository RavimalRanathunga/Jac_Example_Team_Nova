import React, { useState } from 'react';
import './EventForm.css';

function EventForm({ onSubmit, isLoading }) {
  const [formData, setFormData] = useState({
    event_name: '',
    number_of_guests: '',
    event_type: '',
  });
  
  const [errors, setErrors] = useState({});

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value,
    });
    
    // Clear error when field is being edited
    if (errors[name]) {
      setErrors({
        ...errors,
        [name]: '',
      });
    }
  };

  const validateForm = () => {
    const newErrors = {};
    
    if (!formData.event_name.trim()) {
      newErrors.event_name = 'Event name is required';
    }
    
    if (!formData.number_of_guests) {
      newErrors.number_of_guests = 'Number of guests is required';
    } else if (isNaN(formData.number_of_guests) || formData.number_of_guests <= 0) {
      newErrors.number_of_guests = 'Please enter a valid number';
    }
    
    if (!formData.event_type.trim()) {
      newErrors.event_type = 'Event type is required';
    }
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    
    if (validateForm()) {
      onSubmit({
        ...formData,
        number_of_guests: parseInt(formData.number_of_guests, 10),
      });
    }
  };

  return (
    <div className="event-form-container">
      <form onSubmit={handleSubmit} className="event-form">
        <div className="form-group">
          <label htmlFor="event_name">Event Name:</label>
          <input
            type="text"
            id="event_name"
            name="event_name"
            value={formData.event_name}
            onChange={handleChange}
            placeholder="Summer Wedding"
            disabled={isLoading}
          />
          {errors.event_name && <span className="error-message">{errors.event_name}</span>}
        </div>
        
        <div className="form-group">
          <label htmlFor="number_of_guests">Number of Guests:</label>
          <input
            type="number"
            id="number_of_guests"
            name="number_of_guests"
            value={formData.number_of_guests}
            onChange={handleChange}
            placeholder="100"
            disabled={isLoading}
          />
          {errors.number_of_guests && <span className="error-message">{errors.number_of_guests}</span>}
        </div>
        
        <div className="form-group">
          <label htmlFor="event_type">Event Type:</label>
          <input
            type="text"
            id="event_type"
            name="event_type"
            value={formData.event_type}
            onChange={handleChange}
            placeholder="wedding, birthday, corporate, etc."
            disabled={isLoading}
          />
          {errors.event_type && <span className="error-message">{errors.event_type}</span>}
        </div>
        
        <button type="submit" className="submit-button" disabled={isLoading}>
          {isLoading ? 'Planning...' : 'Plan Event'}
        </button>
      </form>
    </div>
  );
}

export default EventForm;