import { Sun, Moon, Plus, Sparkles, ChevronRight, Check, Puzzle, MoreHorizontal, Eye, Calendar } from 'lucide-react';
import { RoutineItem } from '../context/AppContext';
import { useNavigate } from 'react-router';
import { useState, useEffect } from 'react';
import harmonyIcon from 'figma:asset/14751b5ba8650b805101cbce83783342da4f9917.png';
import { useApp } from '../context/AppContext';
import { toast } from 'sonner@2.0.3';

interface SkincareRoutineCardProps {
  amProducts: RoutineItem[];
  pmProducts: RoutineItem[];
}

export function SkincareRoutineCard({ amProducts, pmProducts }: SkincareRoutineCardProps) {
  const navigate = useNavigate();
  const { userProfile, hasCheckedCompatibility, setHasCheckedCompatibility, routine } = useApp();
  const totalProducts = amProducts.length + pmProducts.length;
  const hasProducts = totalProducts > 0;
  
  // State for warning modal
  const [showWarningModal, setShowWarningModal] = useState(false);
  
  // Enhanced compatibility calculation
  const targetScore = totalProducts === 0 ? 0 : Math.min(100, 50 + totalProducts * 8);
  
  // Animated score counter
  const [displayScore, setDisplayScore] = useState(0);
  
  useEffect(() => {
    let startTime: number;
    let animationFrame: number;
    
    const animate = (currentTime: number) => {
      if (!startTime) startTime = currentTime;
      const progress = Math.min((currentTime - startTime) / 1500, 1); // 1.5s animation
      
      // Easing function for smooth animation
      const easeOutQuart = 1 - Math.pow(1 - progress, 4);
      setDisplayScore(Math.round(targetScore * easeOutQuart));
      
      if (progress < 1) {
        animationFrame = requestAnimationFrame(animate);
      }
    };
    
    animationFrame = requestAnimationFrame(animate);
    
    return () => cancelAnimationFrame(animationFrame);
  }, [targetScore]);

  const handleCheckCompatibility = () => {
    if (!hasProducts) {
      toast.error('Please add products first');
      return;
    }
    
    if (routine.length === 1) {
      setShowWarningModal(true);
      return;
    }
    
    navigate('/analysis-loading');
    setHasCheckedCompatibility(true);
  };
  
  return (
    <div className="w-full">
      {/* Gradient Header Section - Lifesum/Calm Vibe */}
      <div 
        className="relative flex flex-col items-center justify-center px-6 pt-12 pb-8 overflow-hidden"
        style={{
          minHeight: '50vh',
        }}
      >
        {/* Animated Color Blobs Background */}
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

        {/* Blob Animation Keyframes */}
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
          
          @keyframes gentleFloat {
            0%, 100% {
              transform: translateY(0px);
            }
            50% {
              transform: translateY(-8px);
            }
          }
          
          @keyframes subtleScale {
            0%, 100% {
              transform: scale(1);
            }
            50% {
              transform: scale(1.02);
            }
          }
          
          @keyframes fadeIn {
            from {
              opacity: 0;
              transform: scale(0.95);
            }
            to {
              opacity: 1;
              transform: scale(1);
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
        
        {/* Top Label */}
        <div className="relative z-10 text-center mb-2">
          <h1 className="text-gray-900 text-2xl font-bold">Your Routine</h1>
          <p className="text-gray-700 text-sm mt-1">Build your personalized skincare journey</p>
        </div>
        
        {/* Large Score Display - Visual Representation - Only show if checked */}
        {hasCheckedCompatibility && (
          <div 
            className="relative mb-6 z-10" 
            style={{ 
              animation: hasProducts ? 'gentleFloat 8s ease-in-out infinite' : 'none' 
            }}
          >
            {/* Soft Glow Background */}
            <div 
              className="absolute inset-0 flex items-center justify-center"
              style={{
                animation: hasProducts ? 'subtleScale 6s ease-in-out infinite' : 'none',
              }}
            >
              <div 
                className="w-72 h-40 rounded-full"
                style={{
                  background: displayScore >= 80 
                    ? 'radial-gradient(ellipse at center, rgba(82, 166, 117, 0.08) 0%, transparent 70%)'
                    : displayScore >= 60
                    ? 'radial-gradient(ellipse at center, rgba(168, 85, 216, 0.08) 0%, transparent 70%)'
                    : displayScore >= 40
                    ? 'radial-gradient(ellipse at center, rgba(244, 165, 186, 0.08) 0%, transparent 70%)'
                    : 'transparent',
                  filter: 'blur(30px)',
                }}
              />
            </div>
            
            {/* Main Score Container - Semicircle */}
            <div className="relative w-64 h-40 flex items-center justify-center">
              {/* Clean Background - Transparent */}
              <div 
                className="absolute inset-0 rounded-t-full overflow-hidden"
                style={{
                  background: 'transparent',
                  animation: 'fadeIn 0.6s ease-out',
                }}
              />
              
              {/* Progress Ring SVG - Semicircle */}
              <svg 
                className="absolute top-0 left-0 w-full h-full" 
                viewBox="0 0 200 120"
                style={{ overflow: 'visible' }}
              >
                {/* Background Track - Semicircle */}
                <path
                  d="M 20 100 A 80 80 0 0 1 180 100"
                  fill="none"
                  stroke="rgba(0,0,0,0.04)"
                  strokeWidth="10"
                  strokeLinecap="round"
                />
                
                {/* Progress Arc - Semicircle */}
                <path
                  d="M 20 100 A 80 80 0 0 1 180 100"
                  fill="none"
                  stroke="url(#cleanGradient)"
                  strokeWidth="10"
                  strokeLinecap="round"
                  strokeDasharray={Math.PI * 80}
                  strokeDashoffset={Math.PI * 80 * (1 - displayScore / 100)}
                  style={{
                    transition: 'stroke-dashoffset 2s cubic-bezier(0.4, 0, 0.2, 1)',
                  }}
                />
                
                {/* Start and End Markers */}
                <circle cx="20" cy="100" r="3" fill="rgba(0,0,0,0.15)" />
                <circle cx="180" cy="100" r="3" fill="rgba(0,0,0,0.15)" />
                
                {/* Gradient Definition */}
                <defs>
                  <linearGradient id="cleanGradient" x1="0%" y1="0%" x2="100%" y2="0%">
                    <stop offset="0%" stopColor="#52A675" stopOpacity="0.9" />
                    <stop offset="50%" stopColor="#A855D8" stopOpacity="0.85" />
                    <stop offset="100%" stopColor="#F4A5BA" stopOpacity="0.9" />
                  </linearGradient>
                </defs>
              </svg>
              
              {/* Center Content */}
              <div className="absolute inset-0 flex flex-col items-center justify-end pb-6">
                {/* Score Number */}
                <div 
                  className="text-6xl font-bold tracking-tight"
                  style={{
                    color: '#1F2937',
                    textShadow: '0 1px 2px rgba(0,0,0,0.05)',
                  }}
                >
                  {displayScore}
                </div>
                
                {/* Status Text */}
                {displayScore >= 40 && (
                  <div 
                    className="text-sm font-medium mt-2 px-3 py-1 rounded-full"
                    style={{
                      color: displayScore >= 80 
                        ? '#52A675'
                        : displayScore >= 60
                        ? '#A855D8'
                        : '#F4A5BA',
                      backgroundColor: displayScore >= 80 
                        ? 'rgba(82, 166, 117, 0.08)'
                        : displayScore >= 60
                        ? 'rgba(168, 85, 216, 0.08)'
                        : 'rgba(244, 165, 186, 0.08)',
                    }}
                  >
                    {displayScore >= 80 ? 'Excellent' : displayScore >= 60 ? 'Good' : 'Fair'}
                  </div>
                )}
              </div>
              
              {/* Scale Labels - Optional */}
              <div className="absolute bottom-0 left-0 right-0 flex justify-between px-4 pb-2">
                <span className="text-xs text-gray-400 font-medium">0</span>
                <span className="text-xs text-gray-400 font-medium">100</span>
              </div>
            </div>
          </div>
        )}
        
        {/* Action Buttons - Bottom Grid */}
        <div className="w-full max-w-md grid grid-cols-2 gap-6 relative z-10 mt-8">
          {/* Add Products */}
          <button
            onClick={() => {
              if (userProfile.setupCompleted) {
                navigate('/products?personalized=true');
              } else {
                navigate('/personalized-survey?fromHome=true');
              }
            }}
            className="flex flex-col items-center gap-2 transition-all active:scale-95"
          >
            <div 
              className="w-16 h-16 rounded-full flex items-center justify-center"
              style={{
                background: 'rgba(255, 255, 255, 0.15)',
                backdropFilter: 'blur(10px)',
                boxShadow: '0 6px 20px rgba(0, 0, 0, 0.25), 0 3px 8px rgba(0, 0, 0, 0.18), inset 0 0 0 1px rgba(0, 0, 0, 0.06)'
              }}
            >
              <Plus className="w-6 h-6 text-gray-900" strokeWidth={2.5} />
            </div>
            <span className="text-gray-900 text-sm font-medium">Add Products</span>
          </button>
          
          {/* Check Compatibility */}
          <button
            onClick={handleCheckCompatibility}
            className="flex flex-col items-center gap-2 transition-all active:scale-95"
          >
            <div 
              className="w-16 h-16 rounded-full flex items-center justify-center"
              style={{
                background: 'rgba(255, 255, 255, 0.15)',
                backdropFilter: 'blur(10px)',
                boxShadow: '0 6px 20px rgba(0, 0, 0, 0.25), 0 3px 8px rgba(0, 0, 0, 0.18), inset 0 0 0 1px rgba(0, 0, 0, 0.06)'
              }}
            >
              <Puzzle className="w-6 h-6 text-gray-900" strokeWidth={2.5} />
            </div>
            <span className="text-gray-900 text-sm font-medium">Check Compatibility</span>
          </button>
        </div>
      </div>

      {/* Warning Modal - Not Enough Products */}
      {showWarningModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center px-6">
          {/* Backdrop */}
          <div 
            className="absolute inset-0 bg-black/50"
            onClick={() => setShowWarningModal(false)}
          />
          
          {/* Modal */}
          <div className="relative bg-white rounded-3xl p-6 shadow-2xl max-w-sm w-full mx-auto">
            <div className="flex flex-col items-center text-center">
              {/* Icon */}
              <div className="w-16 h-16 bg-amber-100 rounded-full flex items-center justify-center mb-4">
                <Puzzle className="w-8 h-8 text-amber-600" />
              </div>
              
              <h3 className="text-lg font-semibold text-gray-900 mb-2">
                Add More Products
              </h3>
              <p className="text-sm text-gray-600 mb-6">
                You need at least 2 products to check compatibility. Add more products to your routine first.
              </p>
              
              <div className="flex gap-3 w-full">
                <button
                  onClick={() => setShowWarningModal(false)}
                  className="flex-1 bg-gray-100 text-gray-900 py-3 rounded-full font-semibold active:opacity-80 transition-opacity"
                >
                  Cancel
                </button>
                <button
                  onClick={() => {
                    setShowWarningModal(false);
                    navigate('/products');
                  }}
                  className="flex-1 bg-gradient-to-r from-[#C8E6E0] via-[#D8F0EC] to-[#F0F9F7] text-gray-900 py-3 rounded-full font-semibold active:opacity-80 transition-opacity"
                >
                  Add Products
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
      
      {/* Morning and Evening Panels */}
      <div className="px-6 py-6 bg-gradient-to-b from-cyan-50/30 to-white">
        <div className="grid grid-cols-2 gap-4">
          <RoutineCard
            icon={<Sun className="w-5 h-5" />}
            title="Morning"
            subtitle="AM Routine"
            products={amProducts}
            gradientFrom="#FEF3C7"
            gradientTo="#FCD34D"
            iconColor="text-amber-600"
            borderColor="rgba(251, 191, 36, 0.3)"
          />
          
          <RoutineCard
            icon={<Moon className="w-5 h-5" />}
            title="Evening"
            subtitle="PM Routine"
            products={pmProducts}
            gradientFrom="#DBEAFE"
            gradientTo="#93C5FD"
            iconColor="text-blue-600"
            borderColor="rgba(59, 130, 246, 0.3)"
          />
        </div>
      </div>
    </div>
  );
}

interface RoutineCardProps {
  icon: React.ReactNode;
  title: string;
  subtitle: string;
  products: RoutineItem[];
  gradientFrom: string;
  gradientTo: string;
  iconColor: string;
  borderColor: string;
}

function RoutineCard({ 
  icon, 
  title, 
  subtitle, 
  products, 
  gradientFrom, 
  gradientTo,
  iconColor,
  borderColor
}: RoutineCardProps) {
  const navigate = useNavigate();
  const maxDisplay = 3;
  
  return (
    <button
      onClick={() => navigate('/routine')}
      className="group relative overflow-hidden rounded-2xl border border-gray-100 transition-all duration-300 hover:shadow-xl active:scale-[0.98] text-left"
      style={{
        background: 'linear-gradient(135deg, rgba(255, 255, 255, 0.95) 0%, rgba(249, 250, 251, 0.98) 100%)',
        boxShadow: '0 1px 3px rgba(0, 0, 0, 0.05)',
      }}
    >
      {/* Subtle Color Accent - Top Right Glow */}
      <div 
        className="absolute top-0 right-0 w-32 h-32 opacity-30"
        style={{
          background: `radial-gradient(circle at top right, ${gradientTo} 0%, transparent 70%)`,
        }}
      />

      {/* Glassmorphic overlay on hover */}
      <div className="absolute inset-0 bg-white/60 backdrop-blur-sm opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
      
      <div className="relative z-10 p-5">
        {/* Header */}
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-2">
            <div className={`${iconColor}`}>
              {icon}
            </div>
            <div>
              <h3 className="text-lg font-bold text-gray-900">{title}</h3>
              <p className="text-xs text-gray-600">{subtitle}</p>
            </div>
          </div>
          <ChevronRight className="w-5 h-5 text-gray-400 group-hover:text-gray-600 group-hover:translate-x-1 transition-all duration-300" />
        </div>

        {/* Products Display */}
        {products.length === 0 ? (
          <div 
            className="flex items-center gap-2"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex -space-x-2 pointer-events-none">
              {[...Array(3)].map((_, i) => (
                <div
                  key={i}
                  className="w-10 h-10 rounded-full bg-white border-2 border-white flex items-center justify-center"
                  style={{
                    boxShadow: '0 6px 20px rgba(0, 0, 0, 0.25), 0 3px 8px rgba(0, 0, 0, 0.18), inset 0 0 0 1px rgba(0, 0, 0, 0.06)'
                  }}
                >
                  <Plus className="w-4 h-4 text-gray-400" />
                </div>
              ))}
            </div>
          </div>
        ) : (
          <div className="flex items-center justify-between">
            <div className="flex -space-x-2">
              {products.slice(0, maxDisplay).map((item, idx) => (
                <div
                  key={idx}
                  className="w-10 h-10 rounded-full bg-white border-2 border-white overflow-hidden"
                  style={{
                    boxShadow: '0 6px 20px rgba(0, 0, 0, 0.25), 0 3px 8px rgba(0, 0, 0, 0.18), inset 0 0 0 1px rgba(0, 0, 0, 0.06)'
                  }}
                >
                  <img
                    src={item.product.image || 'https://images.unsplash.com/photo-1643379850623-7eb6442cd262?w=400&q=80'}
                    alt={item.product.productName}
                    className="w-full h-full object-cover"
                  />
                </div>
              ))}
              {products.length > maxDisplay && (
                <div
                  className="w-10 h-10 rounded-full bg-white border-2 border-white flex items-center justify-center"
                  style={{
                    boxShadow: '0 6px 20px rgba(0, 0, 0, 0.25), 0 3px 8px rgba(0, 0, 0, 0.18), inset 0 0 0 1px rgba(0, 0, 0, 0.06)'
                  }}
                >
                  <span className="text-xs font-bold text-gray-900">
                    +{products.length - maxDisplay}
                  </span>
                </div>
              )}
            </div>
          </div>
        )}
      </div>
    </button>
  );
}