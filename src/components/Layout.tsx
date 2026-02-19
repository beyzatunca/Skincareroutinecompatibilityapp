import { Outlet } from 'react-router';
import { BottomTabBar } from './BottomTabBar';

export function Layout() {
  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      <Outlet />
      <BottomTabBar />
    </div>
  );
}