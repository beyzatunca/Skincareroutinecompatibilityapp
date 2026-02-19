import React, { createContext, useContext, useState, useEffect } from 'react';
import { UserProfile, RoutineItem, CompatibilityResult } from '../types';

interface AppContextType {
  hasSeenOnboarding: boolean;
  setHasSeenOnboarding: (value: boolean) => void;
  userProfile: UserProfile;
  setUserProfile: (profile: UserProfile) => void;
  routine: RoutineItem[];
  setRoutine: (routine: RoutineItem[]) => void;
  addToRoutine: (item: RoutineItem) => void;
  removeFromRoutine: (id: string) => void;
  updateRoutineItem: (id: string, updates: Partial<RoutineItem>) => void;
  compatibilityResult: CompatibilityResult | null;
  setCompatibilityResult: (result: CompatibilityResult | null) => void;
  savedPlans: { id: string; name: string; date: string; result: CompatibilityResult; routine: RoutineItem[] }[];
  savePlan: (name: string) => void;
  wishlist: string[];
  addToWishlist: (productId: string) => void;
  removeFromWishlist: (productId: string) => void;
  recentScans: string[];
  addRecentScan: (productId: string) => void;
  hasCheckedCompatibility: boolean;
  setHasCheckedCompatibility: (value: boolean) => void;
}

const AppContext = createContext<AppContextType | undefined>(undefined);

export function AppProvider({ children }: { children: React.ReactNode }) {
  const [hasSeenOnboarding, setHasSeenOnboarding] = useState(() => {
    // Always start with onboarding
    return false;
  });

  const [userProfile, setUserProfile] = useState<UserProfile>(() => {
    const stored = localStorage.getItem('userProfile');
    return stored ? JSON.parse(stored) : { isPremium: false };
  });

  const [routine, setRoutine] = useState<RoutineItem[]>(() => {
    const stored = localStorage.getItem('routine');
    return stored ? JSON.parse(stored) : [];
  });

  const [compatibilityResult, setCompatibilityResult] = useState<CompatibilityResult | null>(null);

  const [savedPlans, setSavedPlans] = useState<AppContextType['savedPlans']>(() => {
    const stored = localStorage.getItem('savedPlans');
    return stored ? JSON.parse(stored) : [];
  });

  const [wishlist, setWishlist] = useState<string[]>(() => {
    const stored = localStorage.getItem('wishlist');
    return stored ? JSON.parse(stored) : [];
  });

  const [recentScans, setRecentScans] = useState<string[]>(() => {
    const stored = localStorage.getItem('recentScans');
    return stored ? JSON.parse(stored) : [];
  });

  const [hasCheckedCompatibility, setHasCheckedCompatibility] = useState(false);

  useEffect(() => {
    localStorage.setItem('hasSeenOnboarding', String(hasSeenOnboarding));
  }, [hasSeenOnboarding]);

  useEffect(() => {
    localStorage.setItem('userProfile', JSON.stringify(userProfile));
  }, [userProfile]);

  useEffect(() => {
    localStorage.setItem('routine', JSON.stringify(routine));
  }, [routine]);

  useEffect(() => {
    localStorage.setItem('savedPlans', JSON.stringify(savedPlans));
  }, [savedPlans]);

  useEffect(() => {
    localStorage.setItem('wishlist', JSON.stringify(wishlist));
  }, [wishlist]);

  useEffect(() => {
    localStorage.setItem('recentScans', JSON.stringify(recentScans));
  }, [recentScans]);

  const addToRoutine = (item: RoutineItem) => {
    setRoutine(prev => [...prev, item]);
    // Reset compatibility check when routine changes
    setHasCheckedCompatibility(false);
  };

  const removeFromRoutine = (id: string) => {
    setRoutine(prev => prev.filter(item => item.id !== id));
    // Reset compatibility check when routine changes
    setHasCheckedCompatibility(false);
  };

  const updateRoutineItem = (id: string, updates: Partial<RoutineItem>) => {
    setRoutine(prev => prev.map(item => 
      item.id === id ? { ...item, ...updates } : item
    ));
    // Reset compatibility check when routine changes
    setHasCheckedCompatibility(false);
  };

  const savePlan = (name: string) => {
    if (compatibilityResult) {
      const newPlan = {
        id: Date.now().toString(),
        name,
        date: new Date().toISOString(),
        result: compatibilityResult,
        routine: [...routine]
      };
      setSavedPlans(prev => [newPlan, ...prev]);
    }
  };

  const addToWishlist = (productId: string) => {
    setWishlist(prev => [...prev, productId]);
  };

  const removeFromWishlist = (productId: string) => {
    setWishlist(prev => prev.filter(id => id !== productId));
  };

  const addRecentScan = (productId: string) => {
    setRecentScans(prev => [...prev, productId]);
  };

  return (
    <AppContext.Provider value={{
      hasSeenOnboarding,
      setHasSeenOnboarding,
      userProfile,
      setUserProfile,
      routine,
      setRoutine,
      addToRoutine,
      removeFromRoutine,
      updateRoutineItem,
      compatibilityResult,
      setCompatibilityResult,
      savedPlans,
      savePlan,
      wishlist,
      addToWishlist,
      removeFromWishlist,
      recentScans,
      addRecentScan,
      hasCheckedCompatibility,
      setHasCheckedCompatibility
    }}>
      {children}
    </AppContext.Provider>
  );
}

export function useApp() {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error('useApp must be used within AppProvider');
  }
  return context;
}