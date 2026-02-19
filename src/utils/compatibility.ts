import { RoutineItem, CompatibilityResult, Conflict, UserProfile } from '../types';

export function analyzeRoutineCompatibility(
  routine: RoutineItem[],
  userProfile?: UserProfile
): CompatibilityResult {
  const conflicts: Conflict[] = [];
  const overlappingActives: { [key: string]: { count: number; products: any[] } } = {};
  
  // Check for same-time conflicts
  const amProducts = routine.filter(r => r.timeOfDay === 'AM' || r.timeOfDay === 'Both');
  const pmProducts = routine.filter(r => r.timeOfDay === 'PM' || r.timeOfDay === 'Both');
  
  // Retinoid + AHA conflict
  const hasRetinoidPM = pmProducts.some(r => 
    r.product.keyActives.some(a => a.toLowerCase().includes('retinoid') || a.toLowerCase().includes('retinol') || a.toLowerCase().includes('adapalene'))
  );
  const hasAHAPM = pmProducts.some(r => 
    r.product.keyActives.some(a => a.toLowerCase().includes('aha') || a.toLowerCase().includes('glycolic'))
  );
  
  if (hasRetinoidPM && hasAHAPM) {
    const retinoidProducts = pmProducts.filter(r => 
      r.product.keyActives.some(a => a.toLowerCase().includes('retinoid') || a.toLowerCase().includes('retinol') || a.toLowerCase().includes('adapalene'))
    );
    const ahaProducts = pmProducts.filter(r => 
      r.product.keyActives.some(a => a.toLowerCase().includes('aha') || a.toLowerCase().includes('glycolic'))
    );
    
    conflicts.push({
      id: 'conflict-1',
      severity: 'High',
      title: 'Retinoid + AHA (same night)',
      description: 'Higher irritation risk; barrier damage possible',
      products: [...retinoidProducts.map(r => r.product), ...ahaProducts.map(r => r.product)],
      details: 'Using retinoids and AHAs together on the same night can significantly increase skin irritation, redness, and barrier damage. Both are powerful exfoliants that work by increasing cell turnover.',
      suggestion: 'Alternate nights: use retinoid on Mon/Wed/Fri and AHA on Tue/Thu/Sat. Give your skin a barrier night on Sunday.'
    });
  }
  
  // Vitamin C + Benzoyl Peroxide
  const hasVitC = routine.some(r => 
    r.product.keyActives.some(a => a.toLowerCase().includes('vitamin c') || a.toLowerCase().includes('ascorbic'))
  );
  const hasBP = routine.some(r => 
    r.product.keyActives.some(a => a.toLowerCase().includes('benzoyl peroxide'))
  );
  
  if (hasVitC && hasBP) {
    const vitCProducts = routine.filter(r => 
      r.product.keyActives.some(a => a.toLowerCase().includes('vitamin c') || a.toLowerCase().includes('ascorbic'))
    );
    const bpProducts = routine.filter(r => 
      r.product.keyActives.some(a => a.toLowerCase().includes('benzoyl peroxide'))
    );
    
    conflicts.push({
      id: 'conflict-2',
      severity: 'Medium',
      title: 'Vitamin C + Benzoyl Peroxide',
      description: 'May reduce effectiveness of both actives',
      products: [...vitCProducts.map(r => r.product), ...bpProducts.map(r => r.product)],
      details: 'Benzoyl peroxide can oxidize vitamin C, reducing its effectiveness. While not as irritating as other combinations, you won\'t get the full benefits of either ingredient.',
      suggestion: 'Use Vitamin C in your AM routine and Benzoyl Peroxide in PM, or on alternate days.'
    });
  }
  
  // Count overlapping actives
  routine.forEach(item => {
    item.product.keyActives.forEach(active => {
      const key = active.toLowerCase();
      if (!overlappingActives[key]) {
        overlappingActives[key] = { count: 0, products: [] };
      }
      overlappingActives[key].count++;
      overlappingActives[key].products.push(item.product);
    });
  });
  
  const overlaps = Object.entries(overlappingActives)
    .filter(([_, data]) => data.count > 1)
    .map(([active, data]) => ({
      active: active.charAt(0).toUpperCase() + active.slice(1),
      count: data.count,
      products: data.products,
      suggestion: active.includes('niacinamide') 
        ? 'Usually fine, but watch for irritation if over 10% total'
        : active.includes('aha') || active.includes('bha')
        ? 'Consider using only one AHA/BHA product to avoid over-exfoliation'
        : 'You may not need multiple products with this active'
    }));
  
  // Personalized warnings
  const personalizedWarnings: string[] = [];
  if (userProfile?.hasSensitivity) {
    personalizedWarnings.push('Sensitive skin: avoid using 2 strong actives on the same day');
  }
  if (userProfile?.skinConcerns?.includes('acne')) {
    personalizedWarnings.push('Acne concern: benzoyl peroxide works best on separate nights from retinoids');
  }
  if (userProfile?.isPregnant) {
    const unsafeProducts = routine.filter(r => r.product.pregnancyFlag);
    if (unsafeProducts.length > 0) {
      personalizedWarnings.push(`Pregnancy safety: ${unsafeProducts.length} product(s) not recommended during pregnancy`);
    }
  }
  
  // Recommendations
  const recommendations = [];
  if (conflicts.length > 0) {
    recommendations.push({
      id: 'rec-1',
      title: 'Add 2 barrier nights',
      reason: 'Give your skin time to recover between active nights'
    });
  }
  if (overlaps.some(o => o.active.toLowerCase().includes('aha'))) {
    recommendations.push({
      id: 'rec-2',
      title: 'Reduce AHA to 2x/week',
      reason: 'Multiple AHA products can lead to over-exfoliation'
    });
  }
  if (conflicts.length > 1 || (conflicts.length === 1 && conflicts[0].severity === 'High')) {
    recommendations.push({
      id: 'rec-3',
      title: 'Alternate actives by night',
      reason: 'Prevents irritation while maintaining results'
    });
  }
  
  // Determine risk level
  const riskLevel = conflicts.some(c => c.severity === 'High') ? 'High' :
                    conflicts.length > 0 ? 'Medium' : 'Low';
  
  // Build suggested schedule
  const suggestedSchedule = buildSuggestedSchedule(routine, conflicts);
  
  return {
    riskLevel,
    summary: conflicts.length === 0 
      ? 'No major conflicts found' 
      : `${conflicts.length} conflict${conflicts.length > 1 ? 's' : ''} found`,
    conflictCount: conflicts.length,
    tags: conflicts.length > 0 
      ? Array.from(new Set(conflicts.map(c => 
          c.title.includes('irritation') || c.severity === 'High' ? 'Irritation risk' : 'Effectiveness concern'
        )))
      : ['All clear'],
    conflicts,
    overlappingActives: overlaps,
    personalizedWarnings,
    recommendations,
    suggestedSchedule
  };
}

