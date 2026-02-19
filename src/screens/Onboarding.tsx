import { useState, useRef, useEffect } from 'react';
import { useNavigate } from 'react-router';
import { Sparkles, Shield, Calendar, CheckCircle2 } from 'lucide-react';
import { useApp } from '../context/AppContext';
import compatibilityImage from 'figma:asset/873d7e23a801cba0eb25bc66e52fdd919218db6d.png';
import scanningImage from 'figma:asset/69fc9becc9e1b46813af5cffef851c912e6d561e.png';
import routineImage1 from 'figma:asset/e9017d8198e203c3f3c075469c99955ae87448ea.png';
import routineImage2 from 'figma:asset/fccb2783d6324031af4741b4d88036de3f4b7462.png';
import routineImage3 from 'figma:asset/540eb2fb49bfeb1aff6f899891ab16a1416c5b3b.png';

const slides = [
  {
    icon: Shield,
    title: 'Not all skincare products\nwork well together',
    description: [
      'Some ingredients can reduce effectiveness',
      'Others may cause skin irritation',
      'We check compatibility before issues occur'
    ],
    image: 'https://images.unsplash.com/photo-1642505172812-15cf294b1212?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXN0ZWwlMjBiZWF1dHklMjBwcm9kdWN0cyUyMGxpZmVzdHlsZXxlbnwxfHx8fDE3NzA1Njg0Mjh8MA&ixlib=rb-4.1.0&q=80&w=1080',
    customImage: compatibilityImage,
    useCustomImage: true
  },
  {
    icon: Calendar,
    title: 'Find products that truly match\nyour skin goals',
    description: [
      'Tailored to your skin type and concerns',
      'Aligned with your expectations',
      'Supporting your skincare goals'
    ],
    image: 'https://images.unsplash.com/photo-1666025062728-c33a25e8ee3f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx2aWJyYW50JTIwc2tpbmNhcmUlMjBzZXJ1bSUyMGJvdHRsZXN8ZW58MXx8fHwxNzcwNTY4NDMxfDA&ixlib=rb-4.1.0&q=80&w=1080',
    customImage: scanningImage,
    useCustomImage: true
  },
  {
    icon: Sparkles,
    title: 'Build a healthy routine\nfor your skin type',
    description: [
      'Fix product compatibility issues',
      'Update your routine safely',
      'Maintain skin-friendly practices'
    ],
    image: 'https://images.unsplash.com/photo-1629198688000-71f23e745b6e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwZXJmZWN0JTIwc2tpbmNhcmUlMjByb3V0aW5lJTIwb3JnYW5pemVkfGVufDF8fHx8MTc3MDU2OTc4Mnww&ixlib=rb-4.1.0&q=80&w=1080',
    useScatteredImages: true
  }
];

export function Onboarding() {
  const [currentSlide, setCurrentSlide] = useState(0);
  const navigate = useNavigate();
  const { setHasSeenOnboarding } = useApp();
  const scrollContainerRef = useRef<HTMLDivElement>(null);

  const handleGetStarted = () => {
    setHasSeenOnboarding(true);
    navigate('/');
  };

  // Handle scroll to update current slide indicator
  useEffect(() => {
    const container = scrollContainerRef.current;
    if (!container) return;

    const handleScroll = () => {
      const scrollLeft = container.scrollLeft;
      const slideWidth = container.offsetWidth;
      const newSlide = Math.round(scrollLeft / slideWidth);
      setCurrentSlide(newSlide);
    };

    container.addEventListener('scroll', handleScroll);
    return () => container.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <div className="h-screen bg-white flex flex-col overflow-hidden">
      {/* Scrollable carousel container */}
      <div 
        ref={scrollContainerRef}
        className="flex-1 flex overflow-x-auto overflow-y-hidden snap-x snap-mandatory scrollbar-hide"
        style={{
          scrollbarWidth: 'none',
          msOverflowStyle: 'none',
          WebkitOverflowScrolling: 'touch'
        }}
      >
        {slides.map((slide, index) => {
          const Icon = slide.icon;
          return (
            <div 
              key={index}
              className="w-full h-full flex-shrink-0 snap-center relative bg-white"
              style={{ minWidth: '100%' }}
            >
              {/* Content */}
              <div className="relative h-full flex flex-col items-center justify-center px-8 pb-40">
                {slide.useCustomImage ? (
                  <img 
                    src={slide.customImage} 
                    alt="Compatibility" 
                    className="w-64 h-64 object-contain mb-8"
                  />
                ) : slide.useScatteredImages ? (
                  /* Scattered routine screenshots */
                  <div className="relative w-full max-w-sm h-64 mb-8">
                    {/* Compatibility Screenshot - Top Left */}
                    <img 
                      src={routineImage3} 
                      alt="Compatibility Check" 
                      className="absolute top-0 left-0 w-40 h-52 object-cover rounded-2xl shadow-xl transform -rotate-6 border-4 border-white"
                      style={{ zIndex: 3 }}
                    />
                    {/* Routine Screenshot - Center Right */}
                    <img 
                      src={routineImage2} 
                      alt="Your Routine" 
                      className="absolute top-4 right-0 w-40 h-52 object-cover rounded-2xl shadow-xl transform rotate-6 border-4 border-white"
                      style={{ zIndex: 2 }}
                    />
                    {/* Product Detail Screenshot - Bottom Center */}
                    <img 
                      src={routineImage1} 
                      alt="Product Detail" 
                      className="absolute bottom-0 left-1/2 -translate-x-1/2 w-40 h-52 object-cover rounded-2xl shadow-xl transform rotate-3 border-4 border-white"
                      style={{ zIndex: 1 }}
                    />
                  </div>
                ) : (
                  <div className="w-20 h-20 rounded-3xl bg-gradient-to-br from-cyan-500 to-teal-500 flex items-center justify-center mb-8 shadow-lg">
                    <Icon className="w-10 h-10 text-white" strokeWidth={2} />
                  </div>
                )}

                <h1 className="text-[28px] font-semibold text-gray-900 text-center mb-4 leading-tight whitespace-pre-line">
                  {slide.title}
                </h1>

                <div className="space-y-2 max-w-sm">
                  {slide.description.map((item, i) => (
                    <div key={i} className="flex items-start gap-2">
                      <CheckCircle2 className="w-5 h-5 text-cyan-500 flex-shrink-0 mt-0.5" />
                      <span className="text-sm text-gray-600 leading-relaxed">
                        {item}
                      </span>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {/* Fixed bottom section with indicators and button */}
      <div className="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-white via-white to-transparent pt-8 pb-12 px-6">
        {/* Page indicators */}
        <div className="flex justify-center gap-2 mb-6">
          {slides.map((_, index) => (
            <div
              key={index}
              className={`h-2 rounded-full transition-all duration-300 ${
                index === currentSlide 
                  ? 'w-8 bg-gradient-to-r from-[#C8E6E0] via-[#D8F0EC] to-[#F0F9F7]' 
                  : 'w-2 bg-gray-300'
              }`}
            />
          ))}
        </div>

        {/* Get Started button - always visible */}
        <button
          onClick={handleGetStarted}
          className="w-full bg-gradient-to-br from-[#C8E6E0] via-[#D8F0EC] to-[#F0F9F7] text-gray-900 rounded-full py-4 font-semibold text-lg shadow-lg active:scale-[0.98] transition-all"
        >
          Get Started
        </button>
      </div>

      {/* Hide scrollbar globally */}
      <style>{`
        .scrollbar-hide::-webkit-scrollbar {
          display: none;
        }
        
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
    </div>
  );
}