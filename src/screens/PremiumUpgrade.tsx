import { useState } from 'react';
import { useNavigate } from 'react-router';
import { X, Check, Sparkles, Zap, Search, Shield, Star } from 'lucide-react';
import { useApp } from '../context/AppContext';

const features = [
  {
    icon: Search,
    title: 'Personalized Product Search',
    description: 'AI-powered recommendations based on your skin type and concerns',
    color: 'from-pink-500 to-rose-500'
  },
  {
    icon: Zap,
    title: 'Compatibility Checker',
    description: 'Build safe routines with real-time ingredient conflict analysis',
    color: 'from-cyan-500 to-teal-500'
  },
  {
    icon: Shield,
    title: 'Advanced Safety Alerts',
    description: 'Get personalized warnings about pregnancy-unsafe ingredients',
    color: 'from-purple-500 to-indigo-500'
  },
  {
    icon: Sparkles,
    title: 'Unlimited Routine Saves',
    description: 'Save and manage multiple skincare routines',
    color: 'from-amber-500 to-orange-500'
  }
];

const plans = [
  {
    id: 'weekly',
    name: 'Weekly',
    price: '€5.99',
    period: '/week',
    savings: null,
    popular: false
  },
  {
    id: 'monthly',
    name: 'Monthly',
    price: '€19.99',
    period: '/month',
    savings: 'Save 17%',
    popular: true
  },
  {
    id: 'yearly',
    name: 'Yearly',
    price: '€149.99',
    period: '/year',
    savings: 'Save 52%',
    popular: false
  }
];

