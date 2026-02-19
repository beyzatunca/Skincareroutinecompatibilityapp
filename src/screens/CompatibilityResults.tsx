import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router';
import { 
  ChevronLeft, 
  Share2, 
  AlertTriangle,
  Calendar,
  X,
  ChevronDown
} from 'lucide-react';
import { useApp } from '../context/AppContext';

export function CompatibilityResults() {
  const navigate = useNavigate();
  const { compatibilityResult, routine } = useApp();
  const [activeTab, setActiveTab] = useState<'AM' | 'PM'>('AM');
  const [isConflictsOpen, setIsConflictsOpen] = useState(false);
  const [isBarrierDamageOpen, setIsBarrierDamageOpen] = useState(false);

  useEffect(() => {
    if (!compatibilityResult) {
      navigate('/routine');
    }
  }, [compatibilityResult, navigate]);

  if (!compatibilityResult) {
    return null;
  }

  // Group conflicts by type
  const chemicalInactivation = compatibilityResult.conflicts.filter(c => 
    c.title.toLowerCase().includes('inactivation') || 
    c.title.toLowerCase().includes('reduced effectiveness') ||
    c.description.toLowerCase().includes('effectiveness')
  );
  
  const barrierDamage = compatibilityResult.conflicts.filter(c => 
    c.title.toLowerCase().includes('barrier') || 
    c.title.toLowerCase().includes('irritation') ||
    c.description.toLowerCase().includes('irritation')
  );

  return (
    <div className="min-h-screen bg-gradient-to-b from-red-50/30 to-white pb-32">
      {/* Header */}
      <div className="bg-white px-6 pt-16 pb-4 sticky top-0 z-10 border-b border-gray-100">
        <div className="flex items-center justify-between mb-2">
          <div className="w-6" /> {/* Spacer for alignment */}
          <h1 className="text-lg font-semibold text-gray-900">
            Analysis Results
          </h1>
          <button onClick={() => navigate('/')}>
            <X className="w-6 h-6 text-gray-900" />
          </button>
        </div>
      </div>

      {/* Scrollable Content */}
      <div className="px-6 py-6 space-y-6 relative z-10">
        {/* 1. Your Barrier is Under Risk */}
        <div className="bg-white/90 backdrop-blur-xl rounded-3xl p-6 border-2 border-red-200 shadow-sm">
          <div className="flex items-start gap-4 mb-4">
            <div className="p-3 rounded-2xl bg-red-100 border-2 border-red-200">
              <AlertTriangle className="w-6 h-6 text-red-600" />
            </div>
            <div className="flex-1">
              <h2 className="text-lg font-bold text-gray-900 mb-2">
                Your Barrier is Under Risk
              </h2>
              <p className="text-sm text-gray-700 leading-relaxed">
                {compatibilityResult.riskLevel === 'High' && 
                  "Multiple conflicts detected that can compromise your skin barrier and reduce product effectiveness. Using these products together increases risk of irritation, redness, and sensitivity."
                }
                {compatibilityResult.riskLevel === 'Medium' && 
                  "Some ingredients may interact negatively when used together. Follow the safe schedule below to minimize irritation while maintaining results."
                }
                {compatibilityResult.riskLevel === 'Low' && 
                  "Your routine has minor conflicts that should be addressed for optimal results and skin health."
                }
              </p>
            </div>
          </div>
        </div>

        {/* 2. Avoid Section */}
        <div className="bg-white/90 backdrop-blur-xl rounded-3xl p-6 border-2 border-orange-200 shadow-sm">
          <h3 className="text-lg font-bold text-gray-900 mb-5 flex items-center gap-2">
            <X className="w-5 h-5 text-orange-600" />
            Avoid
          </h3>

          {/* Ingredient Conflicts */}
          <div className="mb-6">
            <button
              onClick={() => setIsConflictsOpen(!isConflictsOpen)}
              className="w-full flex items-center justify-between mb-3"
            >
              <div className="flex items-center gap-2">
                <h4 className="text-sm font-bold text-gray-900">
                  Ingredient Conflicts
                </h4>
                <span className="text-xs text-gray-500 font-semibold">(1)</span>
              </div>
              <ChevronDown 
                className={`w-4 h-4 text-gray-600 transition-transform ${
                  isConflictsOpen ? 'rotate-180' : ''
                }`}
              />
            </button>
            
            {isConflictsOpen && (
              <>
                <p className="text-xs text-gray-600 mb-3">
                  Don't use together in the same routine.
                </p>
                <ul className="space-y-3">
                  <li className="pl-3 border-l-2 border-orange-300">
                    <p className="text-sm font-semibold text-gray-900 mb-1">
                      Product A × Product B
                    </p>
                    <p className="text-xs text-orange-700 mb-1">
                      Conflicting actives: Retinoid + Benzoyl Peroxide
                    </p>
                    <p className="text-xs text-gray-600">
                      Increased irritation / reduced tolerance
                    </p>
                  </li>
                </ul>
              </>
            )}
          </div>

          {/* Skin Barrier Damage */}
          <div>
            <button
              onClick={() => setIsBarrierDamageOpen(!isBarrierDamageOpen)}
              className="w-full flex items-center justify-between mb-3"
            >
              <div className="flex items-center gap-2">
                <h4 className="text-sm font-bold text-gray-900">
                  Skin Barrier Damage
                </h4>
                <span className="text-xs text-gray-500 font-semibold">(3)</span>
              </div>
              <ChevronDown 
                className={`w-4 h-4 text-gray-600 transition-transform ${
                  isBarrierDamageOpen ? 'rotate-180' : ''
                }`}
              />
            </button>
            
            {isBarrierDamageOpen && (
              <>
                <p className="text-xs text-gray-600 mb-3">
                  You're stacking too much of the same active.
                </p>
                <ul className="space-y-3">
                  <li className="pl-3 border-l-2 border-red-300">
                    <p className="text-sm font-semibold text-gray-900 mb-0.5">
                      AHA/BHA (acids)
                    </p>
                    <p className="text-xs text-gray-600">
                      found in: Product A, Product D, Product F
                    </p>
                  </li>
                  <li className="pl-3 border-l-2 border-red-300">
                    <p className="text-sm font-semibold text-gray-900 mb-0.5">
                      Retinoids
                    </p>
                    <p className="text-xs text-gray-600">
                      found in: Product C, Product E
                    </p>
                  </li>
                  <li className="pl-3 border-l-2 border-red-300">
                    <p className="text-sm font-semibold text-gray-900 mb-0.5">
                      Vitamin C
                    </p>
                    <p className="text-xs text-gray-600">
                      found in: Product B, Product G
                    </p>
                  </li>
                </ul>
              </>
            )}
          </div>
        </div>

        {/* 3. Suggested Safe Schedule */}
        <div className="bg-white/90 backdrop-blur-xl rounded-3xl p-6 border-2 border-cyan-200 shadow-sm">
          <div className="flex items-center gap-3 mb-5">
            <div className="p-2.5 bg-cyan-100 rounded-xl">
              <Calendar className="w-5 h-5 text-cyan-600" />
            </div>
            <h3 className="text-lg font-bold text-gray-900">
              Your Safe Schedule
            </h3>
          </div>

          {/* AM/PM Tabs */}
          <div className="flex gap-2 mb-5">
            <button
              onClick={() => setActiveTab('AM')}
              className={`flex-1 py-3 px-4 rounded-xl font-semibold transition-all ${
                activeTab === 'AM'
                  ? 'bg-cyan-500 text-white shadow-md'
                  : 'bg-gray-100 text-gray-600'
              }`}
            >
              Morning
            </button>
            <button
              onClick={() => setActiveTab('PM')}
              className={`flex-1 py-3 px-4 rounded-xl font-semibold transition-all ${
                activeTab === 'PM'
                  ? 'bg-cyan-500 text-white shadow-md'
                  : 'bg-gray-100 text-gray-600'
              }`}
            >
              Evening
            </button>
          </div>

          {/* AM Routine */}
          {activeTab === 'AM' && (
            <div className="space-y-2">
              {compatibilityResult.suggestedSchedule.AM.length === 0 ? (
                <p className="text-sm text-gray-500 text-center py-6">
                  No AM products in your routine
                </p>
              ) : (
                compatibilityResult.suggestedSchedule.AM.map((item, idx) => (
                  <div key={item.id} className="flex items-center gap-3 p-3 bg-gray-50 rounded-xl">
                    <div className="w-7 h-7 bg-cyan-100 text-cyan-600 rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0">
                      {idx + 1}
                    </div>
                    <p className="text-sm text-gray-900 font-medium">
                      {item.product.productName}
                    </p>
                  </div>
                ))
              )}
            </div>
          )}

          {/* PM Routine */}
          {activeTab === 'PM' && (
            <div className="space-y-2">
              {Object.entries(compatibilityResult.suggestedSchedule.PM).length === 0 ? (
                <p className="text-sm text-gray-500 text-center py-6">
                  No PM products in your routine
                </p>
              ) : (
                Object.entries(compatibilityResult.suggestedSchedule.PM).flatMap(([night, items]) => 
                  items.map((item, idx) => (
                    <div key={item.id} className="flex items-center gap-3 p-3 bg-gray-50 rounded-xl">
                      <div className="w-7 h-7 bg-cyan-100 text-cyan-600 rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0">
                        {idx + 1}
                      </div>
                      <p className="text-sm text-gray-900 font-medium">
                        {item.product.productName}
                      </p>
                    </div>
                  ))
                )
              )}
            </div>
          )}
        </div>
      </div>

      {/* Sticky Bottom CTA Bar */}
      <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 px-6 py-4 safe-area-inset-bottom z-20">
        <button
          onClick={() => navigate('/')}
          style={{
            background: 'linear-gradient(to bottom right, #C8E6E0, #D8F0EC, #F0F9F7)'
          }}
          className="w-full text-gray-900 rounded-2xl py-4 font-bold active:scale-[0.98] transition-all shadow-lg"
        >
          Adjust My Routine
        </button>
      </div>
    </div>
  );
}
