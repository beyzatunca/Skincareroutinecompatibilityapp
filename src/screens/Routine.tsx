import { useNavigate } from 'react-router';
import { Plus, Trash2 } from 'lucide-react';
import { useApp } from '../context/AppContext';
import { useState } from 'react';

export function Routine() {
  const navigate = useNavigate();
  const { routine, removeFromRoutine, updateRoutineItem } = useApp();
  const [deleteModalOpen, setDeleteModalOpen] = useState(false);
  const [productToDelete, setProductToDelete] = useState<string | null>(null);

  const handleTimeChange = (id: string, newTime: 'AM' | 'PM' | 'Both') => {
    updateRoutineItem(id, { timeOfDay: newTime });
  };

  const handleFrequencyChange = (id: string, newFrequency: 'daily' | '2-3x week' | 'alternate days') => {
    updateRoutineItem(id, { frequency: newFrequency });
  };

  const handleDelete = (id: string) => {
    setProductToDelete(id);
    setDeleteModalOpen(true);
  };

  const confirmDelete = () => {
    if (productToDelete) {
      removeFromRoutine(productToDelete);
    }
    setDeleteModalOpen(false);
    setProductToDelete(null);
  };

  const cancelDelete = () => {
    setDeleteModalOpen(false);
    setProductToDelete(null);
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white px-6 pt-16 pb-6 border-b border-gray-200">
        <h1 className="text-2xl font-bold text-gray-900">Manage My Products</h1>
        <p className="text-sm text-gray-500 mt-1">
          {routine.length} {routine.length === 1 ? 'product' : 'products'} in your routine
        </p>
      </div>

      {/* Products List */}
      <div className="px-4 py-4 pb-32">
        {routine.length === 0 ? (
          <div className="bg-white rounded-2xl p-8 text-center shadow-sm border border-gray-200">
            <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Plus className="w-8 h-8 text-gray-400" />
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">
              Start Building Your Routine
            </h3>
            <p className="text-sm text-gray-600 mb-6">
              Add products and get a compatibility check
            </p>
            <button
              onClick={() => navigate('/products')}
              className="bg-gradient-to-r from-[#C8E6E0] via-[#D8F0EC] to-[#F0F9F7] text-gray-900 px-6 py-3 rounded-full font-semibold active:opacity-80 transition-opacity"
            >
              Add Products
            </button>
          </div>
        ) : (
          <div className="space-y-3">
            {routine.map(item => (
              <div
                key={item.id}
                className="bg-white rounded-2xl p-4 shadow-sm border border-gray-200"
              >
                {/* Product Info Row */}
                <div className="flex gap-3 mb-4">
                  <button
                    onClick={() => navigate(`/product/${item.product.id}`)}
                    className="w-16 h-16 bg-gray-100 rounded-xl flex-shrink-0 overflow-hidden active:opacity-80 transition-opacity"
                  >
                    {item.product.imageUrl && (
                      <img
                        src={item.product.imageUrl}
                        alt={item.product.productName}
                        className="w-full h-full object-cover"
                      />
                    )}
                  </button>

                  <div className="flex-1 min-w-0">
                    <button
                      onClick={() => navigate(`/product/${item.product.id}`)}
                      className="text-left w-full mb-1"
                    >
                      <h3 className="font-semibold text-gray-900 text-sm line-clamp-1">
                        {item.product.productName}
                      </h3>
                      <p className="text-xs text-gray-500 line-clamp-1">
                        {item.product.brand}
                      </p>
                    </button>
                  </div>

                  <button
                    onClick={() => handleDelete(item.id)}
                    className="w-8 h-8 rounded-lg flex items-center justify-center text-gray-400 hover:text-red-600 hover:bg-red-50 transition-colors flex-shrink-0"
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>

                {/* Time of Day */}
                <div className="mb-3">
                  <p className="text-xs font-medium text-gray-700 mb-2">Time of Day</p>
                  <div className="flex gap-2">
                    {(['AM', 'PM', 'Both'] as const).map(time => (
                      <button
                        key={time}
                        onClick={() => handleTimeChange(item.id, time)}
                        className={`flex-1 py-2 rounded-lg text-sm font-medium transition-all ${
                          item.timeOfDay === time
                            ? 'bg-gradient-to-r from-[#C8E6E0] via-[#D8F0EC] to-[#F0F9F7] text-gray-900 shadow-sm'
                            : 'bg-gray-50 text-gray-600 hover:bg-gray-100'
                        }`}
                      >
                        {time}
                      </button>
                    ))}
                  </div>
                </div>

                {/* Frequency */}
                <div>
                  <p className="text-xs font-medium text-gray-700 mb-2">Frequency</p>
                  <div className="flex gap-2">
                    {(['daily', '2-3x week', 'alternate days'] as const).map(freq => (
                      <button
                        key={freq}
                        onClick={() => handleFrequencyChange(item.id, freq)}
                        className={`flex-1 py-2 rounded-lg text-xs font-medium transition-all ${
                          item.frequency === freq
                            ? 'bg-gradient-to-r from-[#C8E6E0] via-[#D8F0EC] to-[#F0F9F7] text-gray-900 shadow-sm'
                            : 'bg-gray-50 text-gray-600 hover:bg-gray-100'
                        }`}
                      >
                        {freq === 'daily' ? 'Daily' : freq === '2-3x week' ? '2-3x/week' : 'Alternate'}
                      </button>
                    ))}
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Delete Confirmation Modal */}
      {deleteModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center px-6">
          {/* Backdrop */}
          <div 
            className="absolute inset-0 bg-black/50"
            onClick={cancelDelete}
          />
          
          {/* Modal */}
          <div className="relative bg-white rounded-3xl p-6 shadow-2xl max-w-sm w-full mx-auto">
            <h3 className="text-lg font-semibold text-gray-900 mb-2">
              Remove Product?
            </h3>
            <p className="text-sm text-gray-600 mb-6">
              Are you sure you want to remove this product from your routine?
            </p>
            <div className="flex gap-3">
              <button
                onClick={cancelDelete}
                className="flex-1 bg-gray-100 text-gray-900 py-3 rounded-full font-semibold active:opacity-80 transition-opacity"
              >
                Cancel
              </button>
              <button
                onClick={confirmDelete}
                className="flex-1 bg-red-500 text-white py-3 rounded-full font-semibold active:opacity-80 transition-opacity"
              >
                Remove
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}