export function PremiumUpgrade() {
  const navigate = useNavigate();
  const { userProfile, setUserProfile } = useApp();
  const [selectedPlan, setSelectedPlan] = useState('monthly');

  const handleUpgrade = () => {
    // Simulate premium upgrade (in real app, this would process payment)
    setUserProfile({ ...userProfile, isPremium: true });
    navigate('/');
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-purple-50 via-pink-50 to-white">
      {/* Header */}
      <div className="sticky top-0 z-10 bg-white/80 backdrop-blur-md border-b border-gray-200">
        <div className="h-12" /> {/* Status bar space */}
        <div className="px-6 py-4 flex items-center justify-between">
          <button
            onClick={() => navigate(-1)}
            className="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center active:scale-95 transition-transform"
          >
            <X className="w-5 h-5 text-gray-600" />
          </button>
          <h1 className="font-semibold text-gray-900">Premium</h1>
          <div className="w-10" /> {/* Spacer */}
        </div>
      </div>

      <div className="px-6 pb-32">
        {/* Hero Section */}
        <div className="py-8 text-center">
          <div className="w-20 h-20 rounded-3xl bg-gradient-to-br from-purple-600 via-pink-600 to-rose-600 flex items-center justify-center mx-auto mb-6 shadow-xl">
            <Star className="w-10 h-10 text-white fill-white" />
          </div>
          <h2 className="text-3xl font-bold text-gray-900 mb-3">
            Upgrade to Premium
          </h2>
          <p className="text-gray-600 leading-relaxed max-w-sm mx-auto">
            Unlock advanced features and get personalized skincare recommendations powered by AI
          </p>
        </div>

        {/* Features List */}
        <div className="space-y-4 mb-8">
          {features.map((feature, index) => {
            const Icon = feature.icon;
            return (
              <div
                key={index}
                className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100"
              >
                <div className="flex items-start gap-4">
                  <div className={`w-12 h-12 rounded-xl bg-gradient-to-br ${feature.color} flex items-center justify-center flex-shrink-0 shadow-md`}>
                    <Icon className="w-6 h-6 text-white" strokeWidth={2} />
                  </div>
                  <div className="flex-1">
                    <h3 className="font-semibold text-gray-900 mb-1">
                      {feature.title}
                    </h3>
                    <p className="text-sm text-gray-600 leading-relaxed">
                      {feature.description}
                    </p>
                  </div>
                  <div className="flex-shrink-0">
                    <div className="w-6 h-6 rounded-full bg-cyan-500 flex items-center justify-center">
                      <Check className="w-4 h-4 text-white" strokeWidth={3} />
                    </div>
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        {/* Pricing Plans */}
        <div className="mb-6">
          <h3 className="font-semibold text-gray-900 mb-4 text-center">
            Choose Your Plan
          </h3>
          <div className="space-y-3">
            {plans.map((plan) => (
              <button
                key={plan.id}
                onClick={() => setSelectedPlan(plan.id)}
                className={`w-full rounded-2xl p-4 transition-all relative ${
                  selectedPlan === plan.id
                    ? 'bg-gradient-to-br from-purple-600 via-pink-600 to-rose-600 shadow-lg scale-[1.02]'
                    : 'bg-white border-2 border-gray-200'
                }`}
              >
                {plan.popular && (
                  <div className="absolute -top-2 left-1/2 -translate-x-1/2 px-3 py-1 bg-amber-500 rounded-full">
                    <span className="text-xs font-bold text-white">Most Popular</span>
                  </div>
                )}
                
                <div className="flex items-center justify-between">
                  <div className="text-left">
                    <div className="flex items-baseline gap-2 mb-1">
                      <span className={`text-2xl font-bold ${
                        selectedPlan === plan.id ? 'text-white' : 'text-gray-900'
                      }`}>
                        {plan.price}
                      </span>
                      <span className={`text-sm ${
                        selectedPlan === plan.id ? 'text-white/80' : 'text-gray-500'
                      }`}>
                        {plan.period}
                      </span>
                    </div>
                    <div className="flex items-center gap-2">
                      <span className={`text-sm font-medium ${
                        selectedPlan === plan.id ? 'text-white' : 'text-gray-700'
                      }`}>
                        {plan.name}
                      </span>
                      {plan.savings && (
                        <span className={`text-xs font-semibold px-2 py-0.5 rounded-full ${
                          selectedPlan === plan.id 
                            ? 'bg-white/20 text-white' 
                            : 'bg-cyan-100 text-cyan-700'
                        }`}>
                          {plan.savings}
                        </span>
                      )}
                    </div>
                  </div>
                  
                  <div className={`w-6 h-6 rounded-full border-2 flex items-center justify-center ${
                    selectedPlan === plan.id
                      ? 'border-white bg-white'
                      : 'border-gray-300'
                  }`}>
                    {selectedPlan === plan.id && (
                      <div className="w-3 h-3 rounded-full bg-gradient-to-br from-purple-600 to-pink-600" />
                    )}
                  </div>
                </div>
              </button>
            ))}
          </div>
        </div>

        {/* Trust Indicators */}
        <div className="bg-cyan-50 rounded-2xl p-4 mb-6 border border-cyan-100">
          <div className="flex items-start gap-3">
            <div className="w-8 h-8 rounded-full bg-cyan-500 flex items-center justify-center flex-shrink-0">
              <Shield className="w-4 h-4 text-white" strokeWidth={2.5} />
            </div>
            <div>
              <p className="text-sm font-medium text-gray-900 mb-1">
                7-Day Free Trial
              </p>
              <p className="text-xs text-gray-600 leading-relaxed">
                Cancel anytime before trial ends. No charges applied until trial period is over.
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Fixed Bottom CTA */}
      <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 px-6 py-4 safe-area-bottom">
        <button
          onClick={handleUpgrade}
          className="w-full bg-gradient-to-r from-purple-600 via-pink-600 to-rose-600 text-white font-semibold py-4 rounded-2xl active:scale-[0.98] transition-transform shadow-lg flex items-center justify-center gap-2"
        >
          <Sparkles className="w-5 h-5" />
          <span>Start Free Trial</span>
        </button>
        <p className="text-center text-xs text-gray-500 mt-3">
          Then {plans.find(p => p.id === selectedPlan)?.price}{plans.find(p => p.id === selectedPlan)?.period}
        </p>
      </div>
    </div>
  );
}