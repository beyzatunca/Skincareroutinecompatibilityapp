import { useState, useRef, useEffect } from 'react';
import { useNavigate } from 'react-router';
import { Search, Droplet, Wind, Sparkles, Sun, Shield, Zap, ChevronRight, ScanBarcode, Star, Lock } from 'lucide-react';
import { useApp } from '../context/AppContext';
import { SkincareRoutineCard } from '../components/SkincareRoutineCard';

const categories = [
  { name: 'Cleanser', icon: Droplet, gradient: 'from-blue-400 to-cyan-400' },
  { name: 'Toner', icon: Wind, gradient: 'from-purple-400 to-pink-400' },
  { name: 'Serum', icon: Sparkles, gradient: 'from-pink-400 to-rose-400' },
  { name: 'Moisturizer', icon: Droplet, gradient: 'from-cyan-400 to-teal-400' },
  { name: 'SPF', icon: Sun, gradient: 'from-orange-400 to-amber-400' },
  { name: 'Treatment', icon: Shield, gradient: 'from-indigo-400 to-purple-400' }
];

const articles = [
  {
    title: 'Morning Skincare Routine',
    description: 'Essential steps for glowing skin',
    image: 'https://images.unsplash.com/photo-1650963764655-91902eedb9bd?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxza2luY2FyZSUyMG1vcm5pbmclMjByb3V0aW5lJTIwYmxvZ3xlbnwxfHx8fDE3NzA1Njg0Nzl8MA&ixlib=rb-4.1.0&q=80&w=1080',
    tag: 'Routine'
  },
  {
    title: 'Retinol + Vitamin C Guide',
    description: 'Can you use them together?',
    image: 'https://images.unsplash.com/photo-1729704166657-9a5744b7200c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxyZXRpbm9sJTIwdml0YW1pbiUyMGMlMjBza2luY2FyZSUyMGVkdWNhdGlvbnxlbnwxfHx8fDE3NzA1Njg0Nzl8MA&ixlib=rb-4.1.0&q=80&w=1080',
    tag: 'Education'
  },
  {
    title: 'Protect Your Skin Barrier',
    description: 'Signs & solutions for damaged skin',
    image: 'https://images.unsplash.com/photo-1768377547381-7a270977be53?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxza2luJTIwYmFycmllciUyMGhlYWx0aCUyMHdlbGxuZXNzfGVufDF8fHx8MTc3MDU2ODQ4MHww&ixlib=rb-4.1.0&q=80&w=1080',
    tag: 'Health'
  }
];

export function Home() {
  const navigate = useNavigate();
  const { userProfile, routine } = useApp();
  const [currentBanner, setCurrentBanner] = useState(0);
  const bannerScrollRef = useRef<HTMLDivElement>(null);

  // Separate AM and PM products
  const amProducts = routine.filter(r => r.timeOfDay === 'AM' || r.timeOfDay === 'Both');
  const pmProducts = routine.filter(r => r.timeOfDay === 'PM' || r.timeOfDay === 'Both');

  // Handle banner scroll
  useEffect(() => {
    const container = bannerScrollRef.current;
    if (!container) return;

    const handleScroll = () => {
      const scrollLeft = container.scrollLeft;
      const cardWidth = container.offsetWidth - 48; // accounting for padding
      const newIndex = Math.round(scrollLeft / cardWidth);
      setCurrentBanner(newIndex);
    };

    container.addEventListener('scroll', handleScroll);
    return () => container.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <div className="min-h-screen bg-white pb-24">
      {/* Your Skincare Routine Panel - No padding, full width */}
      <SkincareRoutineCard amProducts={amProducts} pmProducts={pmProducts} />

      {/* Articles/Blog Banners - Carousel */}
      <div className="py-4 bg-white">
        <div className="px-6 mb-4">
          <h2 className="text-lg font-semibold text-gray-900">
            Learn & Discover
          </h2>
        </div>

        <div 
          ref={bannerScrollRef}
          className="flex gap-4 overflow-x-auto snap-x snap-mandatory scrollbar-hide px-6"
        >
          {articles.map((article, index) => (
            <div
              key={index}
              className="flex-shrink-0 w-[calc(100%-48px)] snap-center"
            >
              <div className="relative h-48 rounded-3xl overflow-hidden shadow-lg">
                <img 
                  src={article.image} 
                  alt={article.title}
                  className="w-full h-full object-cover"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent" />
                
                <div className="absolute bottom-0 left-0 right-0 p-5">
                  <span className="inline-block px-3 py-1 bg-cyan-500/90 text-white text-xs font-medium rounded-full mb-2">
                    {article.tag}
                  </span>
                  <h3 className="text-xl font-semibold text-white mb-1">
                    {article.title}
                  </h3>
                  <p className="text-sm text-white/90">
                    {article.description}
                  </p>
                </div>

                <button className="absolute top-4 right-4 w-8 h-8 rounded-full bg-white/20 backdrop-blur-sm flex items-center justify-center">
                  <ChevronRight className="w-5 h-5 text-white" />
                </button>
              </div>
            </div>
          ))}
        </div>

        {/* Pagination Dots - Centered Below Banners */}
        <div className="flex justify-center gap-1.5 mt-4">
          {articles.map((_, index) => (
            <div
              key={index}
              className={`h-1.5 rounded-full transition-all duration-300 ${
                index === currentBanner 
                  ? 'w-6 bg-cyan-500' 
                  : 'w-1.5 bg-gray-300'
              }`}
            />
          ))}
        </div>
      </div>
    </div>
  );
}