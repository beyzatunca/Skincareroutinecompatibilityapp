import { useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router';
import { ChevronLeft, ChevronRight, Check, CheckCircle2 } from 'lucide-react';
import { useApp } from '../context/AppContext';

const skinTypes = ['Dry', 'Oily', 'Combination', 'Normal', 'Sensitive'];
const ageRanges = ['Under 18', '18-24', '25-30', '31-40', '40+'];
const concerns = ['Acne', 'Aging', 'Hyperpigmentation', 'Dryness', 'Texture', 'Redness', 'Large pores'];
const commonIngredients = ['Fragrance', 'Essential oils', 'Alcohol', 'Sulfates', 'Parabens'];

export function PersonalizedSurvey() {
  const navigate = useNavigate();
  const { userProfile, setUserProfile } = useApp();
  const [searchParams] = useSearchParams();
  const fromHome = searchParams.get('fromHome') === 'true';
  
  const [step, setStep] = useState(1);
  const [formData, setFormData] = useState({
    ageRange: '',
    skinType: '',
    skinConcerns: [] as string[],
    hasSensitivity: false,
    avoidIngredients: [] as string[],
    isPregnant: false
  });

  const toggleConcern = (concern: string) => {
    setFormData(prev => ({
      ...prev,
      skinConcerns: prev.skinConcerns.includes(concern)
        ? prev.skinConcerns.filter(c => c !== concern)
        : [...prev.skinConcerns, concern]
    }));
  };

  const toggleIngredient = (ingredient: string) => {
    setFormData(prev => ({
      ...prev,
      avoidIngredients: prev.avoidIngredients.includes(ingredient)
        ? prev.avoidIngredients.filter(i => i !== ingredient)
        : [...prev.avoidIngredients, ingredient]
    }));
  };

  const handleContinue = () => {
    if (step < 3) {
      setStep(step + 1);
    } else {
      // Save profile
      setUserProfile({
        ...userProfile,
        ...formData,
        setupCompleted: true
      });

      // Navigate to personalized search
      if (fromHome) {
        navigate('/products?personalized=true&fromHome=true');
      } else {
        navigate('/products?personalized=true');
      }
    }
  };

  const canContinue = () => {
    if (step === 1) return formData.ageRange && formData.skinType;
    if (step === 2) return formData.skinConcerns.length > 0;
    return true; // Step 3 is optional
  };

  return (
    <div className="min-h-screen bg-white flex flex-col">
      {/* Header */}
      <div className="px-6 pt-16 pb-6 border-b border-gray-200">
        <button onClick={() => navigate(-1)} className="mb-6">
          <ChevronLeft className="w-6 h-6 text-gray-900" />
        </button>
        <div className="flex gap-2 mb-4">
          {[1, 2, 3].map(i => (
            <div
              key={i}
              className={`h-1 flex-1 rounded-full transition-all ${
                i <= step ? 'bg-gradient-to-r from-[#C8E6E0] via-[#D8F0EC] to-[#F0F9F7]' : 'bg-gray-200'
              }`}
            />
          ))}
        </div>
        <h1 className="text-2xl font-semibold text-gray-900 mb-2">
          {step === 1 && 'Tell us about yourself'}
          {step === 2 && 'What are your concerns?'}
          {step === 3 && 'Anything to avoid?'}
        </h1>
        <div className="space-y-1.5">
          {step === 1 && (
            <>
              <div className="flex items-start gap-2">
                <CheckCircle2 className="w-4 h-4 text-cyan-500 flex-shrink-0 mt-0.5" />
                <span className="text-sm text-gray-600">Share your age range</span>
              </div>
              <div className="flex items-start gap-2">
                <CheckCircle2 className="w-4 h-4 text-cyan-500 flex-shrink-0 mt-0.5" />
                <span className="text-sm text-gray-600">Tell us your skin type</span>
              </div>
              <div className="flex items-start gap-2">
                <CheckCircle2 className="w-4 h-4 text-cyan-500 flex-shrink-0 mt-0.5" />
                <span className="text-sm text-gray-600">Help us personalize for you</span>
              </div>
            </>
          )}
          {step === 2 && (
            <>
              <div className="flex items-start gap-2">
                <CheckCircle2 className="w-4 h-4 text-cyan-500 flex-shrink-0 mt-0.5" />
                <span className="text-sm text-gray-600">Select all skin concerns</span>
              </div>
              <div className="flex items-start gap-2">
                <CheckCircle2 className="w-4 h-4 text-cyan-500 flex-shrink-0 mt-0.5" />
                <span className="text-sm text-gray-600">Mark if you have sensitivity</span>
              </div>
              <div className="flex items-start gap-2">
                <CheckCircle2 className="w-4 h-4 text-cyan-500 flex-shrink-0 mt-0.5" />
                <span className="text-sm text-gray-600">We'll find matching products</span>
              </div>
            </>
          )}
          {step === 3 && (
            <>
              <div className="flex items-start gap-2">
                <CheckCircle2 className="w-4 h-4 text-cyan-500 flex-shrink-0 mt-0.5" />
                <span className="text-sm text-gray-600">Choose ingredients to avoid</span>
              </div>
              <div className="flex items-start gap-2">
                <CheckCircle2 className="w-4 h-4 text-cyan-500 flex-shrink-0 mt-0.5" />
                <span className="text-sm text-gray-600">Flag pregnancy if applicable</span>
              </div>
              <div className="flex items-start gap-2">
                <CheckCircle2 className="w-4 h-4 text-cyan-500 flex-shrink-0 mt-0.5" />
                <span className="text-sm text-gray-600">These settings are optional</span>
              </div>
            </>
          )}
        </div>
      </div>

      {/* Content */}
      <div className="flex-1 px-6 py-8 overflow-y-auto">
        {step === 1 && (
          <div className="space-y-6">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-3">
                Age Range
              </label>
              <div className="grid grid-cols-2 gap-3">
                {ageRanges.map(range => (
                  <button
                    key={range}
                    onClick={() => setFormData({ ...formData, ageRange: range })}
                    className={`py-3 px-4 rounded-xl border-2 text-sm font-medium transition-all ${
                      formData.ageRange === range
                        ? 'border-transparent bg-gradient-to-br from-[#C8E6E0] via-[#D8F0EC] to-[#F0F9F7] text-gray-900'
                        : 'border-gray-200 bg-white text-gray-700'
                    }`}
                  >
                    {range}
                  </button>
                ))}
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-3">
                Skin Type
              </label>
              <div className="grid grid-cols-2 gap-3">
                {skinTypes.map(type => (
                  <button
                    key={type}
                    onClick={() => setFormData({ ...formData, skinType: type })}
                    className={`py-3 px-4 rounded-xl border-2 text-sm font-medium transition-all ${
                      formData.skinType === type
                        ? 'border-transparent bg-gradient-to-br from-[#C8E6E0] via-[#D8F0EC] to-[#F0F9F7] text-gray-900'
                        : 'border-gray-200 bg-white text-gray-700'
                    }`}
                  >
                    {type}
                  </button>
                ))}
              </div>
            </div>
          </div>
        )}

        {step === 2 && (
          <div className="space-y-6">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-3">
                Select all that apply
              </label>
              <div className="grid grid-cols-2 gap-3">
                {concerns.map(concern => (
                  <button
                    key={concern}
                    onClick={() => toggleConcern(concern)}
                    className={`py-3 px-4 rounded-xl border-2 text-sm font-medium transition-all ${
                      formData.skinConcerns.includes(concern)
                        ? 'border-transparent bg-gradient-to-br from-[#C8E6E0] via-[#D8F0EC] to-[#F0F9F7] text-gray-900'
                        : 'border-gray-200 bg-white text-gray-700'
                    }`}
                  >
                    {concern}
                  </button>
                ))}
              </div>
            </div>

            <div className="bg-gray-50 rounded-xl p-4">
              <label className="flex items-center gap-3">
                <input
                  type="checkbox"
                  checked={formData.hasSensitivity}
                  onChange={(e) => setFormData({ ...formData, hasSensitivity: e.target.checked })}
                  className="w-5 h-5 rounded border-gray-300 text-cyan-500 focus:ring-cyan-500"
                />
                <span className="text-sm text-gray-700">
                  I have sensitive skin prone to irritation
                </span>
              </label>
            </div>
          </div>
        )}

        {step === 3 && (
          <div className="space-y-6">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-3">
                Ingredients to avoid (optional)
              </label>
              <div className="grid grid-cols-2 gap-3">
                {commonIngredients.map(ingredient => (
                  <button
                    key={ingredient}
                    onClick={() => toggleIngredient(ingredient)}
                    className={`py-3 px-4 rounded-xl border-2 text-sm font-medium transition-all ${
                      formData.avoidIngredients.includes(ingredient)
                        ? 'border-transparent bg-gradient-to-br from-[#C8E6E0] via-[#D8F0EC] to-[#F0F9F7] text-gray-900'
                        : 'border-gray-200 bg-white text-gray-700'
                    }`}
                  >
                    {ingredient}
                  </button>
                ))}
              </div>
            </div>

            <div className="bg-pink-50 rounded-xl p-4">
              <label className="flex items-center gap-3">
                <input
                  type="checkbox"
                  checked={formData.isPregnant}
                  onChange={(e) => setFormData({ ...formData, isPregnant: e.target.checked })}
                  className="w-5 h-5 rounded border-gray-300 text-pink-500 focus:ring-pink-500"
                />
                <span className="text-sm text-gray-700">
                  I'm pregnant or planning to be
                </span>
              </label>
              <p className="text-xs text-gray-600 mt-2 ml-8">
                We'll flag products not recommended during pregnancy
              </p>
            </div>
          </div>
        )}
      </div>

      {/* Footer */}
      <div className="fixed bottom-0 left-0 right-0 bg-white px-6 pb-12 pt-4 border-t border-gray-200 shadow-lg">
        <button
          onClick={handleContinue}
          disabled={!canContinue()}
          className="w-full bg-gradient-to-br from-[#C8E6E0] via-[#D8F0EC] to-[#F0F9F7] text-gray-900 rounded-2xl py-4 font-bold text-base flex items-center justify-center gap-2 disabled:opacity-40 disabled:cursor-not-allowed active:scale-[0.98] transition-all shadow-lg"
        >
          {step === 3 ? 'Start Personalized Search' : 'Continue'}
          <ChevronRight className="w-5 h-5" />
        </button>
      </div>
    </div>
  );
}