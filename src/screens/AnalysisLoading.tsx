import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router';
import { Loader2 } from 'lucide-react';
import { useApp } from '../context/AppContext';
import { analyzeRoutineCompatibility } from '../utils/compatibility';

const loadingSteps = [
  'Checking ingredient conflicts...',
  'Detecting overlapping actives...',
  'Building your safest schedule...'
];

export function AnalysisLoading() {
  const navigate = useNavigate();
  const { routine, userProfile, setCompatibilityResult } = useApp();
  const [currentStep, setCurrentStep] = useState(0);

  useEffect(() => {
    // Simulate loading steps
    const stepInterval = setInterval(() => {
      setCurrentStep(prev => {
        if (prev < loadingSteps.length - 1) {
          return prev + 1;
        }
        return prev;
      });
    }, 1500);

    // Perform actual analysis
    const analysisTimeout = setTimeout(() => {
      const result = analyzeRoutineCompatibility(routine, userProfile);
      setCompatibilityResult(result);
      navigate('/compatibility-results');
    }, 4500);

    return () => {
      clearInterval(stepInterval);
      clearTimeout(analysisTimeout);
    };
  }, [routine, userProfile, setCompatibilityResult, navigate]);

  return (
    <div className="min-h-screen flex flex-col items-center justify-center px-6 relative overflow-hidden">
      {/* Animated Mesh Gradient Background - Same as Home */}
      <div className="absolute inset-0">
        {/* Green blob - top left */}
        <div 
          className="absolute w-full h-full"
          style={{
            background: 'radial-gradient(circle at 30% 20%, #52A675 0%, transparent 50%)',
            animation: 'blobFloat1 8s ease-in-out infinite',
          }}
        />
        
        {/* Purple blob - top right */}
        <div 
          className="absolute w-full h-full"
          style={{
            background: 'radial-gradient(circle at 70% 20%, #A855D8 0%, transparent 50%)',
            animation: 'blobFloat2 10s ease-in-out infinite',
          }}
        />
        
        {/* Pink blob - middle */}
        <div 
          className="absolute w-full h-full"
          style={{
            background: 'radial-gradient(circle at 50% 60%, #F4A5BA 0%, transparent 40%)',
            animation: 'blobFloat3 12s ease-in-out infinite',
          }}
        />
        
        {/* Peach blob - bottom */}
        <div 
          className="absolute w-full h-full"
          style={{
            background: 'radial-gradient(circle at 50% 100%, #E8A87C 0%, transparent 60%)',
            animation: 'blobFloat4 9s ease-in-out infinite',
          }}
        />
      </div>

      {/* Breathing Animation Keyframes */}
      <style>{`
        @keyframes blobFloat1 {
          0%, 100% {
            opacity: 0.5;
          }
          50% {
            opacity: 0.8;
          }
        }
        
        @keyframes blobFloat2 {
          0%, 100% {
            opacity: 0.6;
          }
          50% {
            opacity: 0.9;
          }
        }
        
        @keyframes blobFloat3 {
          0%, 100% {
            opacity: 0.7;
          }
          50% {
            opacity: 1;
          }
        }
        
        @keyframes blobFloat4 {
          0%, 100% {
            opacity: 0.5;
          }
          50% {
            opacity: 0.85;
          }
        }
      `}</style>

      {/* White Corner Fade Overlay */}
      <div 
        className="absolute inset-0"
        style={{
          background: 'radial-gradient(ellipse at top left, white 0%, transparent 40%), radial-gradient(ellipse at top right, white 0%, transparent 40%), radial-gradient(ellipse at bottom left, white 0%, transparent 40%), radial-gradient(ellipse at bottom right, white 0%, transparent 40%)',
        }}
      />

      {/* Content - with z-index to stay above background */}
      <div className="relative z-10 flex flex-col items-center">
        <div className="w-24 h-24 mb-8">
          <Loader2 className="w-24 h-24 text-gray-900 animate-spin" strokeWidth={1.5} />
        </div>

        <h2 className="text-2xl font-semibold text-gray-900 mb-4 text-center">
          Analyzing Your Routine
        </h2>

        <div className="space-y-3 w-full max-w-sm">
          {loadingSteps.map((step, index) => (
            <div
              key={index}
              className={`flex items-center gap-3 p-4 rounded-xl transition-all backdrop-blur-xl ${
                index === currentStep
                  ? 'bg-white/80 text-gray-900 shadow-md'
                  : index < currentStep
                  ? 'bg-white/60 text-gray-700'
                  : 'bg-white/30 text-gray-500'
              }`}
            >
              {index < currentStep ? (
                <svg className="w-5 h-5 flex-shrink-0 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                </svg>
              ) : index === currentStep ? (
                <Loader2 className="w-5 h-5 flex-shrink-0 animate-spin text-cyan-600" />
              ) : (
                <div className="w-5 h-5 rounded-full border-2 border-current flex-shrink-0" />
              )}
              <span className="text-sm font-medium">{step}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}