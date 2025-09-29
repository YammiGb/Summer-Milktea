import React from 'react';
import { ShoppingCart } from 'lucide-react';
import { useSiteSettings } from '../hooks/useSiteSettings';

interface HeaderProps {
  cartItemsCount: number;
  onCartClick: () => void;
  onMenuClick: () => void;
}

const Header: React.FC<HeaderProps> = ({ cartItemsCount, onCartClick, onMenuClick }) => {
  const { siteSettings, loading } = useSiteSettings();

  return (
    <header className="sticky top-0 z-50 bg-summer-off-white/90 backdrop-blur-md border-b border-summer-warm-gray shadow-sm">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          <button 
            onClick={onMenuClick}
            className="flex items-center space-x-2 text-summer-dark hover:text-summer-orange transition-colors duration-200"
          >
            {loading ? (
              <div className="w-10 h-10 bg-summer-warm-gray rounded-full animate-pulse" />
            ) : (
              <div className="w-10 h-10 rounded-full ring-2 ring-summer-orange overflow-hidden bg-summer-cream">
                <img 
                  src={siteSettings?.site_logo || "/logo.jpeg"} 
                  alt={siteSettings?.site_name || "Summer Milktea"}
                  className="w-full h-full object-cover"
                  style={{ 
                    objectFit: 'cover', 
                    objectPosition: 'center',
                    transform: 'scale(1.2)'
                  }}
                  onError={(e) => {
                    e.currentTarget.src = "/logo.jpeg";
                  }}
                />
              </div>
            )}
            <h1 className="text-2xl font-summer-bold text-summer-dark">
              {loading ? (
                <div className="w-24 h-6 bg-summer-warm-gray rounded animate-pulse" />
              ) : (
                "Summer Milktea"
              )}
            </h1>
          </button>

          <div className="flex items-center space-x-2">
            <button 
              onClick={onCartClick}
              className="relative p-2 text-summer-text hover:text-summer-orange hover:bg-summer-cream rounded-full transition-all duration-200"
            >
              <ShoppingCart className="h-6 w-6" />
              {cartItemsCount > 0 && (
                <span className="absolute -top-1 -right-1 bg-summer-orange text-white text-xs rounded-full h-6 w-6 flex items-center justify-center font-summer-bold shadow-lg border-2 border-summer-off-white">
                  {cartItemsCount}
                </span>
              )}
            </button>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header;