function buildSuggestedSchedule(routine: RoutineItem[], conflicts: Conflict[]) {
  const amRoutine = routine.filter(r => 
    r.timeOfDay === 'AM' || (r.timeOfDay === 'Both' && !r.product.keyActives.some(a => 
      a.toLowerCase().includes('retinoid') || a.toLowerCase().includes('retinol')
    ))
  );
  
  // Organize PM into nights if there are conflicts
  const pmSchedule: { [key: string]: RoutineItem[] } = {};
  
  const hasConflicts = conflicts.length > 0;
  
  if (!hasConflicts) {
    // Simple daily routine
    pmSchedule['Daily'] = routine.filter(r => r.timeOfDay === 'PM' || r.timeOfDay === 'Both');
  } else {
    // Separate conflicting actives
    const retinoidItems = routine.filter(r => 
      (r.timeOfDay === 'PM' || r.timeOfDay === 'Both') &&
      r.product.keyActives.some(a => a.toLowerCase().includes('retinoid') || a.toLowerCase().includes('retinol') || a.toLowerCase().includes('adapalene'))
    );
    const ahaItems = routine.filter(r => 
      (r.timeOfDay === 'PM' || r.timeOfDay === 'Both') &&
      r.product.keyActives.some(a => a.toLowerCase().includes('aha') || a.toLowerCase().includes('glycolic'))
    );
    const barrierItems = routine.filter(r => 
      (r.timeOfDay === 'PM' || r.timeOfDay === 'Both') &&
      (r.product.category === 'Moisturizer' || r.product.keyActives.some(a => 
        a.toLowerCase().includes('ceramide') || a.toLowerCase().includes('panthenol')
      ))
    );
    const otherPM = routine.filter(r => 
      (r.timeOfDay === 'PM' || r.timeOfDay === 'Both') &&
      !retinoidItems.includes(r) && !ahaItems.includes(r) && !barrierItems.includes(r)
    );
    
    if (retinoidItems.length > 0) {
      pmSchedule['Retinoid nights (Mon/Wed/Fri)'] = [...retinoidItems, ...barrierItems];
    }
    if (ahaItems.length > 0) {
      pmSchedule['AHA nights (Tue/Sat)'] = [...ahaItems, ...barrierItems];
    }
    pmSchedule['Barrier nights (Thu/Sun)'] = barrierItems;
  }
  
  return {
    AM: amRoutine,
    PM: pmSchedule
  };
}
