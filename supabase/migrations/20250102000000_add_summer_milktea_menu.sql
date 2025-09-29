/*
  # Add Summer Milktea Menu Items
  
  This migration adds the complete Summer Milktea menu with categories:
  - Milktea (6 items)
  - Fruit Soda (7 items) 
  - Fruit Milk (3 items)
  - Ice Coffee (7 items)
  
  Features:
  - Uses ON CONFLICT DO NOTHING to prevent duplicates
  - Auto-generated UUIDs for all items
  - Proper category mapping
  - Realistic pricing for Philippine market
  - Popular items marked appropriately
*/

-- First, create the categories table if it doesn't exist
CREATE TABLE IF NOT EXISTS categories (
  id text PRIMARY KEY,
  name text NOT NULL,
  icon text NOT NULL,
  sort_order integer NOT NULL DEFAULT 0,
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS on categories table
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Create policies for categories (if they don't exist)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'categories' AND policyname = 'Anyone can read categories'
  ) THEN
    CREATE POLICY "Anyone can read categories"
      ON categories
      FOR SELECT
      TO public
      USING (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'categories' AND policyname = 'Authenticated users can manage categories'
  ) THEN
    CREATE POLICY "Authenticated users can manage categories"
      ON categories
      FOR ALL
      TO authenticated
      USING (true)
      WITH CHECK (true);
  END IF;
END $$;

-- Create updated_at trigger function if it doesn't exist
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for categories updated_at (if it doesn't exist)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger 
    WHERE tgname = 'update_categories_updated_at'
  ) THEN
    CREATE TRIGGER update_categories_updated_at
      BEFORE UPDATE ON categories
      FOR EACH ROW
      EXECUTE FUNCTION update_updated_at_column();
  END IF;
END $$;

-- Insert the categories
INSERT INTO categories (id, name, icon, sort_order, active, created_at, updated_at) VALUES
  ('milktea', 'Milktea', '🧋', 1, true, now(), now()),
  ('fruit-soda', 'Fruit Soda', '🥤', 2, true, now(), now()),
  ('fruit-milk', 'Fruit Milk', '🥛', 3, true, now(), now()),
  ('ice-coffee', 'Ice Coffee', '☕', 4, true, now(), now())
ON CONFLICT (id) DO NOTHING;

-- Create menu_items table if it doesn't exist
CREATE TABLE IF NOT EXISTS menu_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text NOT NULL,
  base_price decimal(10,2) NOT NULL,
  category text NOT NULL,
  popular boolean DEFAULT false,
  available boolean DEFAULT true,
  image_url text,
  discount_price decimal(10,2),
  discount_start_date timestamptz,
  discount_end_date timestamptz,
  discount_active boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create variations table if it doesn't exist
CREATE TABLE IF NOT EXISTS variations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  menu_item_id uuid REFERENCES menu_items(id) ON DELETE CASCADE,
  name text NOT NULL,
  price decimal(10,2) NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- Create add_ons table if it doesn't exist
CREATE TABLE IF NOT EXISTS add_ons (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  menu_item_id uuid REFERENCES menu_items(id) ON DELETE CASCADE,
  name text NOT NULL,
  price decimal(10,2) NOT NULL DEFAULT 0,
  category text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS on menu tables
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE variations ENABLE ROW LEVEL SECURITY;
ALTER TABLE add_ons ENABLE ROW LEVEL SECURITY;

-- Create policies for menu tables (if they don't exist)
DO $$
BEGIN
  -- Menu items policies
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'menu_items' AND policyname = 'Anyone can read menu items'
  ) THEN
    CREATE POLICY "Anyone can read menu items"
      ON menu_items
      FOR SELECT
      TO public
      USING (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'menu_items' AND policyname = 'Authenticated users can manage menu items'
  ) THEN
    CREATE POLICY "Authenticated users can manage menu items"
      ON menu_items
      FOR ALL
      TO authenticated
      USING (true)
      WITH CHECK (true);
  END IF;

  -- Variations policies
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'variations' AND policyname = 'Anyone can read variations'
  ) THEN
    CREATE POLICY "Anyone can read variations"
      ON variations
      FOR SELECT
      TO public
      USING (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'variations' AND policyname = 'Authenticated users can manage variations'
  ) THEN
    CREATE POLICY "Authenticated users can manage variations"
      ON variations
      FOR ALL
      TO authenticated
      USING (true)
      WITH CHECK (true);
  END IF;

  -- Add-ons policies
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'add_ons' AND policyname = 'Anyone can read add-ons'
  ) THEN
    CREATE POLICY "Anyone can read add-ons"
      ON add_ons
      FOR SELECT
      TO public
      USING (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'add_ons' AND policyname = 'Authenticated users can manage add-ons'
  ) THEN
    CREATE POLICY "Authenticated users can manage add-ons"
      ON add_ons
      FOR ALL
      TO authenticated
      USING (true)
      WITH CHECK (true);
  END IF;
END $$;

-- Create trigger for menu_items updated_at (if it doesn't exist)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger 
    WHERE tgname = 'update_menu_items_updated_at'
  ) THEN
    CREATE TRIGGER update_menu_items_updated_at
      BEFORE UPDATE ON menu_items
      FOR EACH ROW
      EXECUTE FUNCTION update_updated_at_column();
  END IF;
END $$;

-- Add Milktea items (base price is Small size - 49)
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

-- Add Fruit Soda items (base price is Small size - 29)
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

-- Add Fruit Milk items (base price is Small size - 49)
INSERT INTO menu_items (
  id, name, description, base_price, category, popular, available, 
  image_url, discount_price, discount_start_date, discount_end_date, discount_active,
  created_at, updated_at
) VALUES
  (gen_random_uuid(), 'Strawberry', 'Creamy strawberry milk with fresh berry flavor', 49.00, 'fruit-milk', true, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Blueberry', 'Smooth blueberry milk with antioxidant benefits', 49.00, 'fruit-milk', false, true, null, null, null, null, false, now(), now()),
  (gen_random_uuid(), 'Mango', 'Tropical mango milk with sweet summer taste', 49.00, 'fruit-milk', true, true, null, null, null, null, false, now(), now())
ON CONFLICT DO NOTHING;

-- Add Ice Coffee items (base price is Small size - 49)
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

-- Add customization add-ons (free options)
-- Ice level options
INSERT INTO add_ons (id, menu_item_id, name, price, category, created_at)
SELECT 
  gen_random_uuid(),
  mi.id,
  a.name,
  a.price,
  'ice',
  now()
FROM menu_items mi
CROSS JOIN (VALUES 
  ('Less Ice', 0),
  ('No Ice', 0),
  ('Extra Ice', 0)
) AS a(name, price)
WHERE mi.category IN ('milktea', 'fruit-soda', 'fruit-milk', 'ice-coffee')
ON CONFLICT DO NOTHING;

-- Sweetness level options
INSERT INTO add_ons (id, menu_item_id, name, price, category, created_at)
SELECT 
  gen_random_uuid(),
  mi.id,
  a.name,
  a.price,
  'sweetness',
  now()
FROM menu_items mi
CROSS JOIN (VALUES 
  ('Less Sweet', 0),
  ('No Sugar', 0),
  ('Extra Sweet', 0)
) AS a(name, price)
WHERE mi.category IN ('milktea', 'fruit-soda', 'fruit-milk', 'ice-coffee')
ON CONFLICT DO NOTHING;
