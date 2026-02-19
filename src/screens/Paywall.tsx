import { useState } from 'react';
import { useNavigate } from 'react-router';
import { X, Check, Sparkles, Zap, Search, Shield, Star, Crown } from 'lucide-react';
import { useApp } from '../context/AppContext';

const features = [
  {
    icon: Search,
    title: 'Personalized Product Search',
    description: 'AI-powered recommendations based on your unique skin profile',
  },
  {
    icon: Zap,
    title: 'Compatibility Checker',
    description: 'Analyze ingredient conflicts and build safe routines',
  },
  {
    icon: Shield,
    title: 'Safety Alerts',
    description: 'Get warnings about pregnancy-unsafe ingredients',
  },
  {
    icon: Sparkles,
    title: 'Unlimited Routine Saves',
    description: 'Create and manage multiple skincare routines',
  }
];

const plans = [
  {
    id: 'weekly',
    name: 'Weekly',
    price: '€5.99',
    period: '/week',
    pricePerDay: '€0.86/day',
    savings: null,
    popular: false,
    totalPrice: '€5.99'
  },
  {
    id: 'monthly',
    name: 'Monthly',
    price: '€19.99',
    period: '/month',
    pricePerDay: '€0.67/day',
    savings: 'Save 17%',
    popular: true,
    totalPrice: '€19.99'
  },
  {
    id: 'yearly',
    name: 'Yearly',
    price: '€149.99',
    period: '/year',
    pricePerDay: '€0.41/day',
    savings: 'Save 52%',
    popular: false,
    totalPrice: '€149.99'
  }
];

