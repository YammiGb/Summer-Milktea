import React from 'react';
import { useCategories } from '../hooks/useCategories';

interface SubNavProps {
  selectedCategory: string;
  onCategoryClick: (categoryId: string) => void;
}

const SubNav: React.FC<SubNavProps> = ({ selectedCategory, onCategoryClick }) => {
  const { categories, loading } = useCategories();

  return (
    <div className="sticky top-16 z-40 bg-summer-off-white/90 backdrop-blur-md border-b border-summer-warm-gray">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center space-x-4 overflow-x-auto py-3 scrollbar-hide">
          {loading ? (
            <div className="flex space-x-4">
              {[1,2,3,4,5].map(i => (
                <div key={i} className="h-8 w-20 bg-summer-warm-gray rounded animate-pulse" />
              ))}
            </div>
          ) : (
            <>
              <button
                onClick={() => onCategoryClick('all')}
                className={`px-4 py-2 rounded-full text-sm font-summer-medium transition-all duration-200 border-2 ${
                  selectedCategory === 'all'
                    ? 'bg-summer-orange text-white border-summer-orange shadow-lg'
                    : 'bg-summer-off-white text-summer-text border-summer-warm-gray hover:border-summer-orange hover:text-summer-orange'
                }`}
              >
                All
              </button>
              {categories.map((c) => (
                <button
                  key={c.id}
                  onClick={() => onCategoryClick(c.id)}
                  className={`px-4 py-2 rounded-full text-sm font-summer-medium transition-all duration-200 border-2 flex items-center space-x-2 whitespace-nowrap ${
                    selectedCategory === c.id
                      ? 'bg-summer-orange text-white border-summer-orange shadow-lg'
                      : 'bg-summer-off-white text-summer-text border-summer-warm-gray hover:border-summer-orange hover:text-summer-orange'
                  }`}
                >
                  <span className="text-lg">{c.icon}</span>
                  <span>{c.name}</span>
                </button>
              ))}
            </>
          )}
        </div>
      </div>
    </div>
  );
};

export default SubNav;


