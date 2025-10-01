import React, { useState } from 'react';
import { Plus, Minus, X, ShoppingCart } from 'lucide-react';
import { MenuItem, Variation, AddOn } from '../types';

interface MenuItemCardProps {
  item: MenuItem;
  onAddToCart: (item: MenuItem, quantity?: number, variation?: Variation, addOns?: AddOn[]) => void;
  quantity: number;
  onUpdateQuantity: (id: string, quantity: number) => void;
}

const MenuItemCard: React.FC<MenuItemCardProps> = ({ 
  item, 
  onAddToCart, 
  quantity, 
  onUpdateQuantity 
}) => {
  const [showCustomization, setShowCustomization] = useState(false);
  const [selectedVariation, setSelectedVariation] = useState<Variation | undefined>(
    // Prefer the base price variation (price === 0); fallback to first
    item.variations?.find(v => v.price === 0)
    ?? item.variations?.[0]
  );
  const [selectedAddOns, setSelectedAddOns] = useState<(AddOn & { quantity: number })[]>([]);

  const calculatePrice = () => {
    // Use effective price (discounted or regular) as base
    let price = item.effectivePrice || item.basePrice;
    if (selectedVariation) {
      price = (item.effectivePrice || item.basePrice) + selectedVariation.price;
    }
    selectedAddOns.forEach(addOn => {
      price += addOn.price * addOn.quantity;
    });
    return price;
  };

  const handleAddToCart = () => {
    if (item.variations?.length || item.addOns?.length) {
      setShowCustomization(true);
    } else {
      onAddToCart(item, 1);
    }
  };

  const handleCustomizedAddToCart = () => {
    // Convert selectedAddOns back to regular AddOn array for cart
    const addOnsForCart: AddOn[] = selectedAddOns.flatMap(addOn => 
      Array(addOn.quantity).fill({ ...addOn, quantity: undefined })
    );
    onAddToCart(item, 1, selectedVariation, addOnsForCart);
    setShowCustomization(false);
    setSelectedAddOns([]);
  };

  const handleIncrement = () => {
    onUpdateQuantity(item.id, quantity + 1);
  };

  const handleDecrement = () => {
    if (quantity > 0) {
      onUpdateQuantity(item.id, quantity - 1);
    }
  };

  const updateAddOnQuantity = (addOn: AddOn, quantity: number) => {
    setSelectedAddOns(prev => {
      const existingIndex = prev.findIndex(a => a.id === addOn.id);
      
      if (quantity === 0) {
        // Remove add-on if quantity is 0
        return prev.filter(a => a.id !== addOn.id);
      }
      
      if (existingIndex >= 0) {
        // Update existing add-on quantity
        const updated = [...prev];
        updated[existingIndex] = { ...updated[existingIndex], quantity };
        return updated;
      } else {
        // Add new add-on with quantity
        return [...prev, { ...addOn, quantity }];
      }
    });
  };

  const groupedAddOns = item.addOns?.reduce((groups, addOn) => {
    const category = addOn.category;
    if (!groups[category]) {
      groups[category] = [];
    }
    groups[category].push(addOn);
    return groups;
  }, {} as Record<string, AddOn[]>);

  return (
    <>
      <div className={`bg-summer-off-white rounded-2xl shadow-sm hover:shadow-xl transition-all duration-300 overflow-hidden group animate-scale-in border border-summer-warm-gray ${!item.available ? 'opacity-60' : ''}`}>
        {/* Image Container with Badges */}
        <div className="relative h-48 bg-gradient-to-br from-summer-cream to-summer-warm-gray">
          {item.image ? (
            <img
              src={item.image}
              alt={item.name}
              className="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105"
              loading="lazy"
              decoding="async"
              onError={(e) => {
                e.currentTarget.style.display = 'none';
                e.currentTarget.nextElementSibling?.classList.remove('hidden');
              }}
            />
          ) : null}
          <div className={`absolute inset-0 flex items-center justify-center ${item.image ? 'hidden' : ''}`}>
            <div className="text-6xl opacity-20 text-summer-muted">🧋</div>
          </div>
          
          {/* Badges */}
          <div className="absolute top-3 left-3 flex flex-col gap-2">
                  {item.isOnDiscount && item.discountPrice && (
                    <div className="bg-summer-orange-accent text-white text-xs font-summer-bold px-3 py-1.5 rounded-full shadow-lg animate-pulse">
                      SALE
                    </div>
                  )}
          </div>
          
          {!item.available && (
            <div className="absolute top-3 right-3 bg-summer-orange-accent text-white text-xs font-summer-bold px-3 py-1.5 rounded-full shadow-lg">
              UNAVAILABLE
            </div>
          )}
          
          {/* Discount Percentage Badge */}
          {item.isOnDiscount && item.discountPrice && (
            <div className="absolute bottom-3 right-3 bg-summer-off-white/90 backdrop-blur-sm text-summer-orange-accent text-xs font-summer-bold px-2 py-1 rounded-full shadow-lg">
              {Math.round(((item.basePrice - item.discountPrice) / item.basePrice) * 100)}% OFF
            </div>
          )}
        </div>
        
        {/* Content */}
        <div className="p-5">
          <div className="flex items-start justify-between mb-3">
            <h4 className="text-lg font-summer-bold text-summer-dark leading-tight flex-1 pr-2">{item.name}</h4>
            {item.variations && item.variations.length > 0 && (
              <div className="text-xs text-summer-muted bg-summer-warm-gray px-2 py-1 rounded-full whitespace-nowrap font-summer-regular">
                {item.variations.length} {
                  // Check if variations are sizes (Small/Medium/Large/oz) or flavors
                  item.variations.some(v => 
                    v.name.toLowerCase().includes('small') || 
                    v.name.toLowerCase().includes('medium') || 
                    v.name.toLowerCase().includes('large') ||
                    v.name.toLowerCase().includes('oz')
                  ) ? 'sizes' : 'flavors'
                }
              </div>
            )}
          </div>
          
          <p className={`text-sm mb-4 leading-relaxed font-summer-regular ${!item.available ? 'text-summer-muted' : 'text-summer-text'}`}>
            {!item.available ? 'Currently Unavailable' : item.description}
          </p>
          
          {/* Pricing Section */}
          <div className="flex items-center justify-between mb-4">
            <div className="flex-1">
              {item.isOnDiscount && item.discountPrice ? (
                <div className="space-y-1">
                  <div className="flex items-center space-x-2">
                    <span className="text-2xl font-summer-bold text-summer-orange-accent">
                      ₱{item.discountPrice.toFixed(2)}
                    </span>
                    <span className="text-sm text-summer-muted line-through font-summer-regular">
                      ₱{item.basePrice.toFixed(2)}
                    </span>
                  </div>
                  <div className="text-xs text-summer-muted font-summer-regular">
                    Save ₱{(item.basePrice - item.discountPrice).toFixed(2)}
                  </div>
                </div>
              ) : (
                <div className="text-2xl font-summer-bold text-summer-dark">
                  ₱{item.basePrice.toFixed(2)}
                </div>
              )}
              
                  {item.variations && item.variations.length > 0 && (
                    <div className="text-xs text-summer-muted mt-1 font-summer-regular">
                      Base price
                    </div>
                  )}
            </div>
            
            {/* Action Buttons */}
            <div className="flex-shrink-0">
              {!item.available ? (
                <button
                  disabled
                  className="bg-summer-warm-gray text-summer-muted px-4 py-2.5 rounded-xl cursor-not-allowed font-summer-medium text-sm"
                >
                  Unavailable
                </button>
              ) : quantity === 0 ? (
                        <button
                          onClick={handleAddToCart}
                          className="bg-summer-orange text-white px-6 py-2.5 rounded-xl hover:bg-summer-orange-accent transition-all duration-200 transform hover:scale-105 font-summer-bold text-sm shadow-lg hover:shadow-xl"
                        >
                          {item.variations?.length || item.addOns?.length ? 'Customize' : 'Add to Cart'}
                        </button>
              ) : (
                <div className="flex items-center space-x-2 bg-gradient-to-r from-summer-cream to-summer-warm-gray rounded-xl p-1 border border-summer-orange">
                  <button
                    onClick={handleDecrement}
                    className="p-2 hover:bg-summer-orange hover:text-white rounded-lg transition-colors duration-200 hover:scale-110"
                  >
                    <Minus className="h-4 w-4 text-summer-text" />
                  </button>
                  <span className="font-summer-bold text-summer-dark min-w-[28px] text-center text-sm">{quantity}</span>
                  <button
                    onClick={handleIncrement}
                    className="p-2 hover:bg-summer-orange hover:text-white rounded-lg transition-colors duration-200 hover:scale-110"
                  >
                    <Plus className="h-4 w-4 text-summer-text" />
                  </button>
                </div>
              )}
            </div>
          </div>

          {/* Add-ons indicator */}
          {item.addOns && item.addOns.length > 0 && (
            <div className="flex items-center space-x-1 text-xs text-summer-muted bg-summer-warm-gray px-2 py-1 rounded-lg font-summer-regular">
              <span>+</span>
              <span>{item.addOns.length} add-on{item.addOns.length > 1 ? 's' : ''} available</span>
            </div>
          )}
        </div>
      </div>

      {/* Customization Modal */}
      {showCustomization && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4">
          <div className="bg-summer-off-white rounded-2xl max-w-md w-full max-h-[90vh] overflow-y-auto shadow-2xl">
            <div className="sticky top-0 bg-summer-off-white border-b border-summer-warm-gray p-6 flex items-center justify-between rounded-t-2xl">
              <div>
                <h3 className="text-xl font-summer-bold text-summer-dark">Customize {item.name}</h3>
                <p className="text-sm text-summer-muted mt-1 font-summer-regular">Choose your preferences</p>
              </div>
              <button
                onClick={() => setShowCustomization(false)}
                className="p-2 hover:bg-summer-warm-gray rounded-full transition-colors duration-200"
              >
                <X className="h-5 w-5 text-summer-muted" />
              </button>
            </div>

            <div className="p-6">
              {/* Size Variations */}
              {item.variations && item.variations.length > 0 && (
                <div className="mb-6">
                  <h4 className="font-summer-bold text-summer-dark mb-4">
                    {item.variations.some(v => 
                      v.name.toLowerCase().includes('small') || 
                      v.name.toLowerCase().includes('medium') || 
                      v.name.toLowerCase().includes('large') ||
                      v.name.toLowerCase().includes('oz')
                    ) ? 'Choose Size' : 'Choose Flavor'}
                  </h4>
                  <div className="space-y-3">
                    {item.variations.map((variation) => (
                      <label
                        key={variation.id}
                        className={`flex items-center justify-between p-4 border-2 rounded-xl cursor-pointer transition-all duration-200 ${
                          selectedVariation?.id === variation.id
                            ? 'border-summer-orange bg-summer-cream'
                            : 'border-summer-warm-gray hover:border-summer-orange hover:bg-summer-warm-gray'
                        }`}
                      >
                        <div className="flex items-center space-x-3">
                          <input
                            type="radio"
                            name="variation"
                            checked={selectedVariation?.id === variation.id}
                            onChange={() => setSelectedVariation(variation)}
                            className="text-summer-orange focus:ring-summer-orange"
                          />
                          <span className="font-summer-medium text-summer-dark">{variation.name}</span>
                        </div>
                        <span className="text-summer-dark font-summer-bold">
                          ₱{((item.effectivePrice || item.basePrice) + variation.price).toFixed(2)}
                        </span>
                      </label>
                    ))}
                  </div>
                </div>
              )}

              {/* Add-ons */}
              {groupedAddOns && Object.keys(groupedAddOns).length > 0 && (
                <div className="mb-6">
                  <h4 className="font-summer-bold text-summer-dark mb-4">Add-ons</h4>
                  {Object.entries(groupedAddOns).map(([category, addOns]) => (
                    <div key={category} className="mb-4">
                      <h5 className="text-sm font-summer-medium text-summer-text mb-3 capitalize">
                        {category.replace('-', ' ')}
                      </h5>
                      <div className="space-y-3">
                        {addOns.map((addOn) => (
                          <div
                            key={addOn.id}
                            className="flex items-center justify-between p-4 border border-summer-warm-gray rounded-xl hover:border-summer-orange hover:bg-summer-warm-gray transition-all duration-200"
                          >
                            <div className="flex-1">
                              <span className="font-summer-medium text-summer-dark">{addOn.name}</span>
                              <div className="text-sm text-summer-text font-summer-regular">
                                {addOn.price > 0 ? `₱${addOn.price.toFixed(2)} each` : 'Free'}
                              </div>
                            </div>
                            
                            <div className="flex items-center space-x-2">
                              {selectedAddOns.find(a => a.id === addOn.id) ? (
                                <div className="flex items-center space-x-2 bg-summer-cream rounded-xl p-1 border border-summer-orange">
                                  <button
                                    type="button"
                                    onClick={() => {
                                      const current = selectedAddOns.find(a => a.id === addOn.id);
                                      updateAddOnQuantity(addOn, (current?.quantity || 1) - 1);
                                    }}
                                    className="p-1.5 hover:bg-summer-orange hover:text-white rounded-lg transition-colors duration-200"
                                  >
                                    <Minus className="h-3 w-3 text-summer-orange" />
                                  </button>
                                  <span className="font-summer-bold text-summer-dark min-w-[24px] text-center text-sm">
                                    {selectedAddOns.find(a => a.id === addOn.id)?.quantity || 0}
                                  </span>
                                  <button
                                    type="button"
                                    onClick={() => {
                                      const current = selectedAddOns.find(a => a.id === addOn.id);
                                      updateAddOnQuantity(addOn, (current?.quantity || 0) + 1);
                                    }}
                                    className="p-1.5 hover:bg-summer-orange hover:text-white rounded-lg transition-colors duration-200"
                                  >
                                    <Plus className="h-3 w-3 text-summer-orange" />
                                  </button>
                                </div>
                              ) : (
                                <button
                                  type="button"
                                  onClick={() => updateAddOnQuantity(addOn, 1)}
                                  className="flex items-center space-x-1 px-4 py-2 bg-summer-orange text-white rounded-xl hover:bg-summer-orange-accent transition-all duration-200 text-sm font-summer-bold shadow-lg"
                                >
                                  <Plus className="h-3 w-3" />
                                  <span>Add</span>
                                </button>
                              )}
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>
                  ))}
                </div>
              )}

              {/* Price Summary */}
              <div className="border-t border-summer-warm-gray pt-4 mb-6">
                <div className="flex items-center justify-between text-2xl font-summer-bold text-summer-dark">
                  <span>Total:</span>
                  <span className="text-summer-orange-accent">₱{calculatePrice().toFixed(2)}</span>
                </div>
              </div>

                      <button
                        onClick={handleCustomizedAddToCart}
                        className="w-full bg-summer-orange text-white py-4 rounded-xl hover:bg-summer-orange-accent transition-all duration-200 font-summer-bold flex items-center justify-center space-x-2 shadow-lg hover:shadow-xl transform hover:scale-105"
                      >
                        <ShoppingCart className="h-5 w-5" />
                        <span>Add to Cart - ₱{calculatePrice().toFixed(2)}</span>
                      </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default MenuItemCard;