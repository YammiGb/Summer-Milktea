/*
  # Clear Old Data and Ensure Correct Summer Milktea Prices
  This migration clears any old menu data and ensures only the correct
  Summer Milktea items with proper pricing exist.
*/

-- First, clear all existing menu data to start fresh
DELETE FROM add_ons;
DELETE FROM variations;
DELETE FROM menu_items;
DELETE FROM categories;

-- Re-insert the correct categories
INSERT INTO categories (id, name, icon, sort_order, active, created_at, updated_at) VALUES
  ('milktea', 'Milktea', '🧋', 1, true, now(), now()),
  ('fruit-soda', 'Fruit Soda', '🥤', 2, true, now(), now()),
  ('fruit-milk', 'Fruit Milk', '🥛', 3, true, now(), now()),
  ('ice-coffee', 'Ice Coffee', '☕', 4, true, now(), now())
ON CONFLICT (id) DO NOTHING;

-- Insert Milktea items with correct base price (Small = 49)
INSERT INTO menu_items (
  id, name, description, base_price, category, popular, available,
  image_url, discount_price, discount_start_date, discount_end_date, discount_active,
  created_at, updated_at
) VALUES
  (gen_random_uuid(), 'Okinawa', 'Classic brown sugar milk tea with chewy tapioca pearls', 49.00, 'milktea', true, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Wintermelon', 'Refreshing winter melon milk tea with a subtle sweetness', 49.00, 'milktea', true, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Cookies & Cream', 'Creamy milk tea blended with crushed cookies', 49.00, 'milktea', false, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Chocolate', 'Rich chocolate milk tea for chocolate lovers', 49.00, 'milktea', false, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Matcha', 'Premium green tea powder with creamy milk', 49.00, 'milktea', true, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Taro', 'Purple taro root milk tea with a unique earthy flavor', 49.00, 'milktea', false, true, null, null, null, null, false, now(), now())
ON CONFLICT DO NOTHING;

-- Insert Fruit Soda items with correct base price (Small = 29)
INSERT INTO menu_items (
  id, name, description, base_price, category, popular, available,
  image_url, discount_price, discount_start_date, discount_end_date, discount_active,
  created_at, updated_at
) VALUES
  (gen_random_uuid(), 'Four Season', 'Refreshing four-season fruit soda with mixed tropical flavors', 29.00, 'fruit-soda', true, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Blue Lemonade', 'Cool blue lemonade with a tangy citrus kick', 29.00, 'fruit-soda', false, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Green Apple', 'Crisp green apple soda with a refreshing taste', 29.00, 'fruit-soda', false, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Lychee', 'Sweet and fragrant lychee fruit soda', 29.00, 'fruit-soda', true, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Strawberry', 'Sweet strawberry soda bursting with berry flavor', 29.00, 'fruit-soda', true, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Blueberry', 'Rich blueberry soda with antioxidant goodness', 29.00, 'fruit-soda', false, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Lemon', 'Classic lemon soda with a zesty citrus taste', 29.00, 'fruit-soda', false, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Mango', 'Tropical mango soda with sweet summer vibes', 29.00, 'fruit-soda', true, true, null, null, null, null, false, now(), now())
ON CONFLICT DO NOTHING;

-- Insert Fruit Milk items with correct base price (Small = 49)
INSERT INTO menu_items (
  id, name, description, base_price, category, popular, available,
  image_url, discount_price, discount_start_date, discount_end_date, discount_active,
  created_at, updated_at
) VALUES
  (gen_random_uuid(), 'Strawberry', 'Creamy strawberry milk with fresh berry flavor', 49.00, 'fruit-milk', true, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Blueberry', 'Smooth blueberry milk with antioxidant benefits', 49.00, 'fruit-milk', false, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Mango', 'Tropical mango milk with sweet summer taste', 49.00, 'fruit-milk', true, true, null, null, null, null, false, now(), now())
ON CONFLICT DO NOTHING;

-- Insert Ice Coffee items with correct base price (Small = 49)
INSERT INTO menu_items (
  id, name, description, base_price, category, popular, available,
  image_url, discount_price, discount_start_date, discount_end_date, discount_active,
  created_at, updated_at
) VALUES
  (gen_random_uuid(), 'Caramel Macchiato', 'Espresso with vanilla syrup, steamed milk, and caramel drizzle', 49.00, 'ice-coffee', true, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Mocha', 'Rich chocolate and espresso blended with milk', 49.00, 'ice-coffee', true, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Salted Caramel', 'Sweet and salty caramel coffee with a smooth finish', 49.00, 'ice-coffee', false, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Spanish Latte', 'Espresso with condensed milk for a creamy sweetness', 49.00, 'ice-coffee', true, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'White Hazelnut', 'Smooth hazelnut coffee with white chocolate notes', 49.00, 'ice-coffee', false, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Butterscotch', 'Rich butterscotch coffee with a buttery sweetness', 49.00, 'ice-coffee', false, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Dark Hazelnut', 'Bold hazelnut coffee with deep roasted flavors', 49.00, 'ice-coffee', false, true, null, null, null, null, false, now(), now())
ON CONFLICT DO NOTHING;

-- Add size variations for all items
-- Milktea size variations (Small=49, Medium=59, Large=69)
INSERT INTO variations (id, menu_item_id, name, price, created_at)
SELECT
  gen_random_uuid(),
  mi.id,
  v.name,
  v.price,
  now()
FROM menu_items mi
CROSS JOIN (VALUES
  ('Small', 0),
  ('Medium', 10),
  ('Large', 20)
) AS v(name, price)
WHERE mi.category = 'milktea'
ON CONFLICT DO NOTHING;

-- Fruit Soda size variations (Small=29, Medium=39, Large=49)
INSERT INTO variations (id, menu_item_id, name, price, created_at)
SELECT
  gen_random_uuid(),
  mi.id,
  v.name,
  v.price,
  now()
FROM menu_items mi
CROSS JOIN (VALUES
  ('Small', 0),
  ('Medium', 10),
  ('Large', 20)
) AS v(name, price)
WHERE mi.category = 'fruit-soda'
ON CONFLICT DO NOTHING;

-- Fruit Milk size variations (Small=49, Medium=59, Large=69)
INSERT INTO variations (id, menu_item_id, name, price, created_at)
SELECT
  gen_random_uuid(),
  mi.id,
  v.name,
  v.price,
  now()
FROM menu_items mi
CROSS JOIN (VALUES
  ('Small', 0),
  ('Medium', 10),
  ('Large', 20)
) AS v(name, price)
WHERE mi.category = 'fruit-milk'
ON CONFLICT DO NOTHING;

-- Ice Coffee size variations (Small=49, Medium=59, Large=69)
INSERT INTO variations (id, menu_item_id, name, price, created_at)
SELECT
  gen_random_uuid(),
  mi.id,
  v.name,
  v.price,
  now()
FROM menu_items mi
CROSS JOIN (VALUES
  ('Small', 0),
  ('Medium', 10),
  ('Large', 20)
) AS v(name, price)
WHERE mi.category = 'ice-coffee'
ON CONFLICT DO NOTHING;

-- Add category_image_url column to categories table
ALTER TABLE categories ADD COLUMN IF NOT EXISTS category_image_url text;

-- Update categories with Pexels images
UPDATE categories 
SET category_image_url = CASE 
  WHEN id = 'milktea' THEN 'https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg?auto=compress&cs=tinysrgb&w=800&h=600&fit=crop'
  WHEN id = 'fruit-soda' THEN 'https://images.pexels.com/photos/1435735/pexels-photo-1435735.jpeg?auto=compress&cs=tinysrgb&w=800&h=600&fit=crop'
  WHEN id = 'fruit-milk' THEN 'https://images.pexels.com/photos/1435735/pexels-photo-1435735.jpeg?auto=compress&cs=tinysrgb&w=800&h=600&fit=crop'
  WHEN id = 'ice-coffee' THEN 'https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg?auto=compress&cs=tinysrgb&w=800&h=600&fit=crop'
  ELSE category_image_url
END,
updated_at = now()
WHERE id IN ('milktea', 'fruit-soda', 'fruit-milk', 'ice-coffee');

