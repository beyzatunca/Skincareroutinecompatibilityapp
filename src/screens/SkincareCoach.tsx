import { useState, useRef, useEffect } from 'react';
import { useNavigate, useSearchParams } from 'react-router';
import { X, Send, Sparkles } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';
import { Product } from '../types';
import { sampleProducts } from '../data/products';

interface Message {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp: Date;
}

export function SkincareCoach() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const productId = searchParams.get('productId');
  
  const [messages, setMessages] = useState<Message[]>([]);
  const [inputValue, setInputValue] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Get product details
  const product: Product | undefined = productId 
    ? sampleProducts.find(p => p.id === productId)
    : undefined;

  // Scroll to bottom when messages change
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages, isTyping]);

  // Initial greeting
  useEffect(() => {
    if (messages.length === 0) {
      const greeting: Message = {
        id: Date.now().toString(),
        role: 'assistant',
        content: product
          ? `Hi! I'm your Skincare Coach 🌟\n\nI see you're looking at **${product.name}** by ${product.brand}. I'd be happy to answer any questions about this product, its ingredients, how to use it, or how it might work with your routine!`
          : `Hi! I'm your Skincare Coach 🌟\n\nI'm here to help you with product recommendations and skincare advice. What would you like to know?`,
        timestamp: new Date(),
      };
      setMessages([greeting]);
    }
  }, []);

  const generateAIResponse = (userMessage: string): string => {
    const lowerMessage = userMessage.toLowerCase();

    if (!product) {
      return "I'm here to help with specific products! Please select a product first to get personalized advice.";
    }

    // Ingredients questions
    if (lowerMessage.includes('ingredient') || lowerMessage.includes('contain') || lowerMessage.includes('what')) {
      const ingredients = product.ingredients?.slice(0, 5).join(', ') || 'hyaluronic acid, niacinamide, peptides';
      return `**${product.name}** contains several beneficial ingredients:\n\n${ingredients}, and more.\n\nThe key active ingredients work together to ${product.description?.toLowerCase() || 'improve your skin'}. Would you like to know more about any specific ingredient?`;
    }

    // Usage questions
    if (lowerMessage.includes('how to use') || lowerMessage.includes('apply') || lowerMessage.includes('when')) {
      const category = product.category?.toLowerCase();
      let usage = '';
      
      if (category === 'serum') {
        usage = 'Apply 2-3 drops to clean, slightly damp skin. Gently press into face and neck, avoiding eye area. Use in both AM and PM before moisturizer.';
      } else if (category === 'cleanser') {
        usage = 'Use morning and evening. Wet face, apply a small amount, massage gently in circular motions, then rinse thoroughly with lukewarm water.';
      } else if (category === 'moisturizer') {
        usage = 'Apply to clean skin as the last step of your routine (before SPF in AM). Use a dime-sized amount, warm between palms, and press gently into skin.';
      } else if (category === 'spf') {
        usage = 'Apply as the last step of your morning routine, at least 15 minutes before sun exposure. Use about 1/4 teaspoon for face. Reapply every 2 hours.';
      } else {
        usage = `Apply to clean, dry skin as directed. For ${product.name}, use ${product.timeOfDay === 'Both' ? 'morning and evening' : product.timeOfDay?.toLowerCase() || 'as needed'}.`;
      }
      
      return `**How to use ${product.name}:**\n\n${usage}\n\n💡 Tip: Always patch test new products before full application!`;
    }

    // Routine compatibility
    if (lowerMessage.includes('routine') || lowerMessage.includes('combine') || lowerMessage.includes('together')) {
      return `**${product.name}** can be used in ${product.timeOfDay === 'Both' ? 'both AM and PM routines' : `your ${product.timeOfDay} routine`}.\n\nIt works well with most products, but avoid using it with:\n• Strong acids (AHA/BHA) in the same application\n• Retinol (use one in AM, one in PM)\n• Other active treatments (space them out)\n\nWould you like help building a complete routine?`;
    }

    // Skin type questions
    if (lowerMessage.includes('skin type') || lowerMessage.includes('oily') || lowerMessage.includes('dry') || lowerMessage.includes('sensitive')) {
      return `**${product.name}** is ${product.description?.toLowerCase().includes('all skin') ? 'suitable for all skin types' : 'formulated for specific skin needs'}.\n\n${product.description}\n\nIt's particularly beneficial for skin that needs ${product.category?.toLowerCase() === 'serum' ? 'targeted treatment and hydration' : 'gentle care and nourishment'}. What's your skin type? I can provide more personalized advice!`;
    }

    // Price/value questions
    if (lowerMessage.includes('price') || lowerMessage.includes('worth') || lowerMessage.includes('expensive')) {
      return `**${product.name}** is priced at ${product.priceRange}.\n\nConsidering the quality ingredients and the ${product.brand} brand reputation, many users find it offers good value. The product typically lasts 2-3 months with regular use.\n\nWould you like to know about similar alternatives at different price points?`;
    }

    // Results/effectiveness
    if (lowerMessage.includes('result') || lowerMessage.includes('work') || lowerMessage.includes('effective') || lowerMessage.includes('benefit')) {
      return `**${product.name}** is designed to ${product.description?.toLowerCase() || 'improve your skin health'}.\n\nMost users report seeing initial results within 2-4 weeks, with optimal results after 8-12 weeks of consistent use.\n\n✨ Key benefits:\n• Improved skin texture\n• Enhanced hydration\n• Visible reduction in concerns\n• Better overall skin health\n\nConsistency is key for best results!`;
    }

    // Default response
    return `Great question about **${product.name}**!\n\n${product.description}\n\nI can help you with:\n• Ingredients breakdown\n• How to use it\n• Routine compatibility\n• Skin type suitability\n• Expected results\n\nWhat specific aspect would you like to know more about?`;
  };

  const handleSend = () => {
    if (!inputValue.trim()) return;

    // Add user message
    const userMessage: Message = {
      id: Date.now().toString(),
      role: 'user',
      content: inputValue,
      timestamp: new Date(),
    };

    setMessages(prev => [...prev, userMessage]);
    setInputValue('');
    setIsTyping(true);

    // Simulate AI thinking time
    setTimeout(() => {
      const aiResponse: Message = {
        id: (Date.now() + 1).toString(),
        role: 'assistant',
        content: generateAIResponse(inputValue),
        timestamp: new Date(),
      };

      setMessages(prev => [...prev, aiResponse]);
      setIsTyping(false);
    }, 1000 + Math.random() * 1000);
  };

  return (
    <div className="fixed inset-0 bg-gradient-to-br from-purple-50 via-pink-50 to-blue-50 z-50 flex flex-col">
      {/* Header */}
      <div className="bg-white/80 backdrop-blur-lg border-b border-purple-100">
        <div className="max-w-md mx-auto px-6 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            {/* AI Avatar */}
            <div className="w-10 h-10 rounded-full bg-gradient-to-br from-[#E8D5F2] to-[#F0E3F7] flex items-center justify-center">
              <div className="w-8 h-8 bg-white rounded-full flex items-center justify-center relative">
                <div className="absolute top-2.5 left-2 w-1 h-1.5 bg-purple-900 rounded-full" />
                <div className="absolute top-2.5 right-2 w-1 h-1.5 bg-purple-900 rounded-full" />
                <svg className="absolute top-3.5 left-1/2 -translate-x-1/2" width="12" height="8" viewBox="0 0 16 10" fill="none">
                  <path d="M2 2C2 2 4 6 8 6C12 6 14 2 14 2" stroke="#581C87" strokeWidth="1.5" strokeLinecap="round" />
                </svg>
              </div>
            </div>
            
            <div>
              <h1 className="font-semibold text-gray-900 flex items-center gap-2">
                Skincare Coach
                <Sparkles className="w-4 h-4 text-purple-600" />
              </h1>
              <p className="text-xs text-gray-500">AI-powered advice</p>
            </div>
          </div>

          <button
            onClick={() => navigate(-1)}
            className="w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center active:bg-gray-200 transition-colors"
          >
            <X className="w-5 h-5 text-gray-600" />
          </button>
        </div>
      </div>

      {/* Product context banner (if product selected) */}
      {product && (
        <div className="bg-white/60 backdrop-blur-sm border-b border-purple-100">
          <div className="max-w-md mx-auto px-6 py-3 flex items-center gap-3">
            <img 
              src={product.image} 
              alt={product.name}
              className="w-10 h-10 rounded-lg object-cover"
            />
            <div className="flex-1 min-w-0">
              <p className="text-xs text-purple-600 font-medium">Discussing</p>
              <p className="text-sm font-semibold text-gray-900 truncate">{product.name}</p>
            </div>
          </div>
        </div>
      )}

      {/* Messages */}
      <div className="flex-1 overflow-y-auto px-6 py-4 max-w-md mx-auto w-full">
        <AnimatePresence initial={false}>
          {messages.map((message) => (
            <motion.div
              key={message.id}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0 }}
              className={`mb-4 flex ${message.role === 'user' ? 'justify-end' : 'justify-start'}`}
            >
              <div
                className={`max-w-[80%] rounded-2xl px-4 py-3 ${
                  message.role === 'user'
                    ? 'bg-gradient-to-br from-teal-500 to-teal-600 text-white'
                    : 'bg-white shadow-sm text-gray-800'
                }`}
              >
                <p className="text-sm whitespace-pre-wrap leading-relaxed">
                  {message.content}
                </p>
                <p className={`text-[10px] mt-1 ${message.role === 'user' ? 'text-teal-100' : 'text-gray-400'}`}>
                  {message.timestamp.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' })}
                </p>
              </div>
            </motion.div>
          ))}
        </AnimatePresence>

        {/* Typing indicator */}
        {isTyping && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            className="flex justify-start mb-4"
          >
            <div className="bg-white shadow-sm rounded-2xl px-4 py-3">
              <div className="flex gap-1">
                <motion.div
                  className="w-2 h-2 bg-purple-400 rounded-full"
                  animate={{ y: [0, -6, 0] }}
                  transition={{ duration: 0.6, repeat: Infinity, delay: 0 }}
                />
                <motion.div
                  className="w-2 h-2 bg-purple-400 rounded-full"
                  animate={{ y: [0, -6, 0] }}
                  transition={{ duration: 0.6, repeat: Infinity, delay: 0.2 }}
                />
                <motion.div
                  className="w-2 h-2 bg-purple-400 rounded-full"
                  animate={{ y: [0, -6, 0] }}
                  transition={{ duration: 0.6, repeat: Infinity, delay: 0.4 }}
                />
              </div>
            </div>
          </motion.div>
        )}

        <div ref={messagesEndRef} />
      </div>

      {/* Input */}
      <div className="bg-white/80 backdrop-blur-lg border-t border-purple-100 safe-area-inset-bottom">
        <div className="max-w-md mx-auto px-6 py-4">
          <div className="flex items-end gap-2">
            <input
              type="text"
              value={inputValue}
              onChange={(e) => setInputValue(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && handleSend()}
              placeholder={product ? `Ask about ${product.name}...` : "Ask me anything..."}
              className="flex-1 bg-gray-100 rounded-full px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-purple-400"
            />
            <button
              onClick={handleSend}
              disabled={!inputValue.trim()}
              className="w-10 h-10 rounded-full bg-gradient-to-br from-teal-500 to-teal-600 flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed active:scale-95 transition-transform"
            >
              <Send className="w-5 h-5 text-white" />
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
