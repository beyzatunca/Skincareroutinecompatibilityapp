import { createBrowserRouter } from 'react-router';
import { RootLayout } from './components/RootLayout';
import { Layout } from './components/Layout';
import { Onboarding } from './screens/Onboarding';
import { Home } from './screens/Home';
import { Survey } from './screens/Survey';
import { PersonalizedSurvey } from './screens/PersonalizedSurvey';
import { Search } from './screens/Search';
import { Scan } from './screens/Scan';
import { ProductDetail } from './screens/ProductDetail';
import { AnalysisLoading } from './screens/AnalysisLoading';
import { CompatibilityResults } from './screens/CompatibilityResults';
import { Routine } from './screens/Routine';
import { Profile } from './screens/Profile';
import { PremiumUpgrade } from './screens/PremiumUpgrade';
import { Paywall } from './screens/Paywall';
import { SkincareCoach } from './screens/SkincareCoach';
import { Navigate } from 'react-router';

export const router = createBrowserRouter([
  {
    element: <RootLayout />,
    children: [
      {
        path: '/onboarding',
        element: <Onboarding />
      },
      {
        path: '/',
        element: <Layout />,
        children: [
          { index: true, element: <Home /> },
          { path: 'products', element: <Search /> },
          { path: 'scanner', element: <Scan /> },
          { path: 'routine', element: <Routine /> },
          { path: 'profile', element: <Profile /> }
        ]
      },
      {
        path: '/survey',
        element: <Survey />
      },
      {
        path: '/personalized-survey',
        element: <PersonalizedSurvey />
      },
      {
        path: '/product/:id',
        element: <ProductDetail />
      },
      {
        path: '/analysis-loading',
        element: <AnalysisLoading />
      },
      {
        path: '/compatibility-results',
        element: <CompatibilityResults />
      },
      {
        path: '/premium-upgrade',
        element: <PremiumUpgrade />
      },
      {
        path: '/paywall',
        element: <Paywall />
      },
      {
        path: '/search',
        element: <Navigate to="/products" replace />
      },
      {
        path: '/scan',
        element: <Navigate to="/scanner" replace />
      },
      {
        path: '/skincare-coach',
        element: <SkincareCoach />
      }
    ]
  }
]);