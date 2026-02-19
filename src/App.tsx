import { useEffect } from 'react';
import { RouterProvider } from 'react-router';
import { AppProvider, useApp } from './context/AppContext';
import { router } from './routes';
import { Toaster } from 'sonner@2.0.3';

function AppContent() {
  const { hasSeenOnboarding } = useApp();

  useEffect(() => {
    if (!hasSeenOnboarding && window.location.pathname === '/') {
      window.location.href = '/onboarding';
    }
  }, [hasSeenOnboarding]);

  return null;
}

function App() {
  return (
    <AppProvider>
      <AppContent />
      <RouterProvider router={router} />
      <Toaster position="top-center" richColors />
    </AppProvider>
  );
}

export default App;