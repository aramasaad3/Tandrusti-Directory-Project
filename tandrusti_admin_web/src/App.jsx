import { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, useNavigate, Navigate } from 'react-router-dom';
import { auth } from './firebase';
import { signInWithEmailAndPassword, onAuthStateChanged, signOut } from 'firebase/auth';

// Simple placeholder components for now
import Dashboard from './components/Dashboard';
import DoctorsPanel from './components/DoctorsPanel';
import MedicinesPanel from './components/MedicinesPanel';
import TestsPanel from './components/TestsPanel';
import AppLayout from './components/AppLayout';

// The one and only Admin email allowed to access this dashboard.
const ADMIN_EMAIL = 'admin@tandrusti.com';

function LoginScreen() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    if (email.toLowerCase().trim() !== ADMIN_EMAIL) {
      setError("Access Denied: You are not authorized to access the Admin Dashboard.");
      setLoading(false);
      return;
    }

    try {
      await signInWithEmailAndPassword(auth, email, password);
      // Success - only the legit admin gets past here
      navigate('/');
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-background flex flex-col items-center justify-center p-4">
      <div className="bg-surface p-8 rounded-xl shadow-lg max-w-md w-full border border-borderLight">
        <h1 className="text-2xl font-bold text-textMain text-center mb-2">Tandrusti Admin</h1>
        <p className="text-textMuted text-center mb-6">Log in to manage your medical data</p>
        
        {error && <div className="bg-red-100 text-red-600 p-3 rounded mb-4 text-sm">{error}</div>}

        <form onSubmit={handleLogin} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-textMain mb-1">Email</label>
            <input 
              type="email" 
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full border border-borderLight rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary outline-none" 
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-textMain mb-1">Password</label>
            <input 
              type="password" 
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full border border-borderLight rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary outline-none" 
            />
          </div>
          <button 
            type="submit" 
            disabled={loading}
            className="w-full bg-primary hover:bg-primaryDark text-white font-bold py-2 px-4 rounded-lg transition-colors mt-4"
          >
            {loading ? 'Authenticating...' : 'Log In'}
          </button>
        </form>
      </div>
    </div>
  );
}

function App() {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsub = onAuthStateChanged(auth, async (u) => {
      if (u && u.email !== ADMIN_EMAIL) {
        // Force sign out if a regular user tries to bypass
        await signOut(auth);
        setUser(null);
      } else {
        setUser(u);
      }
      setLoading(false);
    });
    return unsub;
  }, []);

  if (loading) return <div className="min-h-screen flex items-center justify-center font-bold text-primary">Loading...</div>;

  return (
    <Router>
      <Routes>
        <Route path="/login" element={user ? <Navigate to="/" /> : <LoginScreen />} />
        
        {/* Protected Routes */}
        <Route path="/" element={user ? <AppLayout user={user} /> : <Navigate to="/login" />}>
          <Route index element={<Dashboard />} />
          <Route path="doctors" element={<DoctorsPanel />} />
          <Route path="medicines" element={<MedicinesPanel />} />
          <Route path="tests" element={<TestsPanel />} />
        </Route>
      </Routes>
    </Router>
  );
}

export default App;
