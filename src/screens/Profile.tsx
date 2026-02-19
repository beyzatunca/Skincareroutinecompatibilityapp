import { useNavigate } from 'react-router';
import { ChevronRight, User, Shield, Settings, AlertTriangle } from 'lucide-react';
import { useApp } from '../context/AppContext';
import { useState } from 'react';

export function Profile() {
  const navigate = useNavigate();
  const { userProfile, setUserProfile } = useApp();
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [showClearDataModal, setShowClearDataModal] = useState(false);

  const handleDeleteProfile = () => {
    setShowDeleteModal(true);
  };

  const confirmDeleteProfile = () => {
    setUserProfile({
      setupCompleted: false,
      ageRange: '',
      skinType: '',
      skinConcerns: [],
      hasSensitivity: false,
      avoidIngredients: [],
      isPregnant: false
    });
    setShowDeleteModal(false);
  };

  const handleClearData = () => {
    setShowClearDataModal(true);
  };

  const confirmClearData = () => {
    setUserProfile({});
    localStorage.removeItem('routine');
    localStorage.removeItem('savedPlans');
    localStorage.removeItem('hasSeenOnboarding');
    setShowClearDataModal(false);
    // Profile ekranına geri dön
    navigate('/profile');
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white px-6 pt-16 pb-6">
        <h1 className="text-3xl font-semibold text-gray-900 mb-2">
          Profile
        </h1>
        <p className="text-base text-gray-600">
          Manage your preferences and settings
        </p>
      </div>

      {/* Profile Info */}
      {userProfile.setupCompleted && (
        <div className="px-6 py-4">
          <div className="bg-white rounded-2xl p-6">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center">
                <User className="w-8 h-8 text-blue-600" />
              </div>
              <div>
                <h2 className="text-lg font-semibold text-gray-900">
                  Your Profile
                </h2>
                <p className="text-sm text-gray-600">
                  Profile complete
                </p>
              </div>
            </div>

            <div className="space-y-3 pt-4 border-t border-gray-100">
              {userProfile.skinType && (
                <div className="flex justify-between">
                  <span className="text-sm text-gray-600">Skin Type</span>
                  <span className="text-sm font-medium text-gray-900">{userProfile.skinType}</span>
                </div>
              )}
              {userProfile.ageRange && (
                <div className="flex justify-between">
                  <span className="text-sm text-gray-600">Age Range</span>
                  <span className="text-sm font-medium text-gray-900">{userProfile.ageRange}</span>
                </div>
              )}
              {userProfile.skinConcerns && userProfile.skinConcerns.length > 0 && (
                <div className="flex justify-between">
                  <span className="text-sm text-gray-600">Main Concerns</span>
                  <span className="text-sm font-medium text-gray-900">{userProfile.skinConcerns.length} selected</span>
                </div>
              )}
              {userProfile.hasSensitivity !== undefined && (
                <div className="flex justify-between">
                  <span className="text-sm text-gray-600">Sensitive Skin</span>
                  <span className="text-sm font-medium text-gray-900">{userProfile.hasSensitivity ? 'Yes' : 'No'}</span>
                </div>
              )}
            </div>
          </div>
        </div>
      )}

      {/* Settings Menu */}
      <div className="px-6 py-4">
        <h3 className="text-sm font-semibold text-gray-500 uppercase tracking-wider mb-3 px-2">
          Settings
        </h3>
        <div className="bg-white rounded-2xl overflow-hidden">
          <button
            onClick={() => navigate('/survey')}
            className="w-full flex items-center justify-between p-4 active:bg-gray-50 transition-colors border-b border-gray-100"
          >
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                <User className="w-5 h-5 text-blue-600" />
              </div>
              <span className="font-medium text-gray-900">
                {userProfile.setupCompleted ? 'Edit Profile' : 'Complete Profile Setup'}
              </span>
            </div>
            <ChevronRight className="w-5 h-5 text-gray-400" />
          </button>

          <button
            onClick={() => {}}
            className="w-full flex items-center justify-between p-4 active:bg-gray-50 transition-colors border-b border-gray-100"
          >
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-purple-100 rounded-full flex items-center justify-center">
                <Settings className="w-5 h-5 text-purple-600" />
              </div>
              <span className="font-medium text-gray-900">
                Preferences
              </span>
            </div>
            <ChevronRight className="w-5 h-5 text-gray-400" />
          </button>

          <button
            onClick={handleDeleteProfile}
            className="w-full flex items-center justify-between p-4 active:bg-gray-50 transition-colors"
          >
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-red-100 rounded-full flex items-center justify-center">
                <svg className="w-5 h-5 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
              </div>
              <span className="font-medium text-red-600">
                Delete Profile
              </span>
            </div>
          </button>
        </div>
      </div>

      {/* Privacy & Data */}
      <div className="px-6 py-4">
        <h3 className="text-sm font-semibold text-gray-500 uppercase tracking-wider mb-3 px-2">
          Privacy & Data
        </h3>
        <div className="bg-white rounded-2xl overflow-hidden">
          <button
            onClick={() => {}}
            className="w-full flex items-center justify-between p-4 active:bg-gray-50 transition-colors border-b border-gray-100"
          >
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center">
                <Shield className="w-5 h-5 text-green-600" />
              </div>
              <span className="font-medium text-gray-900">
                Privacy Policy
              </span>
            </div>
            <ChevronRight className="w-5 h-5 text-gray-400" />
          </button>

          <button
            onClick={handleClearData}
            className="w-full flex items-center justify-between p-4 active:bg-gray-50 transition-colors"
          >
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-red-100 rounded-full flex items-center justify-center">
                <svg className="w-5 h-5 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
              </div>
              <span className="font-medium text-red-600">
                Clear All Data
              </span>
            </div>
          </button>
        </div>
      </div>

      {/* Privacy Note */}
      <div className="px-6 py-4">
        <div className="bg-blue-50 rounded-2xl p-4 border border-blue-100">
          <h4 className="text-sm font-semibold text-blue-900 mb-2">
            Your Data is Private
          </h4>
          <p className="text-xs text-blue-800 leading-relaxed">
            All your skincare data is stored locally on your device. We don't collect, share, or sell any of your personal information.
          </p>
        </div>
      </div>

      {/* App Info */}
      <div className="px-6 py-4 pb-8">
        <p className="text-xs text-gray-500 text-center">
          Skincare Checker v1.0.0
        </p>
      </div>

      {/* Delete Profile Modal */}
      {showDeleteModal && (
        <div 
          className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 px-6 backdrop-blur-sm"
          onClick={() => setShowDeleteModal(false)}
        >
          <div 
            className="bg-white/95 backdrop-blur-xl p-6 rounded-3xl shadow-2xl max-w-sm w-full"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Icon */}
            <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <AlertTriangle className="w-8 h-8 text-red-600" />
            </div>

            {/* Title */}
            <h3 className="text-xl font-semibold text-gray-900 text-center mb-3">
              Delete Profile?
            </h3>

            {/* Message */}
            <p className="text-sm text-gray-600 text-center mb-6 leading-relaxed">
              Your routines will be kept, but all profile data will be removed. You can always set up your profile again.
            </p>

            {/* Buttons */}
            <div className="space-y-3">
              <button
                onClick={confirmDeleteProfile}
                style={{
                  background: 'linear-gradient(to bottom right, #D4C5E8, #F5E8DD, #FFFEF9)'
                }}
                className="w-full text-gray-900 rounded-2xl py-4 font-semibold text-base active:scale-[0.98] transition-all shadow-lg"
              >
                Delete Profile
              </button>
              <button
                onClick={() => setShowDeleteModal(false)}
                className="w-full bg-gray-100 text-gray-700 rounded-2xl py-4 font-medium text-base active:scale-[0.98] transition-all"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Clear Data Modal */}
      {showClearDataModal && (
        <div 
          className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 px-6 backdrop-blur-sm"
          onClick={() => setShowClearDataModal(false)}
        >
          <div 
            className="bg-white/95 backdrop-blur-xl p-6 rounded-3xl shadow-2xl max-w-sm w-full"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Icon */}
            <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <AlertTriangle className="w-8 h-8 text-red-600" />
            </div>

            {/* Title */}
            <h3 className="text-xl font-semibold text-gray-900 text-center mb-3">
              Clear All Data?
            </h3>

            {/* Message */}
            <p className="text-sm text-gray-600 text-center mb-6 leading-relaxed">
              This will permanently delete all your data including profile, routines, and saved plans. This action cannot be undone.
            </p>

            {/* Buttons */}
            <div className="space-y-3">
              <button
                onClick={confirmClearData}
                style={{
                  background: 'linear-gradient(to bottom right, #C8E6E0, #D8F0EC, #F0F9F7)'
                }}
                className="w-full text-gray-900 rounded-2xl py-4 font-semibold text-base active:scale-[0.98] transition-all shadow-lg"
              >
                Clear All Data
              </button>
              <button
                onClick={() => setShowClearDataModal(false)}
                className="w-full bg-gray-100 text-gray-700 rounded-2xl py-4 font-medium text-base active:scale-[0.98] transition-all"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}