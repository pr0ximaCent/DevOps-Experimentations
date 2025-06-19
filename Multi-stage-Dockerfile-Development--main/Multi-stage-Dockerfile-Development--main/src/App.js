import React from "react";

function App() {
  const handleSubmit = (event) => {
    event.preventDefault();
    const email = event.target.email.value;
    const password = event.target.password.value;
    console.log("Email:", email, "Password:", password);
  };

  return (
    <div className="app-container">
      <div className="form-container">
        <h2 className="form-title">Welcome Back</h2>
        <p className="form-subtitle">Login to your account</p>
        <form onSubmit={handleSubmit} className="login-form">
          <label className="form-label">Email</label>
          <input
            type="email"
            name="email"
            className="form-input"
            placeholder="Enter your email"
            required
          />
          <label className="form-label">Password</label>
          <input
            type="password"
            name="password"
            className="form-input"
            placeholder="Enter your password"
            required
          />
          <button type="submit" className="form-button">
            Login
          </button>
        </form>
        <p className="form-footer">
          Don't have an account? <a href="#" className="form-link">Sign Up</a>
        </p>
      </div>
    </div>
  );
}

export default App;

