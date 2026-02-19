import { useState } from 'react';
import { useNavigate, useParams, useSearchParams } from 'react-router';
import { ChevronLeft, Plus, AlertTriangle, CheckCircle2, AlertCircle, Clock, Tag, Check, X, Heart, ShoppingCart, Sparkles } from 'lucide-react';
import { sampleProducts } from '../data/products';
import { useApp } from '../context/AppContext';
import { RoutineItem } from '../types';
import { toast } from 'sonner@2.0.3';
import { AIChatbotButton } from '../components/AIChatbotButton';

export function ProductDetail() {
  const navigate = useNavigate();
  const { id } = useParams();
  const [searchParams] = useSearchParams();
  const isPersonalized = searchParams.get('personalized') === 'true';
  const fromHome = searchParams.get('fromHome') === 'true';
  const { addToRoutine, userProfile, wishlist, addToWishlist, removeFromWishlist } = useApp();

  const product = sampleProducts.find(p => p.id === id);
  const [showAddSheet, setShowAddSheet] = useState(false);
  const [selectedTime, setSelectedTime] = useState<'AM' | 'PM' | 'Both'>('PM');
  const [selectedFrequency, setSelectedFrequency] = useState<'daily' | '2-3x week' | 'alternate days'>('daily');
  const [isLoading, setIsLoading] = useState(false);
  const [showAllIngredients, setShowAllIngredients] = useState(false);

  // Debug: log userProfile
  console.log('UserProfile:', userProfile);
  console.log('Skin Concerns:', userProfile.skinConcerns);
  console.log('Must Haves:', userProfile.mustHaves);

  if (!product) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <p className="text-gray-600">Product not found</p>
      </div>
    );
  }

  const handleAddToRoutine = () => {
    const routineItem: RoutineItem = {
      id: Date.now().toString(),
      product,
      timeOfDay: selectedTime,
      frequency: selectedFrequency
    };
    addToRoutine(routineItem);
    setShowAddSheet(false);
    
    // Show success toast notification
    toast.success('Product added successfully');
    
    // Navigate to Home
    setTimeout(() => {
      navigate('/');
    }, 300);
  };

  // Personalized fit calculation
  const getFitLabel = () => {
    if (!isPersonalized || !userProfile.setupCompleted) return null;

    const avoidMatch = product.keyActives.some(active =>
      userProfile.avoidIngredients?.some(avoid =>
        active.toLowerCase().includes(avoid.toLowerCase())
      )
    );

    if (avoidMatch) return 'Avoid';

    const concernMatch = userProfile.skinConcerns?.some(concern =>
      product.description?.toLowerCase().includes(concern.toLowerCase())
    );

    return concernMatch ? 'Great Fit' : 'Partial Match';
  };

  const fitLabel = getFitLabel();

  const getFitColor = (label: string | null) => {
    if (label === 'Great Fit') return 'bg-green-100 text-green-700 border-green-200';
    if (label === 'Partial Match') return 'bg-orange-100 text-orange-700 border-orange-200';
    if (label === 'Avoid') return 'bg-red-100 text-red-700 border-red-200';
    return '';
  };

  const isInWishlist = wishlist.includes(product.id);

  const handleWishlistToggle = () => {
    if (isInWishlist) {
      removeFromWishlist(product.id);
      toast.success('Removed from wishlist');
    } else {
      addToWishlist(product.id);
      toast.success('Product added to wishlist successfully');
    }
  };

  const handleAmazonLink = () => {
    // Create Amazon search URL with brand and product name
    const searchQuery = encodeURIComponent(`${product.brand} ${product.productName}`);
    const amazonUrl = `https://www.amazon.com/s?k=${searchQuery}`;
    
    // Open in new tab
    window.open(amazonUrl, '_blank');
    toast.success('Opening Amazon...');
  };

  return (
    <>
      <div className="min-h-screen bg-gray-50 pb-32">
        {/* Header - Compact */}
        <div className="bg-white px-6 pt-14 pb-2 sticky top-0 z-10">
          <button onClick={() => navigate(-1)}>
            <ChevronLeft className="w-6 h-6 text-gray-900" />
          </button>
        </div>

        {/* Product Image */}
        <div className="px-6 pt-4">
          <div className="relative w-full h-56 bg-gray-100 rounded-3xl mb-5 overflow-hidden">
            <img 
              src="https://images.unsplash.com/photo-1616750819574-7e38aa8046fa?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx0aGUlMjBvcmRpbmFyeSUyMHNraW5jYXJlJTIwYm90dGxlfGVufDF8fHx8MTc3MDU4MzU4NXww&ixlib=rb-4.1.0&q=80&w=1080"
              alt={product.productName}
              className="w-full h-full object-cover"
            />
          </div>
        </div>

        {/* Product Info */}
        <div className="px-6 space-y-6">
          {/* Content */}
          <div className="space-y-4 px-6">
            {/* Basic Info */}
            <div>
              <p className="text-sm text-gray-600 mb-1">{product.brand}</p>
              <h1 className="text-2xl font-semibold text-gray-900 mb-2">
                {product.productName}
              </h1>
              <div className="flex flex-wrap gap-2 mb-3">
                <span className="inline-block px-3 py-1 bg-gray-100 text-gray-700 text-sm font-medium rounded-full">
                  {product.category}
                </span>
                {/* Product Features as chips */}
                <span className="px-3 py-1 bg-purple-50 text-purple-700 text-xs font-medium rounded-full border border-purple-200">
                  Alcohol-Free
                </span>
                <span className="px-3 py-1 bg-blue-50 text-blue-700 text-xs font-medium rounded-full border border-blue-200">
                  Fragrance-Free
                </span>
                <span className="px-3 py-1 bg-green-50 text-green-700 text-xs font-medium rounded-full border border-green-200">
                  Cruelty-Free
                </span>
                <span className="px-3 py-1 bg-pink-50 text-pink-700 text-xs font-medium rounded-full border border-pink-200">
                  Vegan
                </span>
              </div>
            </div>

            {/* Personalized View: Concern Match + Personalized Benefits/Warnings */}
            {isPersonalized && (
              <>
                {/* Concern Match Card */}
                <div className="bg-gradient-to-br from-cyan-50 to-blue-50 rounded-2xl p-6 border border-cyan-100">
                  <div className="flex items-start gap-3 mb-3">
                    <div className="w-8 h-8 rounded-full bg-cyan-500 flex items-center justify-center flex-shrink-0">
                      <CheckCircle2 className="w-5 h-5 text-white" />
                    </div>
                    <div className="flex-1">
                      <h2 className="font-semibold text-gray-900 mb-1">Perfect Match for Your Concerns</h2>
                      <p className="text-sm text-gray-700">
                        Based on your {userProfile.skinType} skin type
                      </p>
                    </div>
                  </div>
                  
                  {/* Concern-specific benefits */}
                  <div className="space-y-2 mt-4">
                    {userProfile.skinConcerns?.includes('Acne') && (
                      <div className="flex items-start gap-2">
                        <div className="w-1.5 h-1.5 rounded-full bg-cyan-500 mt-2 flex-shrink-0" />
                        <p className="text-sm text-gray-700">
                          <span className="font-medium">Acne Treatment:</span> Glycolic acid helps unclog pores and prevent breakouts
                        </p>
                      </div>
                    )}
                    {userProfile.skinConcerns?.includes('Hyperpigmentation') && (
                      <div className="flex items-start gap-2">
                        <div className="w-1.5 h-1.5 rounded-full bg-cyan-500 mt-2 flex-shrink-0" />
                        <p className="text-sm text-gray-700">
                          <span className="font-medium">Brightening:</span> AHA exfoliates to fade dark spots and improve skin tone
                        </p>
                      </div>
                    )}
                    {userProfile.skinConcerns?.includes('Texture') && (
                      <div className="flex items-start gap-2">
                        <div className="w-1.5 h-1.5 rounded-full bg-cyan-500 mt-2 flex-shrink-0" />
                        <p className="text-sm text-gray-700">
                          <span className="font-medium">Smooth Texture:</span> Exfoliating action removes dead cells for refined skin
                        </p>
                      </div>
                    )}
                    {(userProfile.skinType === 'Oily' || userProfile.skinType === 'Combination') && (
                      <div className="flex items-start gap-2">
                        <div className="w-1.5 h-1.5 rounded-full bg-cyan-500 mt-2 flex-shrink-0" />
                        <p className="text-sm text-gray-700">
                          <span className="font-medium">Oil Control:</span> Lightweight formula won't clog pores or feel greasy
                        </p>
                      </div>
                    )}
                  </div>
                </div>

                {/* Benefits for Your Skin */}
                {product.positiveEffects && product.positiveEffects.length > 0 && (
                  <div className="bg-white rounded-2xl p-6">
                    <h2 className="font-semibold text-gray-900 mb-4">Benefits for Your {userProfile.skinType} Skin</h2>
                    <div className="space-y-3">
                      {product.positiveEffects.map((item, idx) => (
                        <div key={`positive-${idx}`} className="flex gap-3">
                          <div className="w-1.5 h-1.5 rounded-full bg-green-500 mt-2 flex-shrink-0" />
                          <div className="flex-1">
                            <p className="text-sm font-medium text-gray-900">{item.effect}</p>
                            <p className="text-sm text-gray-600 mt-0.5">{item.description}</p>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                {/* What to Watch For */}
                {product.negativeEffects && product.negativeEffects.length > 0 && (
                  <div className="bg-white rounded-2xl p-6">
                    <h2 className="font-semibold text-gray-900 mb-4">What to Watch For</h2>
                    <div className="space-y-3">
                      {product.negativeEffects.map((item, idx) => (
                        <div key={`negative-${idx}`} className="flex gap-3">
                          <div className="w-1.5 h-1.5 rounded-full bg-amber-500 mt-2 flex-shrink-0" />
                          <div className="flex-1">
                            <p className="text-sm font-medium text-gray-900">{item.effect}</p>
                            <p className="text-sm text-gray-600 mt-0.5">Active: {item.activeIngredient}</p>
                            {userProfile.skinType === 'Sensitive' && (
                              <p className="text-sm text-amber-700 mt-1">⚠️ Start slowly with your sensitive skin</p>
                            )}
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
              </>
            )}

            {/* Non-Personalized View: Premium Upsell + General Info */}
            {!isPersonalized && (
              <>
                {/* Premium Upsell - Compact Chip Design */}
                <div 
                  onClick={() => navigate('/profile')}
                  className="bg-gradient-to-r from-cyan-500 to-blue-500 rounded-xl p-4 cursor-pointer active:scale-[0.98] transition-transform"
                >
                  <div className="flex items-center justify-between gap-3">
                    <div className="flex items-center gap-3 flex-1">
                      <div className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center flex-shrink-0">
                        <CheckCircle2 className="w-4 h-4 text-white" />
                      </div>
                      <div>
                        <p className="text-white font-semibold text-sm">Get Personalized Results</p>
                        <p className="text-white/80 text-xs">See how this fits your skin type and routine concerns</p>
                      </div>
                    </div>
                    <ChevronLeft className="w-5 h-5 text-white rotate-180 flex-shrink-0" />
                  </div>
                </div>

                {/* Positive Effects */}
                {product.positiveEffects && product.positiveEffects.length > 0 && (
                  <div className="bg-white rounded-2xl p-6">
                    <h2 className="font-semibold text-gray-900 mb-4">Positive Effects</h2>
                    <div className="space-y-3">
                      {product.positiveEffects.map((item, idx) => (
                        <div key={`positive-${idx}`} className="flex gap-3">
                          <div className="w-1.5 h-1.5 rounded-full bg-green-500 mt-2 flex-shrink-0" />
                          <div className="flex-1">
                            <p className="text-sm font-medium text-gray-900">{item.effect}</p>
                            <p className="text-sm text-gray-600 mt-0.5">{item.description}</p>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                {/* Negative Effects */}
                {product.negativeEffects && product.negativeEffects.length > 0 && (
                  <div className="bg-white rounded-2xl p-6">
                    <h2 className="font-semibold text-gray-900 mb-4">Negative Effects</h2>
                    <div className="space-y-3">
                      {product.negativeEffects.map((item, idx) => (
                        <div key={`negative-${idx}`} className="flex gap-3">
                          <div className="w-1.5 h-1.5 rounded-full bg-red-500 mt-2 flex-shrink-0" />
                          <div className="flex-1">
                            <p className="text-sm font-medium text-gray-900">{item.effect}</p>
                            <p className="text-sm text-gray-600 mt-0.5">Active: {item.activeIngredient}</p>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
              </>
            )}

            {/* Key Actives */}
            <div className="bg-white rounded-2xl p-6">
              <h2 className="font-semibold text-gray-900 mb-4">Key Actives</h2>
              <div className="flex flex-wrap gap-2 mb-4">
                {product.keyActives.map((active, idx) => (
                  <span
                    key={idx}
                    className="px-3 py-2 bg-cyan-50 text-cyan-700 text-sm font-medium rounded-full border border-cyan-200"
                  >
                    {active}
                  </span>
                ))}
              </div>
              <p className="text-sm text-gray-600 leading-relaxed mb-4">
                {product.description}
              </p>
              
              {/* Full Ingredients Link */}
              {product.ingredientsList && product.ingredientsList.length > 0 && (
                <>
                  <button
                    onClick={() => setShowAllIngredients(!showAllIngredients)}
                    className="text-cyan-600 text-sm font-medium flex items-center gap-1"
                  >
                    {showAllIngredients ? 'Hide full list of ingredients' : 'See full list of ingredients'}
                  </button>
                  
                  {/* Full Ingredients List */}
                  {showAllIngredients && (
                    <div className="mt-4 pt-4 border-t border-gray-100">
                      <div className="flex flex-wrap gap-2">
                        {product.ingredientsList.map((ingredient, idx) => {
                          // Determine ingredient status based on user profile
                          const getIngredientStatus = () => {
                            if (!isPersonalized) return 'neutral';
                            
                            // Check if ingredient should be avoided
                            const shouldAvoid = userProfile.avoidIngredients?.some(avoid =>
                              ingredient.toLowerCase().includes(avoid.toLowerCase()) ||
                              avoid.toLowerCase().includes(ingredient.toLowerCase())
                            );
                            if (shouldAvoid) return 'avoid';
                            
                            // Check if ingredient is in must-haves or beneficial
                            const isBeneficial = userProfile.mustHaves?.some(mustHave =>
                              ingredient.toLowerCase().includes(mustHave.toLowerCase()) ||
                              mustHave.toLowerCase().includes(ingredient.toLowerCase())
                            ) || product.keyActives.some(active =>
                              ingredient.toLowerCase().includes(active.toLowerCase()) ||
                              active.toLowerCase().includes(ingredient.toLowerCase())
                            );
                            if (isBeneficial) return 'beneficial';
                            
                            // Unknown effect
                            return 'unknown';
                          };
                          
                          const status = getIngredientStatus();
                          
                          const getIngredientStyle = () => {
                            if (status === 'avoid') return 'bg-red-50 text-red-700 border-red-200';
                            if (status === 'beneficial') return 'bg-green-50 text-green-700 border-green-200';
                            if (status === 'unknown') return 'bg-orange-50 text-orange-700 border-orange-200';
                            return 'bg-gray-50 text-gray-700 border-gray-200';
                          };
                          
                          return (
                            <span 
                              key={`ingredient-${idx}`}
                              className={`px-3 py-1.5 text-xs font-medium rounded-lg border ${getIngredientStyle()}`}
                            >
                              {ingredient}
                            </span>
                          );
                        })}
                      </div>
                      
                      {/* Legend - Only show for personalized view */}
                      {isPersonalized && (
                        <div className="mt-4 pt-4 border-t border-gray-100">
                          <p className="text-xs font-medium text-gray-700 mb-2">Ingredient Guide:</p>
                          <div className="flex flex-wrap gap-3">
                            <div className="flex items-center gap-1.5">
                              <div className="w-3 h-3 rounded-full bg-green-500" />
                              <span className="text-xs text-gray-600">Good for you</span>
                            </div>
                            <div className="flex items-center gap-1.5">
                              <div className="w-3 h-3 rounded-full bg-orange-500" />
                              <span className="text-xs text-gray-600">Unknown effect</span>
                            </div>
                            <div className="flex items-center gap-1.5">
                              <div className="w-3 h-3 rounded-full bg-red-500" />
                              <span className="text-xs text-gray-600">Avoid</span>
                            </div>
                          </div>
                        </div>
                      )}
                    </div>
                  )}
                </>
              )}
            </div>

            {/* How to Use - AI Summary */}
            <div className="bg-white rounded-2xl p-6">
              <h2 className="font-semibold text-gray-900 mb-4">How to Use</h2>
              <div className="space-y-3">
                <div className="flex gap-3">
                  <div className="w-1.5 h-1.5 rounded-full bg-cyan-500 mt-2 flex-shrink-0" />
                  <p className="text-sm text-gray-700 flex-1">
                    Apply 3-4 drops to clean, dry skin after cleansing and toning
                  </p>
                </div>
                <div className="flex gap-3">
                  <div className="w-1.5 h-1.5 rounded-full bg-cyan-500 mt-2 flex-shrink-0" />
                  <p className="text-sm text-gray-700 flex-1">
                    Gently pat into skin, avoiding the eye area
                  </p>
                </div>
                <div className="flex gap-3">
                  <div className="w-1.5 h-1.5 rounded-full bg-cyan-500 mt-2 flex-shrink-0" />
                  <p className="text-sm text-gray-700 flex-1">
                    Follow with moisturizer and SPF (AM) or night cream (PM)
                  </p>
                </div>
                <div className="flex gap-3">
                  <div className="w-1.5 h-1.5 rounded-full bg-cyan-500 mt-2 flex-shrink-0" />
                  <p className="text-sm text-gray-700 flex-1">
                    Start slowly - use 2-3 times per week and gradually increase
                  </p>
                </div>
              </div>
            </div>

            {/* Usage Frequency */}
            <div className="bg-white rounded-2xl p-6">
              <div className="flex items-center gap-2 mb-4">
                <Clock className="w-5 h-5 text-cyan-600" />
                <h2 className="font-semibold text-gray-900">Recommended Frequency</h2>
              </div>
              <div className="space-y-4">
                <div className="py-3 px-4 bg-cyan-50 rounded-xl border border-cyan-100">
                  <span className="text-sm font-medium text-gray-900 block mb-1">Standard Use</span>
                  <span className="text-sm text-gray-600">3-4 times per week (PM only) - e.g., Mon, Wed, Fri, Sat</span>
                </div>
                <div className="py-3 px-4 bg-gray-50 rounded-xl">
                  <span className="text-sm font-medium text-gray-900 block mb-1">Sensitive Skin</span>
                  <span className="text-sm text-gray-600">1-2 times per week - e.g., Mon, Thu</span>
                </div>
              </div>
            </div>

            {/* Routine Placement - Only for personalized view */}
            {isPersonalized && (
              <div className="bg-white rounded-2xl p-6">
                <h2 className="font-semibold text-gray-900 mb-4">Routine Placement</h2>
                
                {/* Current Step Label */}
                <div className="mb-4">
                  <span className="inline-block px-4 py-2 bg-cyan-100 text-cyan-700 text-sm font-semibold rounded-lg">
                    {(() => {
                      if (product.category === 'Cleanser') return 'Cleansing Step';
                      if (product.category === 'Toner') return 'Toning Step';
                      if (product.category === 'Serum' || product.category === 'Treatment') return 'Treatment Step';
                      if (product.category === 'Moisturizer') return 'Moisturizing Step';
                      if (product.category === 'SPF') return 'Protection Step';
                      if (product.category === 'Mask') return 'Treatment Mask Step';
                      if (product.category === 'Eye Care') return 'Eye Care Step';
                      if (product.category === 'Exfoliator') return 'Exfoliation Step';
                      if (product.category === 'Makeup Remover') return 'Makeup Removal Step';
                      return 'Treatment Step';
                    })()}
                  </span>
                </div>
                
                <div className="overflow-x-auto -mx-6 px-6 scrollbar-hide">
                  <div className="flex items-center gap-2 pb-2" style={{ minWidth: 'max-content' }}>
                    {[
                      { label: 'Makeup Removal', category: 'Makeup Remover' },
                      { label: 'Cleansing', category: 'Cleanser' },
                      { label: 'Exfoliation', category: 'Exfoliator' },
                      { label: 'Toning', category: 'Toner' },
                      { label: 'Treatment', category: 'Treatment' },
                      { label: 'Treatment Mask', category: 'Mask' },
                      { label: 'Eye Care', category: 'Eye Care' },
                      { label: 'Moisturizing', category: 'Moisturizer' },
                      { label: 'Protection', category: 'SPF' }
                    ].map((step, idx, arr) => {
                      // Map product category to routine step
                      const getCategoryStep = () => {
                        if (product.category === 'Cleanser') return 'Cleansing';
                        if (product.category === 'Toner') return 'Toning';
                        if (product.category === 'Serum' || product.category === 'Treatment') return 'Treatment';
                        if (product.category === 'Moisturizer') return 'Moisturizing';
                        if (product.category === 'SPF') return 'Protection';
                        if (product.category === 'Mask') return 'Treatment Mask';
                        if (product.category === 'Eye Care') return 'Eye Care';
                        if (product.category === 'Exfoliator') return 'Exfoliation';
                        if (product.category === 'Makeup Remover') return 'Makeup Removal';
                        return step.label;
                      };
                      
                      const currentStep = getCategoryStep();
                      const isActive = step.label === currentStep;
                      
                      return (
                        <div key={step.label} className="flex items-center gap-2 flex-shrink-0">
                          <span
                            className={`px-4 py-2 rounded-full text-xs font-medium transition-all whitespace-nowrap ${
                              isActive
                                ? 'bg-cyan-500 text-white shadow-md scale-110'
                                : 'bg-gray-100 text-gray-600'
                            }`}
                          >
                            {step.label}
                          </span>
                          {idx < arr.length - 1 && (
                            <ChevronLeft className="w-4 h-4 text-gray-400 rotate-180 flex-shrink-0" />
                          )}
                        </div>
                      );
                    })}
                  </div>
                </div>
                <p className="text-xs text-gray-500 mt-3 text-center">Swipe to see the full routine flow →</p>
              </div>
            )}

            {/* Pregnancy Warning */}
            {product.pregnancyFlag && (
              <div className="bg-pink-50 rounded-2xl p-6 border border-pink-100">
                <div className="flex gap-3">
                  <AlertTriangle className="w-5 h-5 text-pink-600 flex-shrink-0 mt-0.5" />
                  <div>
                    <h3 className="font-semibold text-pink-900 mb-1">Pregnancy Safety</h3>
                    <p className="text-sm text-pink-800">
                      Not recommended during pregnancy or breastfeeding
                    </p>
                  </div>
                </div>
              </div>
            )}

            {/* Loading State for Analysis */}
            {isLoading && (
              <div className="bg-white rounded-2xl p-6">
                <div className="flex items-center gap-3">
                  <div className="w-5 h-5 border-2 border-blue-500 border-t-transparent rounded-full animate-spin" />
                  <p className="text-sm text-gray-600">Analyzing ingredients...</p>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Fixed Action Icons Bar - Bottom */}
      <div className="fixed bottom-0 left-0 right-0 z-30 safe-area-inset-bottom">
        <div className="px-6 py-4">
          {fromHome ? (
            /* From Home: Only show Add to Routine button */
            <div className="flex gap-3 justify-center overflow-x-auto scrollbar-hide">
              {/* Add to Routine */}
              <div className="relative group">
                <button
                  onClick={() => setShowAddSheet(true)}
                  className="flex-shrink-0 w-14 h-14 bg-white/70 backdrop-blur-md rounded-full flex items-center justify-center shadow-lg border border-white/50 active:scale-95 transition-transform"
                >
                  <Plus className="w-6 h-6 text-gray-700" strokeWidth={2.5} />
                </button>
                <div className="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 px-3 py-1.5 bg-gray-900 text-white text-xs font-medium rounded-lg whitespace-nowrap opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none">
                  Add to Routine
                </div>
              </div>
            </div>
          ) : (
            /* Normal flow: Show all buttons */
            <div className="flex gap-3 justify-center overflow-x-auto scrollbar-hide">
              {/* Add to Routine */}
              <div className="relative group">
                <button
                  onClick={() => setShowAddSheet(true)}
                  className="flex-shrink-0 w-14 h-14 bg-white/70 backdrop-blur-md rounded-full flex items-center justify-center shadow-lg border border-white/50 active:scale-95 transition-transform"
                >
                  <Plus className="w-6 h-6 text-gray-700" strokeWidth={2.5} />
                </button>
                <div className="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 px-3 py-1.5 bg-gray-900 text-white text-xs font-medium rounded-lg whitespace-nowrap opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none">
                  Add to Routine
                </div>
              </div>

              {/* Shopping Cart */}
              <div className="relative group">
                <button
                  onClick={handleAmazonLink}
                  className="flex-shrink-0 w-14 h-14 bg-white/70 backdrop-blur-md rounded-full flex items-center justify-center shadow-lg border border-white/50 active:scale-95 transition-transform"
                >
                  <ShoppingCart className="w-6 h-6 text-gray-700" strokeWidth={2} />
                </button>
                <div className="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 px-3 py-1.5 bg-gray-900 text-white text-xs font-medium rounded-lg whitespace-nowrap opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none">
                  Buy from Amazon
                </div>
              </div>

              {/* Wishlist */}
              <div className="relative group">
                <button
                  onClick={handleWishlistToggle}
                  className="flex-shrink-0 w-14 h-14 bg-white/70 backdrop-blur-md rounded-full flex items-center justify-center shadow-lg border border-white/50 active:scale-95 transition-transform"
                >
                  <Heart 
                    className={`w-6 h-6 transition-colors ${
                      isInWishlist 
                        ? 'text-pink-500 fill-pink-500' 
                        : 'text-gray-700'
                    }`}
                    strokeWidth={2}
                  />
                </button>
                <div className="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 px-3 py-1.5 bg-gray-900 text-white text-xs font-medium rounded-lg whitespace-nowrap opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none">
                  Add to Wishlist
                </div>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Bottom Sheet */}
      {showAddSheet && (
        <>
          <div
            className="fixed inset-0 bg-black/50 z-40"
            onClick={() => setShowAddSheet(false)}
          />
          <div className="fixed bottom-0 left-0 right-0 bg-white rounded-t-3xl z-50 animate-slide-up">
            <div className="px-6 pt-6 pb-8">
              <div className="w-12 h-1 bg-gray-300 rounded-full mx-auto mb-6" />
              <h3 className="text-xl font-semibold text-gray-900 mb-6">
                Add to Routine
              </h3>

              <div className="space-y-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-3">
                    Time of Day
                  </label>
                  <div className="grid grid-cols-3 gap-3">
                    {(['AM', 'PM', 'Both'] as const).map(time => (
                      <button
                        key={time}
                        onClick={() => setSelectedTime(time)}
                        className={`py-3 px-4 rounded-xl border-2 text-sm font-medium transition-all ${
                          selectedTime === time
                            ? 'border-transparent bg-gradient-to-br from-[#C8E6E0] via-[#D8F0EC] to-[#F0F9F7] text-gray-900'
                            : 'border-gray-200 bg-white text-gray-700'
                        }`}
                      >
                        {time}
                      </button>
                    ))}
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-3">
                    Frequency
                  </label>
                  <div className="space-y-2">
                    {(['daily', '2-3x week', 'alternate days'] as const).map(freq => (
                      <button
                        key={freq}
                        onClick={() => setSelectedFrequency(freq)}
                        className={`w-full py-3 px-4 rounded-xl border-2 text-sm font-medium text-left transition-all ${
                          selectedFrequency === freq
                            ? 'border-transparent bg-gradient-to-br from-[#C8E6E0] via-[#D8F0EC] to-[#F0F9F7] text-gray-900'
                            : 'border-gray-200 bg-white text-gray-700'
                        }`}
                      >
                        {freq === 'daily' ? 'Daily' : freq === '2-3x week' ? '2-3 times per week' : 'Alternate days'}
                      </button>
                    ))}
                  </div>
                </div>
              </div>

              <div className="mt-8 space-y-3">
                <button
                  onClick={handleAddToRoutine}
                  style={{
                    background: 'linear-gradient(to bottom right, #C8E6E0, #D8F0EC, #F0F9F7)'
                  }}
                  className="w-full text-gray-900 rounded-full py-4 font-semibold active:scale-[0.98] transition-all shadow-lg"
                >
                  Add Product
                </button>
                <button
                  onClick={() => setShowAddSheet(false)}
                  className="w-full text-gray-600 py-3 text-sm font-medium"
                >
                  Cancel
                </button>
              </div>
            </div>
          </div>
        </>
      )}

      {/* AI Chatbot Button */}
      <AIChatbotButton onClick={() => navigate(`/skincare-coach?productId=${product.id}`)} />
    </>
  );
}