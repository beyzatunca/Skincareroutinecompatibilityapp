import { Product } from '../types';

export const sampleProducts: Product[] = [
  {
    id: '1',
    productName: 'Glycolic Acid 7% Toning Solution',
    brand: 'The Ordinary',
    category: 'Toner',
    keyActives: ['AHA', 'Glycolic Acid'],
    sensitivityWarnings: ['May cause tingling', 'Use sunscreen'],
    pregnancyFlag: false,
    description: 'Exfoliating toner that targets texture and dullness',
    priceRange: '$',
    positiveEffects: [
      { effect: 'Exfoliating', description: 'Removes dead skin cells for smoother texture' },
      { effect: 'Brightening', description: 'Improves skin radiance and tone' },
      { effect: 'Anti-Aging', description: 'Reduces fine lines and wrinkles' }
    ],
    negativeEffects: [
      { effect: 'Skin Irritation', activeIngredient: 'Glycolic Acid (AHA)' },
      { effect: 'Sun Sensitivity', activeIngredient: 'Glycolic Acid' }
    ],
    ingredientsList: ['Aqua', 'Glycolic Acid', 'Rosa damascena flower water', 'Centaurea cyanus flower water', 'Aloe Barbadensis Leaf Water', 'Propanediol', 'Glycerin', 'Triethanolamine', 'Aminomethyl Propanol', 'Panax Ginseng Root Extract', 'Tasmannia Lanceolata Fruit/Leaf Extract', 'Aspartic Acid', 'Alanine', 'Glycine', 'Serine', 'Valine', 'Isoleucine', 'Proline', 'Threonine', 'Histidine', 'Phenylalanine', 'Glutamic Acid', 'Arginine', 'PCA', 'Sodium PCA', 'Sodium Lactate', 'Fructose', 'Glucose', 'Sucrose', 'Urea', 'Hexyl Nicotinate', 'Dextrin', 'Citric Acid', 'Polysorbate 20', 'Gellan Gum', 'Trisodium Ethylenediamine Disuccinate', 'Sodium Chloride', 'Hexylene Glycol', 'Potassium Sorbate', 'Sodium Benzoate', 'Ethylhexylglycerin', 'Phenoxyethanol', 'Caprylyl Glycol']
  },
  {
    id: '2',
    productName: 'Adapalene Gel 0.1%',
    brand: 'Differin',
    category: 'Treatment',
    keyActives: ['Retinoid', 'Adapalene'],
    sensitivityWarnings: ['May cause dryness', 'Avoid sun exposure', 'Start slow'],
    pregnancyFlag: true,
    description: 'Prescription-strength retinoid for acne and texture',
    priceRange: '$$',
    positiveEffects: [
      { effect: 'Anti-Acne', description: 'Treats and prevents breakouts' },
      { effect: 'Pore Clearing', description: 'Unclogs pores and reduces blackheads' },
      { effect: 'Texture Improvement', description: 'Smooths skin surface over time' }
    ],
    negativeEffects: [
      { effect: 'Dryness & Peeling', activeIngredient: 'Adapalene (Retinoid)' },
      { effect: 'Redness', activeIngredient: 'Adapalene' },
      { effect: 'Not Safe During Pregnancy', activeIngredient: 'Adapalene (Retinoid)' }
    ],
    ingredientsList: ['Adapalene', 'Carbomer 940', 'Edetate Disodium', 'Methylparaben', 'Poloxamer 182', 'Propylene Glycol', 'Purified Water', 'Sodium Hydroxide']
  },
  {
    id: '3',
    productName: 'Cicaplast Baume B5',
    brand: 'La Roche-Posay',
    category: 'Moisturizer',
    keyActives: ['Panthenol', 'Madecassoside'],
    sensitivityWarnings: [],
    pregnancyFlag: false,
    description: 'Soothing balm for barrier repair',
    priceRange: '$$',
    positiveEffects: [
      { effect: 'Soothing', description: 'Calms irritated and sensitive skin' },
      { effect: 'Barrier Repair', description: 'Strengthens skin protective barrier' },
      { effect: 'Moisturizing', description: 'Provides deep hydration' }
    ],
    negativeEffects: [],
    ingredientsList: ['Aqua/Water', 'Panthenol', 'Glycerin', 'Butyrospermum Parkii Butter/Shea Butter', 'Madecassoside', 'Copper Sulfate', 'Zinc Sulfate', 'Manganese Sulfate']
  },
  {
    id: '4',
    productName: 'Vitamin C Suspension 23% + HA Spheres 2%',
    brand: 'The Ordinary',
    category: 'Serum',
    keyActives: ['Vitamin C', 'L-Ascorbic Acid'],
    sensitivityWarnings: ['May tingle', 'Store in cool place'],
    pregnancyFlag: false,
    description: 'High-potency vitamin C for brightening',
    priceRange: '$',
    positiveEffects: [
      { effect: 'Brightening', description: 'Reduces dark spots and hyperpigmentation' },
      { effect: 'Antioxidant Protection', description: 'Protects against environmental damage' },
      { effect: 'Collagen Boost', description: 'Supports skin firmness and elasticity' }
    ],
    negativeEffects: [
      { effect: 'Tingling Sensation', activeIngredient: 'L-Ascorbic Acid (Vitamin C)' },
      { effect: 'Oxidation Risk', activeIngredient: 'Vitamin C' }
    ],
    ingredientsList: ['L-Ascorbic Acid', 'Hyaluronic Acid', 'Propanediol', 'Isodecyl Neopentanoate', 'Dimethicone', 'Sodium Hyaluronate Crosspolymer', 'Lecithin', 'Glucomannan', 'Tocopherol']
  },
  {
    id: '5',
    productName: 'Benzoyl Peroxide 2.5% Gel',
    brand: 'Neutrogena',
    category: 'Treatment',
    keyActives: ['Benzoyl Peroxide'],
    sensitivityWarnings: ['May bleach fabrics', 'Can cause dryness'],
    pregnancyFlag: false,
    description: 'Acne treatment that kills bacteria',
    priceRange: '$',
    positiveEffects: [
      { effect: 'Antibacterial', description: 'Kills acne-causing bacteria effectively' },
      { effect: 'Anti-Acne', description: 'Treats and prevents breakouts' },
      { effect: 'Fast Acting', description: 'Shows results within days' }
    ],
    negativeEffects: [
      { effect: 'Dryness', activeIngredient: 'Benzoyl Peroxide' },
      { effect: 'Fabric Bleaching', activeIngredient: 'Benzoyl Peroxide' }
    ],
    ingredientsList: ['Benzoyl Peroxide', 'Carbomer Homopolymer Type B', 'Sodium Hydroxide', 'Laureth-4', 'Purified Water']
  },
  {
    id: '6',
    productName: 'Niacinamide 10% + Zinc 1%',
    brand: 'The Ordinary',
    category: 'Serum',
    keyActives: ['Niacinamide', 'Zinc'],
    sensitivityWarnings: [],
    pregnancyFlag: false,
    description: 'Reduces blemishes and congestion',
    priceRange: '$',
    positiveEffects: [
      { effect: 'Pore Minimizing', description: 'Reduces appearance of enlarged pores' },
      { effect: 'Sebum Control', description: 'Balances oil production' },
      { effect: 'Blemish Reduction', description: 'Fades acne marks and redness' }
    ],
    negativeEffects: [],
    ingredientsList: ['Aqua', 'Niacinamide', 'Pentylene Glycol', 'Zinc PCA', 'Tamarindus Indica Seed Gum', 'Xanthan Gum', 'Isoceteth-20', 'Ethoxydiglycol', 'Phenoxyethanol', 'Chlorphenesin']
  },
  {
    id: '7',
    productName: 'Salicylic Acid 2% Solution',
    brand: 'The Ordinary',
    category: 'Treatment',
    keyActives: ['BHA', 'Salicylic Acid'],
    sensitivityWarnings: ['Use sunscreen'],
    pregnancyFlag: false,
    description: 'Exfoliating treatment for pores',
    priceRange: '$',
    positiveEffects: [
      { effect: 'Deep Pore Cleansing', description: 'Unclogs pores from inside out' },
      { effect: 'Blackhead Removal', description: 'Dissolves sebum and debris' },
      { effect: 'Anti-Inflammatory', description: 'Reduces redness and swelling' }
    ],
    negativeEffects: [
      { effect: 'Dryness', activeIngredient: 'Salicylic Acid (BHA)' },
      { effect: 'Sun Sensitivity', activeIngredient: 'Salicylic Acid' }
    ],
    ingredientsList: ['Aqua', 'Salicylic Acid', 'Witch Hazel Water', 'Polysorbate 20', 'Sodium Hydroxide', 'Sodium Hyaluronate Crosspolymer', 'Polyacrylate Crosspolymer-6']
  },
  {
    id: '8',
    productName: 'Hydrating Cleanser',
    brand: 'CeraVe',
    category: 'Cleanser',
    keyActives: ['Ceramides', 'Hyaluronic Acid'],
    sensitivityWarnings: [],
    pregnancyFlag: false,
    description: 'Gentle cleanser that maintains moisture',
    priceRange: '$',
    positiveEffects: [
      { effect: 'Gentle Cleansing', description: 'Removes dirt without stripping skin' },
      { effect: 'Barrier Support', description: 'Strengthens skin protective barrier' },
      { effect: 'Hydrating', description: 'Maintains skin moisture during cleansing' }
    ],
    negativeEffects: [],
    ingredientsList: ['Aqua/Water', 'Glycerin', 'Cetearyl Alcohol', 'Ceramide NP', 'Ceramide AP', 'Ceramide EOP', 'Hyaluronic Acid', 'Cholesterol', 'Phenoxyethanol', 'Behentrimonium Methosulfate']
  },
  {
    id: '9',
    productName: 'Anthelios Melt-in Milk SPF 60',
    brand: 'La Roche-Posay',
    category: 'SPF',
    keyActives: ['Avobenzone', 'Chemical UV filters'],
    sensitivityWarnings: [],
    pregnancyFlag: false,
    description: 'Lightweight sunscreen for daily protection',
    priceRange: '$$',
    positiveEffects: [
      { effect: 'UV Protection', description: 'Broad spectrum SPF 60 coverage' },
      { effect: 'Lightweight', description: 'Non-greasy, fast-absorbing formula' },
      { effect: 'Anti-Aging Prevention', description: 'Prevents sun damage and premature aging' }
    ],
    negativeEffects: [],
    ingredientsList: ['Avobenzone', 'Homosalate', 'Octisalate', 'Octocrylene', 'Oxybenzone', 'Water', 'Glycerin', 'Dimethicone', 'Phenoxyethanol', 'Tocopherol']
  },
  {
    id: '10',
    productName: 'AHA 30% + BHA 2% Peeling Solution',
    brand: 'The Ordinary',
    category: 'Treatment',
    keyActives: ['AHA', 'BHA', 'Glycolic Acid', 'Salicylic Acid'],
    sensitivityWarnings: ['Use max 2x per week', 'Do not combine with other actives', 'Patch test required'],
    pregnancyFlag: true,
    description: '10-minute exfoliating facial',
    priceRange: '$',
    positiveEffects: [
      { effect: 'Deep Exfoliation', description: 'Removes dead skin cells for radiant skin' },
      { effect: 'Texture Refinement', description: 'Smooths rough, uneven skin' },
      { effect: 'Brightening', description: 'Improves skin clarity and tone' }
    ],
    negativeEffects: [
      { effect: 'Strong Tingling', activeIngredient: 'AHA 30% + BHA 2%' },
      { effect: 'Redness & Sensitivity', activeIngredient: 'Glycolic Acid, Salicylic Acid' },
      { effect: 'Not Safe During Pregnancy', activeIngredient: 'High concentration acids' }
    ],
    ingredientsList: ['Aqua', 'Glycolic Acid', 'Aloe Barbadensis Leaf Water', 'Salicylic Acid', 'Propanediol', 'Cocamidopropyl Dimethylamine', 'Sodium Hydroxide', 'Daucus Carota Sativa Extract', 'Polysorbate 20']
  },
  {
    id: '11',
    productName: 'Retinol 0.5% in Squalane',
    brand: 'The Ordinary',
    category: 'Serum',
    keyActives: ['Retinol', 'Squalane'],
    sensitivityWarnings: ['Start slow', 'Use sunscreen', 'May cause purging'],
    pregnancyFlag: true,
    description: 'Moderate-strength retinol for anti-aging',
    priceRange: '$',
    positiveEffects: [
      { effect: 'Anti-Aging', description: 'Reduces fine lines and wrinkles' },
      { effect: 'Skin Renewal', description: 'Accelerates cell turnover' },
      { effect: 'Texture Improvement', description: 'Smooths and refines skin surface' }
    ],
    negativeEffects: [
      { effect: 'Dryness & Peeling', activeIngredient: 'Retinol' },
      { effect: 'Purging Period', activeIngredient: 'Retinol' },
      { effect: 'Not Safe During Pregnancy', activeIngredient: 'Retinol (Retinoid)' }
    ],
    ingredientsList: ['Squalane', 'Retinol', 'Caprylic/Capric Triglyceride', 'Solanum Lycopersicum Fruit Extract', 'Simmondsia Chinensis Seed Oil', 'BHT', 'Tocopherol']
  },
  {
    id: '12',
    productName: 'Hyaluronic Acid 2% + B5',
    brand: 'The Ordinary',
    category: 'Serum',
    keyActives: ['Hyaluronic Acid', 'Panthenol'],
    sensitivityWarnings: [],
    pregnancyFlag: false,
    description: 'Hydrating serum for all skin types',
    priceRange: '$',
    positiveEffects: [
      { effect: 'Deep Hydration', description: 'Holds up to 1000x its weight in water' },
      { effect: 'Plumping', description: 'Visibly plumps and smooths skin' },
      { effect: 'Soothing', description: 'Calms and comforts irritated skin' }
    ],
    negativeEffects: [],
    ingredientsList: ['Aqua', 'Sodium Hyaluronate', 'Panthenol', 'Sodium Hyaluronate Crosspolymer', 'Pentylene Glycol', 'Polyacrylate Crosspolymer-6', 'Trisodium Ethylenediamine Disuccinate', 'Citric Acid', 'Isoceteth-20', 'Ethoxydiglycol', 'Phenoxyethanol', 'Chlorphenesin']
  }
];