export interface Product {
  id: string;
  productName: string;
  brand: string;
  category: string;
  keyActives: string[];
  sensitivityWarnings: string[];
  pregnancyFlag: boolean;
  imageUrl?: string;
  description?: string;
  priceRange?: string;
  positiveEffects?: { effect: string; description: string }[];
  negativeEffects?: { effect: string; activeIngredient: string }[];
  ingredientsList?: string[];
}

export interface RoutineItem {
  id: string;
  product: Product;
  timeOfDay: 'AM' | 'PM' | 'Both';
  frequency: 'daily' | '2-3x week' | 'alternate days';
}

export interface UserProfile {
  ageRange?: string;
  skinType?: string;
  skinConcerns?: string[];
  hasSensitivity?: boolean;
  avoidIngredients?: string[];
  isPregnant?: boolean;
  setupCompleted?: boolean;
  isPremium?: boolean;
  sensitivityLevel?: string;
  preferences?: string[];
  mustHaves?: string[];
}

export interface Conflict {
  id: string;
  severity: 'High' | 'Medium' | 'Low';
  title: string;
  description: string;
  products: Product[];
  details: string;
  suggestion: string;
}

export interface CompatibilityResult {
  riskLevel: 'Low' | 'Medium' | 'High';
  summary: string;
  conflictCount: number;
  tags: string[];
  conflicts: Conflict[];
  overlappingActives: {
    active: string;
    count: number;
    products: Product[];
    suggestion: string;
  }[];
  personalizedWarnings: string[];
  recommendations: {
    id: string;
    title: string;
    reason: string;
  }[];
  suggestedSchedule: {
    AM: RoutineItem[];
    PM: {
      [key: string]: RoutineItem[];
    };
  };
}