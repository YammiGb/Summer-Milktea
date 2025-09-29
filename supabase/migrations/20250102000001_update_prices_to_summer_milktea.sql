/*
  # Update Prices to Summer Milktea Structure
  
  This migration updates existing menu items to use the correct Summer Milktea pricing:
  - Milktea: Small ₱49, Medium ₱59, Large ₱69
  - Fruit Soda: Small ₱29, Medium ₱39, Large ₱49  
  - Fruit Milk: Small ₱49, Medium ₱59, Large ₱69
  - Ice Coffee: Small ₱49, Medium ₱59, Large ₱69
*/

-- Update Milktea items to Medium price (₱59) - use base price directly
UPDATE menu_items 
SET base_price = 59.00
WHERE category = 'milktea';

-- Update Fruit Soda items to Medium price (₱39) - use base price directly
UPDATE menu_items 
SET base_price = 39.00
WHERE category = 'fruit-soda';

-- Update Fruit Milk items to Medium price (₱59) - use base price directly
UPDATE menu_items 
SET base_price = 59.00
WHERE category = 'fruit-milk';

-- Update Ice Coffee items to Medium price (₱59) - use base price directly
UPDATE menu_items 
SET base_price = 59.00
WHERE category = 'ice-coffee';

-- Update size variations for Milktea (Small=-10, Medium=0, Large=+10)
-- Since base price is now Medium (₱59), Small=₱49, Large=₱69
UPDATE variations 
SET price = CASE 
  WHEN name = 'Small' THEN -10
  WHEN name = 'Medium' THEN 0
  WHEN name = 'Large' THEN 10
  ELSE price
END
WHERE menu_item_id IN (
  SELECT id FROM menu_items WHERE category = 'milktea'
);

-- Update size variations for Fruit Soda (Small=-10, Medium=0, Large=+10)
-- Since base price is now Medium (₱39), Small=₱29, Large=₱49
UPDATE variations 
SET price = CASE 
  WHEN name = 'Small' THEN -10
  WHEN name = 'Medium' THEN 0
  WHEN name = 'Large' THEN 10
  ELSE price
END
WHERE menu_item_id IN (
  SELECT id FROM menu_items WHERE category = 'fruit-soda'
);

-- Update size variations for Fruit Milk (Small=-10, Medium=0, Large=+10)
-- Since base price is now Medium (₱59), Small=₱49, Large=₱69
UPDATE variations 
SET price = CASE 
  WHEN name = 'Small' THEN -10
  WHEN name = 'Medium' THEN 0
  WHEN name = 'Large' THEN 10
  ELSE price
END
WHERE menu_item_id IN (
  SELECT id FROM menu_items WHERE category = 'fruit-milk'
);

-- Update size variations for Ice Coffee (Small=-10, Medium=0, Large=+10)
-- Since base price is now Medium (₱59), Small=₱49, Large=₱69
UPDATE variations 
SET price = CASE 
  WHEN name = 'Small' THEN -10
  WHEN name = 'Medium' THEN 0
  WHEN name = 'Large' THEN 10
  ELSE price
END
WHERE menu_item_id IN (
  SELECT id FROM menu_items WHERE category = 'ice-coffee'
);

-- Clear any old expensive add-ons and keep only free customization options
DELETE FROM add_ons 
WHERE price > 0 
AND category IN ('extras', 'protein', 'sauce');

-- Ensure all remaining add-ons are free
UPDATE add_ons 
SET price = 0 
WHERE category IN ('ice', 'sweetness');