export function Paywall() {
  const navigate = useNavigate();
  const { userProfile, setUserProfile } = useApp();
  const [selectedPlan, setSelectedPlan] = useState('monthly');

  const handleSubscribe = () => {
    // Simulate premium upgrade
    setUserProfile({ ...userProfile, isPremium: true });
    navigate('/personalized-survey');
  };

  const currentPlan = plans.find(p => p.id === selectedPlan);

  return (
    <div className="min-h-screen bg-white">
      {/* Header */}
      <div className="sticky top-0 z-10 bg-white/80 backdrop-blur-md">
        <div className="h-12" /> {/* Status bar space */}
        <div className="px-6 py-4 flex items-center justify-between border-b border-gray-200">
          <button
            onClick={() => navigate(-1)}
            className="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center active:scale-95 transition-transform"
          >
            <X className="w-5 h-5 text-gray-600" />
          </button>
          <div className="flex-1" />
        </div>
      </div>

      <div className="px-6 pb-40">
        {/* Hero Section */}
        <div className="py-8 text-center">
          <div className="w-24 h-24 rounded-3xl bg-gradient-to-br from-purple-600 via-pink-600 to-rose-600 flex items-center justify-center mx-auto mb-6 shadow-2xl">
            <Crown className="w-12 h-12 text-white" strokeWidth={2} />
          </div>
          <h1 className="text-3xl font-bold text-gray-900 mb-3">
            Unlock Premium Features
          </h1>
          <p className="text-gray-600 leading-relaxed max-w-sm mx-auto text-base">
            Get personalized skincare recommendations and build safe routines with AI-powered analysis
          </p>
        </div>

        {/* Features Grid */}
        <div className="space-y-3 mb-8">
          {features.map((feature, index) => {
            const Icon = feature.icon;
            return (
              <div
                key={index}
                className="bg-gradient-to-br from-gray-50 to-white rounded-2xl p-4 border border-gray-100 shadow-sm"
              >
                <div className="flex items-start gap-4">
                  <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-cyan-500 to-teal-500 flex items-center justify-center flex-shrink-0 shadow-md">
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
          <h3 className="font-semibold text-gray-900 mb-4 text-center text-lg">
            Choose Your Plan
          </h3>
          <div className="space-y-3">
            {plans.map((plan) => (
              <button
                key={plan.id}
                onClick={() => setSelectedPlan(plan.id)}
                className={`w-full rounded-2xl p-5 transition-all relative border-2 ${
                  selectedPlan === plan.id
                    ? 'bg-gradient-to-br from-cyan-50 to-teal-50 border-cyan-500 shadow-lg scale-[1.02]'
                    : 'bg-white border-gray-200 shadow-sm'
                }`}
              >
                {plan.popular && (
                  <div className="absolute -top-3 left-1/2 -translate-x-1/2 px-4 py-1 bg-gradient-to-r from-amber-500 to-orange-500 rounded-full shadow-md">
                    <div className="flex items-center gap-1">
                      <Star className="w-3 h-3 text-white fill-white" />
                      <span className="text-xs font-bold text-white">Most Popular</span>
                    </div>
                  </div>
                )}
                
                <div className="flex items-center justify-between">
                  <div className="text-left flex-1">
                    <div className="flex items-baseline gap-2 mb-1">
                      <span className={`text-3xl font-bold ${
                        selectedPlan === plan.id ? 'text-cyan-600' : 'text-gray-900'
                      }`}>
                        {plan.price}
                      </span>
                      <span className="text-gray-500 text-sm font-medium">
                        {plan.period}
                      </span>
                    </div>
                    <div className="flex items-center gap-2 mb-1">
                      <span className={`text-base font-semibold ${
                        selectedPlan === plan.id ? 'text-gray-900' : 'text-gray-700'
                      }`}>
                        {plan.name}
                      </span>
                      {plan.savings && (
                        <span className={`text-xs font-bold px-2.5 py-1 rounded-full ${
                          selectedPlan === plan.id 
                            ? 'bg-cyan-500 text-white' 
                            : 'bg-cyan-100 text-cyan-700'
                        }`}>
                          {plan.savings}
                        </span>
                      )}
                    </div>
                    <span className="text-sm text-gray-500">
                      {plan.pricePerDay}
                    </span>
                  </div>
                  
                  <div className={`w-7 h-7 rounded-full border-2 flex items-center justify-center flex-shrink-0 ${
                    selectedPlan === plan.id
                      ? 'border-cyan-500 bg-cyan-500'
                      : 'border-gray-300 bg-white'
                  }`}>
                    {selectedPlan === plan.id && (
                      <Check className="w-4 h-4 text-white" strokeWidth={3} />
                    )}
                  </div>
                </div>
              </button>
            ))}
          </div>
        </div>

        {/* Trust Indicators */}
        <div className="space-y-3 mb-6">
          <div className="bg-blue-50 rounded-2xl p-4 border border-blue-100">
            <div className="flex items-start gap-3">
              <div className="w-8 h-8 rounded-full bg-blue-500 flex items-center justify-center flex-shrink-0">
                <Shield className="w-4 h-4 text-white" strokeWidth={2.5} />
              </div>
              <div>
                <p className="text-sm font-semibold text-gray-900 mb-1">
                  7-Day Free Trial
                </p>
                <p className="text-xs text-gray-600 leading-relaxed">
                  Try all premium features risk-free. Cancel anytime before trial ends.
                </p>
              </div>
            </div>
          </div>

          <div className="bg-purple-50 rounded-2xl p-4 border border-purple-100">
            <div className="flex items-start gap-3">
              <div className="w-8 h-8 rounded-full bg-purple-500 flex items-center justify-center flex-shrink-0">
                <Sparkles className="w-4 h-4 text-white" strokeWidth={2.5} />
              </div>
              <div>
                <p className="text-sm font-semibold text-gray-900 mb-1">
                  Cancel Anytime
                </p>
                <p className="text-xs text-gray-600 leading-relaxed">
                  No commitments. Manage your subscription from your profile settings.
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Terms */}
        <p className="text-center text-xs text-gray-500 leading-relaxed mb-4">
          By subscribing, you agree to our Terms of Service and Privacy Policy. 
          Your subscription will automatically renew unless cancelled.
        </p>
      </div>

      {/* Fixed Bottom CTA */}
      <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 px-6 py-4 safe-area-bottom shadow-lg">
        <button
          onClick={handleSubscribe}
          className="w-full bg-gradient-to-r from-cyan-600 via-cyan-500 to-teal-500 text-white font-bold py-4 rounded-2xl active:scale-[0.98] transition-transform shadow-lg flex items-center justify-center gap-2 mb-2"
        >
          <Crown className="w-5 h-5" />
          <span>Start 7-Day Free Trial</span>
        </button>
        <p className="text-center text-sm text-gray-600">
          Then {currentPlan?.totalPrice}{currentPlan?.period}
        </p>
      </div>
    </div>
  );
}