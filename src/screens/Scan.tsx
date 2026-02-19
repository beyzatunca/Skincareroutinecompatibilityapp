import { useState, useRef, useEffect } from 'react';
import { useNavigate } from 'react-router';
import { X, ScanBarcode, Camera, FlashlightOff, Flashlight } from 'lucide-react';

export function Scan() {
  const navigate = useNavigate();
  const [isFlashOn, setIsFlashOn] = useState(false);
  const [scanning, setScanning] = useState(true);
  const [cameraError, setCameraError] = useState(false);
  const videoRef = useRef<HTMLVideoElement>(null);

  useEffect(() => {
    // Request camera access
    const startCamera = async () => {
      try {
        const stream = await navigator.mediaDevices.getUserMedia({
          video: { facingMode: 'environment' }
        });
        if (videoRef.current) {
          videoRef.current.srcObject = stream;
        }
        setCameraError(false);
      } catch (err) {
        // Silently handle camera permission denial
        setCameraError(true);
      }
    };

    startCamera();

    // Cleanup
    return () => {
      if (videoRef.current && videoRef.current.srcObject) {
        const stream = videoRef.current.srcObject as MediaStream;
        stream.getTracks().forEach(track => track.stop());
      }
    };
  }, []);

  const toggleFlash = () => {
    setIsFlashOn(!isFlashOn);
    // In a real app, this would control the device's flash
  };

  return (
    <div className="fixed inset-0 bg-black z-50">
      {/* Camera Error State */}
      {cameraError ? (
        <div className="absolute inset-0 bg-gray-900 flex items-center justify-center px-6">
          <div className="text-center space-y-4 max-w-sm">
            <div className="w-16 h-16 bg-red-500/20 rounded-full flex items-center justify-center mx-auto">
              <Camera className="w-8 h-8 text-red-500" />
            </div>
            <h2 className="text-white font-semibold text-xl">
              Camera Access Denied
            </h2>
            <p className="text-white/70 text-sm">
              Please allow camera access in your browser settings to scan product barcodes.
            </p>
            <div className="pt-4 space-y-3">
              <button
                onClick={() => navigate('/products')}
                className="w-full bg-gradient-to-br from-[#C8E6E0] via-[#D8F0EC] to-[#F0F9F7] text-gray-900 rounded-full py-4 font-semibold shadow-lg active:scale-[0.98] transition-all"
              >
                Search Products Instead
              </button>
              <button
                onClick={() => navigate('/products')}
                className="w-full text-white/70 py-3 text-sm font-medium"
              >
                Go Back
              </button>
            </div>
          </div>
        </div>
      ) : (
        <>
          {/* Camera View */}
          <video
            ref={videoRef}
            autoPlay
            playsInline
            muted
            className="absolute inset-0 w-full h-full object-cover"
          />

          {/* Overlay */}
          <div className="absolute inset-0 bg-black/40">
            {/* Header */}
            <div className="absolute top-0 left-0 right-0 px-6 pt-14 pb-6 bg-gradient-to-b from-black/60 to-transparent">
              <div className="flex items-center justify-between">
                <button
                  onClick={() => navigate('/products')}
                  className="w-10 h-10 rounded-full bg-white/20 backdrop-blur-sm flex items-center justify-center active:scale-95 transition-transform"
                >
                  <X className="w-6 h-6 text-white" />
                </button>
                
                <h1 className="text-white font-semibold text-lg">Scan Barcode</h1>
                
                <button
                  onClick={toggleFlash}
                  className="w-10 h-10 rounded-full bg-white/20 backdrop-blur-sm flex items-center justify-center active:scale-95 transition-transform"
                >
                  {isFlashOn ? (
                    <Flashlight className="w-5 h-5 text-white" />
                  ) : (
                    <FlashlightOff className="w-5 h-5 text-white" />
                  )}
                </button>
              </div>
            </div>

            {/* Scanning Frame */}
            <div className="absolute inset-0 flex items-center justify-center">
              <div className="relative w-72 h-72">
                {/* Corner borders */}
                <div className="absolute top-0 left-0 w-12 h-12 border-t-4 border-l-4 border-cyan-500 rounded-tl-2xl" />
                <div className="absolute top-0 right-0 w-12 h-12 border-t-4 border-r-4 border-cyan-500 rounded-tr-2xl" />
                <div className="absolute bottom-0 left-0 w-12 h-12 border-b-4 border-l-4 border-cyan-500 rounded-bl-2xl" />
                <div className="absolute bottom-0 right-0 w-12 h-12 border-b-4 border-r-4 border-cyan-500 rounded-br-2xl" />
                
                {/* Scanning line animation */}
                {scanning && (
                  <div className="absolute inset-0 overflow-hidden">
                    <div className="absolute left-0 right-0 h-1 bg-cyan-500 shadow-lg shadow-cyan-500/50 animate-scan" />
                  </div>
                )}
              </div>
            </div>

            {/* Instructions */}
            <div className="absolute bottom-0 left-0 right-0 px-6 pb-12 bg-gradient-to-t from-black/60 to-transparent">
              <div className="text-center space-y-3">
                <div className="flex justify-center">
                  <ScanBarcode className="w-12 h-12 text-cyan-500" />
                </div>
                <h2 className="text-white font-semibold text-xl">
                  Position barcode in frame
                </h2>
                <p className="text-white/70 text-sm max-w-xs mx-auto">
                  Align the product barcode within the frame to scan and get instant product information
                </p>
              </div>
            </div>
          </div>
        </>
      )}

      <style>{`
        @keyframes scan {
          0% {
            top: 0;
          }
          50% {
            top: 100%;
          }
          100% {
            top: 0;
          }
        }
        
        .animate-scan {
          animation: scan 2s ease-in-out infinite;
        }
      `}</style>
    </div>
  );
}