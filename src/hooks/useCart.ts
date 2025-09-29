import { useState, useCallback } from 'react';
import { CartItem, MenuItem, Variation, AddOn } from '../types';
import { useToast } from '../contexts/ToastContext';

export const useCart = () => {
  const [cartItems, setCartItems] = useState<CartItem[]>([]);
  const [isCartOpen, setIsCartOpen] = useState(false);
  const { showToast } = useToast();

  const calculateItemPrice = (item: MenuItem, variation?: Variation, addOns?: AddOn[]) => {
    let price = item.basePrice;
    if (variation) {
      price += variation.price;
    }
    if (addOns) {
      addOns.forEach(addOn => {
        price += addOn.price;
      });
    }
    return price;
  };

  const addToCart = useCallback((item: MenuItem, quantity: number = 1, variation?: Variation, addOns?: AddOn[]) => {
    const totalPrice = calculateItemPrice(item, variation, addOns);
    
    // Group add-ons by name and sum their quantities
    const groupedAddOns = addOns?.reduce((groups, addOn) => {
      const existing = groups.find(g => g.id === addOn.id);
      if (existing) {
        existing.quantity = (existing.quantity || 1) + 1;
      } else {
        groups.push({ ...addOn, quantity: 1 });
      }
      return groups;
    }, [] as (AddOn & { quantity: number })[]);
    
    setCartItems(prev => {
      const existingItem = prev.find(cartItem => 
        cartItem.id === item.id && 
        cartItem.selectedVariation?.id === variation?.id &&
        JSON.stringify(cartItem.selectedAddOns?.map(a => `${a.id}-${a.quantity || 1}`).sort()) === JSON.stringify(groupedAddOns?.map(a => `${a.id}-${a.quantity}`).sort())
      );
      
      if (existingItem) {
        const newQuantity = existingItem.quantity + quantity;
        showToast(`${item.name} quantity updated to ${newQuantity}`, 'success');
        return prev.map(cartItem =>
          cartItem === existingItem
            ? { ...cartItem, quantity: newQuantity }
            : cartItem
        );
      } else {
        const uniqueId = `${item.id}-${variation?.id || 'default'}-${addOns?.map(a => a.id).join(',') || 'none'}`;
        showToast(`${item.name} added to cart`, 'success');
        return [...prev, { 
          ...item,
          id: uniqueId,
          quantity,
          selectedVariation: variation,
          selectedAddOns: groupedAddOns || [],
          totalPrice
        }];
      }
    });
  }, [showToast]);

  const updateQuantity = useCallback((id: string, quantity: number) => {
    if (quantity <= 0) {
      removeFromCart(id);
      return;
    }
    
    setCartItems(prev => {
      const item = prev.find(item => item.id === id);
      if (item) {
        showToast(`${item.name} quantity updated to ${quantity}`, 'success');
      }
      return prev.map(item =>
        item.id === id ? { ...item, quantity } : item
      );
    });
  }, [showToast]);

  const removeFromCart = useCallback((id: string) => {
    setCartItems(prev => {
      const item = prev.find(item => item.id === id);
      if (item) {
        showToast(`${item.name} removed from cart`, 'success');
      }
      return prev.filter(item => item.id !== id);
    });
  }, [showToast]);

  const clearCart = useCallback(() => {
    setCartItems([]);
    showToast('Cart cleared', 'success');
  }, [showToast]);

  const getTotalPrice = useCallback(() => {
    return cartItems.reduce((total, item) => total + (item.totalPrice * item.quantity), 0);
  }, [cartItems]);

  const getTotalItems = useCallback(() => {
    const total = cartItems.reduce((total, item) => total + item.quantity, 0);
    console.log('Cart items:', cartItems.length, 'Total quantity:', total);
    return total;
  }, [cartItems]);

  const openCart = useCallback(() => setIsCartOpen(true), []);
  const closeCart = useCallback(() => setIsCartOpen(false), []);

  return {
    cartItems,
    isCartOpen,
    addToCart,
    updateQuantity,
    removeFromCart,
    clearCart,
    getTotalPrice,
    getTotalItems,
    openCart,
    closeCart
  };
};