import { NavLink } from 'react-router';
import { Home, Package, User } from 'lucide-react';
import { useApp } from '../context/AppContext';

export function BottomTabBar() {
  const { userProfile } = useApp();
  
  // Determine products URL based on user profile
  const productsUrl = userProfile.setupCompleted ? '/products?personalized=true' : '/products';
  
  return (
    <nav className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-100 safe-area-inset-bottom z-50">
      <div className="max-w-md mx-auto flex justify-around items-center h-20 px-2">
        <NavLink
          to="/"
          className={({ isActive }) =>
            `flex flex-col items-center justify-center gap-1 px-2 py-2 flex-1 transition-colors ${
              isActive ? 'text-teal-600' : 'text-gray-400'
            }`
          }
        >
          {({ isActive }) => (
            <>
              <Home className={`w-6 h-6 ${isActive ? 'fill-current' : ''}`} />
              <span className="text-[10px] font-medium">Home</span>
            </>
          )}
        </NavLink>

        <NavLink
          to={productsUrl}
          className={({ isActive }) =>
            `flex flex-col items-center justify-center gap-1 px-2 py-2 flex-1 transition-colors ${
              isActive ? 'text-teal-600' : 'text-gray-400'
            }`
          }
        >
          {({ isActive }) => (
            <>
              <Package className={`w-6 h-6 ${isActive ? 'fill-current' : ''}`} />
              <span className="text-[10px] font-medium">Discover</span>
            </>
          )}
        </NavLink>

        <NavLink
          to="/profile"
          className={({ isActive }) =>
            `flex flex-col items-center justify-center gap-1 px-2 py-2 flex-1 transition-colors ${
              isActive ? 'text-teal-600' : 'text-gray-400'
            }`
          }
        >
          {({ isActive }) => (
            <>
              <User className={`w-6 h-6 ${isActive ? 'fill-current' : ''}`} />
              <span className="text-[10px] font-medium">Profile</span>
            </>
          )}
        </NavLink>
      </div>
    </nav>
  );
}