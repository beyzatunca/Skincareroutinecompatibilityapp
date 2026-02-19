import { useState, useMemo } from 'react';
import { useNavigate, useSearchParams } from 'react-router';
import { ChevronLeft, Search as SearchIcon, X, Sparkles, Heart, Scan, ScanBarcode, Droplet, Wind, Sun, Shield } from 'lucide-react';
import { sampleProducts } from '../data/products';
import { Product } from '../types';
import { useApp } from '../context/AppContext';

const categories = [
  { name: 'Cleanser', icon: Droplet, gradient: 'from-blue-400 to-cyan-400' },
  { name: 'Toner', icon: Wind, gradient: 'from-purple-400 to-pink-400' },
  { name: 'Serum', icon: Sparkles, gradient: 'from-pink-400 to-rose-400' },
  { name: 'Moisturizer', icon: Droplet, gradient: 'from-cyan-400 to-teal-400' },
  { name: 'SPF', icon: Sun, gradient: 'from-orange-400 to-amber-400' },
  { name: 'Treatment', icon: Shield, gradient: 'from-indigo-400 to-purple-400' }
];

export function Search() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const isPersonalized = searchParams.get('personalized') === 'true';
  const fromHome = searchParams.get('fromHome') === 'true';
  const categoryFilter = searchParams.get('category');
  const { userProfile, routine, wishlist, recentScans } = useApp();

  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string>(categoryFilter || 'All');
  const [showFilters, setShowFilters] = useState(false);
  const [priceRange, setPriceRange] = useState<string>('All');
  const [showWishlistSheet, setShowWishlistSheet] = useState(false);
  const [showRecentScansSheet, setShowRecentScansSheet] = useState(false);

  const priceRanges = ['All', '$', '$$', '$$$'];

  // Smart scoring for personalized search
  const getPersonalizationScore = (product: Product): number => {
    if (!isPersonalized || !userProfile.setupCompleted) return 0;

    let score = 0;

    // Check skin type match
    if (userProfile.skinType) {
      const skinTypeKeywords: Record<string, string[]> = {
        'oily': ['oil control', 'mattifying', 'sebum', 'lightweight'],
        'dry': ['hydrating', 'moisturizing', 'nourishing', 'rich'],
        'combination': ['balancing', 'lightweight', 'hydrating'],
        'sensitive': ['gentle', 'soothing', 'calming', 'fragrance-free']
      };
      
      const keywords = skinTypeKeywords[userProfile.skinType.toLowerCase()] || [];
      const description = product.description?.toLowerCase() || '';
      keywords.forEach(keyword => {
        if (description.includes(keyword)) score += 3;
      });
    }

    // Check skin concerns match
    if (userProfile.skinConcerns) {
      userProfile.skinConcerns.forEach(concern => {
        const concernLower = concern.toLowerCase();
        if (product.description?.toLowerCase().includes(concernLower)) {
          score += 5;
        }
        if (product.keyActives.some(active => 
          active.toLowerCase().includes(concernLower.split(' ')[0])
        )) {
          score += 4;
        }
      });
    }

    // Check for avoided ingredients
    if (userProfile.avoidIngredients) {
      const hasAvoidedIngredient = product.keyActives.some(active =>
        userProfile.avoidIngredients?.some(avoid =>
          active.toLowerCase().includes(avoid.toLowerCase())
        )
      );
      if (hasAvoidedIngredient) score -= 10; // Penalty for avoided ingredients
    }

    // Sensitivity adjustment
    if (userProfile.sensitivity === 'high' && product.sensitivityWarnings.length === 0) {
      score += 2;
    } else if (userProfile.sensitivity === 'high' && product.sensitivityWarnings.length > 0) {
      score -= 3;
    }

    return score;
  };

  const filteredProducts = useMemo(() => {
    let products = sampleProducts.filter(product => {
      const matchesSearch = searchQuery === '' ||
        product.productName.toLowerCase().includes(searchQuery.toLowerCase()) ||
        product.brand.toLowerCase().includes(searchQuery.toLowerCase()) ||
        product.keyActives.some(active => active.toLowerCase().includes(searchQuery.toLowerCase()));

      const matchesCategory = selectedCategory === 'All' || product.category === selectedCategory;
      const matchesPrice = priceRange === 'All' || product.priceRange === priceRange;

      return matchesSearch && matchesCategory && matchesPrice;
    });

    // If personalized, sort by relevance score
    if (isPersonalized && userProfile.setupCompleted) {
      products = products
        .map(product => ({
          ...product,
          _score: getPersonalizationScore(product)
        }))
        .sort((a, b) => b._score - a._score);
    }

    return products;
  }, [searchQuery, selectedCategory, priceRange, isPersonalized, userProfile]);

  const handleProductClick = (product: Product) => {
    if (isPersonalized && fromHome) {
      navigate(`/product/${product.id}?personalized=true&fromHome=true`);
    } else if (isPersonalized) {
      navigate(`/product/${product.id}?personalized=true`);
    } else {
      navigate(`/product/${product.id}`);
    }
  };

  // Get wishlist products
  const wishlistProducts = sampleProducts.filter(product => wishlist.includes(product.id));

  // Get recent scans products
  const recentScansProducts = sampleProducts.filter(product => recentScans.includes(product.id));

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white px-6 pt-16 pb-4 sticky top-0 z-10">
        <div className="flex items-center gap-4 mb-4">
          <button onClick={() => navigate(-1)}>
            <ChevronLeft className="w-6 h-6 text-gray-900" />
          </button>
          <h1 className="text-xl font-semibold text-gray-900">
            {isPersonalized ? 'Personalized Search' : 'Discover Products'}
          </h1>
        </div>

        {/* Search Bar */}
        <div className="flex gap-2">
          <div className="flex-1 relative">
            <SearchIcon className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Search by name, brand, or active..."
              className="w-full pl-10 pr-4 py-3 bg-gray-100 rounded-full text-base focus:outline-none focus:ring-2 focus:ring-cyan-500"
              autoFocus
            />
            {searchQuery && (
              <button
                onClick={() => setSearchQuery('')}
                className="absolute right-3 top-1/2 -translate-y-1/2"
              >
                <X className="w-5 h-5 text-gray-400" />
              </button>
            )}
          </div>
        </div>

        {/* Category Pills */}
        <div className="flex gap-2 overflow-x-auto mt-4 pb-2 -mx-6 px-6 scrollbar-hide">
          <button
            key="All"
            onClick={() => setSelectedCategory('All')}
            style={
              selectedCategory === 'All'
                ? { background: 'linear-gradient(to bottom right, #C8E6E0, #D8F0EC, #F0F9F7)' }
                : {}
            }
            className={`px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-colors ${
              selectedCategory === 'All'
                ? 'text-gray-900'
                : 'bg-gray-100 text-gray-700'
            }`}
          >
            All
          </button>
          {categories.map(category => (
            <button
              key={category.name}
              onClick={() => setSelectedCategory(category.name)}
              style={
                selectedCategory === category.name
                  ? { background: 'linear-gradient(to bottom right, #C8E6E0, #D8F0EC, #F0F9F7)' }
                  : {}
              }
              className={`px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-colors ${
                selectedCategory === category.name
                  ? 'text-gray-900'
                  : 'bg-gray-100 text-gray-700'
              }`}
            >
              {category.name}
            </button>
          ))}
        </div>

        {/* Filters Panel */}
        {showFilters && (
          <div className="mt-4 p-4 bg-gray-50 rounded-xl">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Price Range
              </label>
              <div className="flex gap-2">
                {priceRanges.map(range => (
                  <button
                    key={range}
                    onClick={() => setPriceRange(range)}
                    className={`px-4 py-2 rounded-full text-sm font-medium transition-colors ${
                      priceRange === range
                        ? 'bg-cyan-500 text-white'
                        : 'bg-white text-gray-700 border border-gray-200'
                    }`}
                  >
                    {range}
                  </button>
                ))}
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Quick Access Panels */}
      <div className="px-6 py-4">
        <div className="flex gap-3 overflow-x-auto pb-2 -mx-6 px-6 scrollbar-hide">
          {/* Scan Product - Show only in personalized mode */}
          {isPersonalized && (
            <button
              onClick={() => navigate('/scanner')}
              className="flex-shrink-0 w-[140px] bg-gradient-to-br from-[#E8D5F2] to-[#F0E3F7] rounded-xl p-4 text-left active:opacity-90 transition-opacity shadow-sm"
            >
              <h3 className="text-xs font-semibold text-purple-900 mb-3">
                Scan Product
              </h3>
              <div className="w-12 h-12 bg-purple-200/40 backdrop-blur-sm rounded-xl flex items-center justify-center">
                <ScanBarcode className="w-6 h-6 text-purple-700" />
              </div>
            </button>
          )}

          {/* Wishlist - Show only in personalized mode */}
          {isPersonalized && (
            <button
              onClick={() => setShowWishlistSheet(true)}
              className="flex-shrink-0 w-[140px] bg-gradient-to-br from-[#FFE4E8] to-[#FFF0F3] rounded-xl p-4 text-left active:opacity-90 transition-opacity shadow-sm"
            >
              <h3 className="text-xs font-semibold text-pink-900 mb-3">
                Wishlist
              </h3>
              <div className="w-12 h-12 bg-pink-200/40 backdrop-blur-sm rounded-xl flex items-center justify-center">
                <Heart className="w-6 h-6 text-pink-700 fill-pink-700" />
              </div>
            </button>
          )}

          {/* Show all panels in non-personalized mode */}
          {!isPersonalized && (
            <>
              <button
                onClick={() => navigate('/scanner')}
                className="flex-shrink-0 w-[140px] bg-gradient-to-br from-[#E8D5F2] to-[#F0E3F7] rounded-xl p-4 text-left active:opacity-90 transition-opacity shadow-sm"
              >
                <h3 className="text-xs font-semibold text-purple-900 mb-3">
                  Scan Product
                </h3>
                <div className="w-12 h-12 bg-purple-200/40 backdrop-blur-sm rounded-xl flex items-center justify-center">
                  <ScanBarcode className="w-6 h-6 text-purple-700" />
                </div>
              </button>

              <button
                onClick={() => setShowWishlistSheet(true)}
                className="flex-shrink-0 w-[140px] bg-gradient-to-br from-[#FFE4E8] to-[#FFF0F3] rounded-xl p-4 text-left active:opacity-90 transition-opacity shadow-sm"
              >
                <h3 className="text-xs font-semibold text-pink-900 mb-3">
                  Wishlist
                </h3>
                <div className="w-12 h-12 bg-pink-200/40 backdrop-blur-sm rounded-xl flex items-center justify-center">
                  <Heart className="w-6 h-6 text-pink-700 fill-pink-700" />
                </div>
              </button>

              <button
                onClick={() => setShowRecentScansSheet(true)}
                className="flex-shrink-0 w-[140px] bg-gradient-to-br from-[#D4F1F4] to-[#E8F8FA] rounded-xl p-4 text-left active:opacity-90 transition-opacity shadow-sm"
              >
                <h3 className="text-xs font-semibold text-cyan-900 mb-3">
                  Recent Scans
                </h3>
                <div className="w-12 h-12 bg-cyan-200/40 backdrop-blur-sm rounded-xl flex items-center justify-center">
                  <Scan className="w-6 h-6 text-cyan-700" />
                </div>
              </button>
            </>
          )}
        </div>
      </div>

      {/* Results */}
      <div className="px-6 py-4">
        {filteredProducts.length === 0 ? (
          <div className="text-center py-12">
            <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <SearchIcon className="w-8 h-8 text-gray-400" />
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">
              No results found
            </h3>
            <p className="text-sm text-gray-600 mb-4">
              Try adjusting your filters or search terms
            </p>
            <button
              onClick={() => {
                setSearchQuery('');
                setSelectedCategory('All');
                setPriceRange('All');
              }}
              className="text-blue-500 font-medium text-sm"
            >
              Clear all filters
            </button>
          </div>
        ) : (
          <>
            {isPersonalized && userProfile.setupCompleted && (
              <div className="mb-4 p-4 bg-gradient-to-r from-purple-50 to-pink-50 rounded-2xl border border-purple-200">
                <div className="flex items-center gap-2 mb-2">
                  <Sparkles className="w-5 h-5 text-purple-600" />
                  <h3 className="font-semibold text-gray-900">Personalized for You</h3>
                </div>
                <p className="text-sm text-gray-700">
                  Products ranked by match with your {userProfile.skinType} skin
                  {userProfile.skinConcerns && userProfile.skinConcerns.length > 0 && 
                    ` and ${userProfile.skinConcerns.join(', ')} concerns`}
                </p>
              </div>
            )}
            <p className="text-sm text-gray-600 mb-4">
              {filteredProducts.length} product{filteredProducts.length !== 1 ? 's' : ''} found
            </p>
            <div className="space-y-3">
              {filteredProducts.map(product => (
                <button
                  key={product.id}
                  onClick={() => handleProductClick(product)}
                  className="w-full bg-white rounded-2xl p-4 text-left active:bg-gray-50 transition-colors"
                >
                  <div className="flex gap-4">
                    <div className="w-16 h-16 bg-gray-100 rounded-xl flex-shrink-0" />
                    <div className="flex-1 min-w-0">
                      <h3 className="font-semibold text-gray-900 mb-1">
                        {product.productName}
                      </h3>
                      <p className="text-sm text-gray-600 mb-2">
                        {product.brand}
                      </p>
                      <div className="flex flex-wrap gap-1">
                        {product.keyActives.slice(0, 3).map((active, idx) => (
                          <span
                            key={idx}
                            className="px-2 py-1 bg-blue-50 text-blue-600 text-xs font-medium rounded-full"
                          >
                            {active}
                          </span>
                        ))}
                      </div>
                    </div>
                    {product.priceRange && (
                      <div className="text-gray-600 font-medium">
                        {product.priceRange}
                      </div>
                    )}
                  </div>
                </button>
              ))}
            </div>
          </>
        )}
      </div>

      {/* Wishlist Sheet */}
      {showWishlistSheet && (
        <>
          <div
            className="fixed inset-0 bg-black/50 z-40"
            onClick={() => setShowWishlistSheet(false)}
          />
          <div className="fixed bottom-0 left-0 right-0 bg-white rounded-t-3xl z-50 max-h-[80vh] overflow-hidden animate-slide-up">
            <div className="px-6 pt-6 pb-8">
              {/* Handle */}
              <div className="w-12 h-1 bg-gray-300 rounded-full mx-auto mb-6" />
              
              {/* Header */}
              <div className="flex items-center justify-between mb-6">
                <h3 className="text-xl font-semibold text-gray-900">
                  My Wishlist
                </h3>
                <div className="flex items-center gap-2">
                  <div className="px-3 py-1 bg-pink-100 text-pink-700 rounded-full">
                    <span className="text-sm font-medium">{wishlistProducts.length} {wishlistProducts.length === 1 ? 'item' : 'items'}</span>
                  </div>
                </div>
              </div>

              {/* Content */}
              <div className="overflow-y-auto max-h-[60vh] -mx-6 px-6">
                {wishlistProducts.length === 0 ? (
                  <div className="text-center py-12">
                    <div className="w-20 h-20 bg-pink-100 rounded-full flex items-center justify-center mx-auto mb-4">
                      <Heart className="w-10 h-10 text-pink-500" />
                    </div>
                    <h3 className="text-lg font-semibold text-gray-900 mb-2">
                      Your wishlist is empty
                    </h3>
                    <p className="text-sm text-gray-600">
                      Add products to your wishlist by tapping the heart icon
                    </p>
                  </div>
                ) : (
                  <div className="space-y-3">
                    {wishlistProducts.map(product => (
                      <button
                        key={product.id}
                        onClick={() => {
                          setShowWishlistSheet(false);
                          handleProductClick(product);
                        }}
                        className="w-full bg-gray-50 rounded-2xl p-4 text-left active:bg-gray-100 transition-colors"
                      >
                        <div className="flex gap-4">
                          <div className="w-16 h-16 bg-gray-200 rounded-xl flex-shrink-0" />
                          <div className="flex-1 min-w-0">
                            <h3 className="font-semibold text-gray-900 mb-1 truncate">
                              {product.productName}
                            </h3>
                            <p className="text-sm text-gray-600 mb-2">
                              {product.brand}
                            </p>
                            <div className="flex flex-wrap gap-1">
                              {product.keyActives.slice(0, 2).map((active, idx) => (
                                <span
                                  key={idx}
                                  className="px-2 py-1 bg-cyan-50 text-cyan-600 text-xs font-medium rounded-full"
                                >
                                  {active}
                                </span>
                              ))}
                            </div>
                          </div>
                          <div className="flex flex-col items-end justify-between">
                            {product.priceRange && (
                              <div className="text-gray-600 font-medium text-sm">
                                {product.priceRange}
                              </div>
                            )}
                            <Heart className="w-5 h-5 text-pink-500 fill-pink-500" />
                          </div>
                        </div>
                      </button>
                    ))}
                  </div>
                )}
              </div>

              {/* Close Button */}
              <button
                onClick={() => setShowWishlistSheet(false)}
                className="mt-6 w-full text-gray-600 py-3 text-sm font-medium"
              >
                Close
              </button>
            </div>
          </div>
        </>
      )}

      {/* Recent Scans Sheet */}
      {showRecentScansSheet && (
        <>
          <div
            className="fixed inset-0 bg-black/50 z-40"
            onClick={() => setShowRecentScansSheet(false)}
          />
          <div className="fixed bottom-0 left-0 right-0 bg-white rounded-t-3xl z-50 max-h-[80vh] overflow-hidden animate-slide-up">
            <div className="px-6 pt-6 pb-8">
              {/* Handle */}
              <div className="w-12 h-1 bg-gray-300 rounded-full mx-auto mb-6" />
              
              {/* Header */}
              <div className="flex items-center justify-between mb-6">
                <h3 className="text-xl font-semibold text-gray-900">
                  Recent Scans
                </h3>
                <div className="flex items-center gap-2">
                  <div className="px-3 py-1 bg-cyan-100 text-cyan-700 rounded-full">
                    <span className="text-sm font-medium">{recentScansProducts.length} {recentScansProducts.length === 1 ? 'item' : 'items'}</span>
                  </div>
                </div>
              </div>

              {/* Content */}
              <div className="overflow-y-auto max-h-[60vh] -mx-6 px-6">
                {recentScansProducts.length === 0 ? (
                  <div className="text-center py-12">
                    <div className="w-20 h-20 bg-cyan-100 rounded-full flex items-center justify-center mx-auto mb-4">
                      <Scan className="w-10 h-10 text-cyan-500" />
                    </div>
                    <h3 className="text-lg font-semibold text-gray-900 mb-2">
                      No recent scans
                    </h3>
                    <p className="text-sm text-gray-600">
                      Scan products to see them here
                    </p>
                  </div>
                ) : (
                  <div className="space-y-3">
                    {recentScansProducts.map(product => (
                      <button
                        key={product.id}
                        onClick={() => {
                          setShowRecentScansSheet(false);
                          handleProductClick(product);
                        }}
                        className="w-full bg-gray-50 rounded-2xl p-4 text-left active:bg-gray-100 transition-colors"
                      >
                        <div className="flex gap-4">
                          <div className="w-16 h-16 bg-gray-200 rounded-xl flex-shrink-0" />
                          <div className="flex-1 min-w-0">
                            <h3 className="font-semibold text-gray-900 mb-1 truncate">
                              {product.productName}
                            </h3>
                            <p className="text-sm text-gray-600 mb-2">
                              {product.brand}
                            </p>
                            <div className="flex flex-wrap gap-1">
                              {product.keyActives.slice(0, 2).map((active, idx) => (
                                <span
                                  key={idx}
                                  className="px-2 py-1 bg-cyan-50 text-cyan-600 text-xs font-medium rounded-full"
                                >
                                  {active}
                                </span>
                              ))}
                            </div>
                          </div>
                          <div className="flex flex-col items-end justify-between">
                            {product.priceRange && (
                              <div className="text-gray-600 font-medium text-sm">
                                {product.priceRange}
                              </div>
                            )}
                            <Scan className="w-5 h-5 text-cyan-500 fill-cyan-500" />
                          </div>
                        </div>
                      </button>
                    ))}
                  </div>
                )}
              </div>

              {/* Close Button */}
              <button
                onClick={() => setShowRecentScansSheet(false)}
                className="mt-6 w-full text-gray-600 py-3 text-sm font-medium"
              >
                Close
              </button>
            </div>
          </div>
        </>
      )}
    </div>
  );
}