import { motion } from 'motion/react';
import { MessageCircle } from 'lucide-react';

interface AIChatbotButtonProps {
  onClick: () => void;
}

export function AIChatbotButton({ onClick }: AIChatbotButtonProps) {
  return (
    <motion.button
      onClick={onClick}
      className="fixed bottom-24 right-6 z-40 w-14 h-14 rounded-full bg-gradient-to-br from-[#E8D5F2] to-[#F0E3F7] shadow-lg flex items-center justify-center"
      whileHover={{ scale: 1.05 }}
      whileTap={{ scale: 0.95 }}
      animate={{
        y: [0, -8, 0],
      }}
      transition={{
        y: {
          duration: 2,
          repeat: Infinity,
          ease: "easeInOut"
        }
      }}
    >
      {/* Smiley Face */}
      <div className="w-12 h-12 bg-white rounded-full flex items-center justify-center relative">
        {/* Eyes */}
        <div className="absolute top-4 left-3 w-1.5 h-2 bg-purple-900 rounded-full" />
        <div className="absolute top-4 right-3 w-1.5 h-2 bg-purple-900 rounded-full" />
        
        {/* Smile */}
        <svg
          className="absolute top-5 left-1/2 -translate-x-1/2"
          width="16"
          height="10"
          viewBox="0 0 16 10"
          fill="none"
        >
          <path
            d="M2 2C2 2 4 6 8 6C12 6 14 2 14 2"
            stroke="#581C87"
            strokeWidth="2"
            strokeLinecap="round"
          />
        </svg>
      </div>
      
      {/* Notification dot (optional) */}
      <div className="absolute -top-1 -right-1 w-3 h-3 bg-pink-500 rounded-full border-2 border-white" />
    </motion.button>
  );
}
