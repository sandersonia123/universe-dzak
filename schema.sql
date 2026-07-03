-- ============================================
-- universe-of-dzak Supabase Schema
-- 在 Supabase SQL Editor 中运行此脚本
-- ============================================

-- 1. 图像表
CREATE TABLE IF NOT EXISTS images (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL DEFAULT 'spring',
  keywords TEXT[] DEFAULT '{}',
  data_url TEXT NOT NULL,
  time TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE images ENABLE ROW LEVEL SECURITY;

CREATE POLICY "所有人可查看图像" ON images FOR SELECT USING (true);
CREATE POLICY "开发者可上传图像" ON images FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "开发者可删除图像" ON images FOR DELETE USING (auth.role() = 'authenticated');

-- 2. 小说表
CREATE TABLE IF NOT EXISTS novels (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  time TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE novels ENABLE ROW LEVEL SECURITY;

CREATE POLICY "所有人可查看小说" ON novels FOR SELECT USING (true);
CREATE POLICY "开发者可上传小说" ON novels FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "开发者可删除小说" ON novels FOR DELETE USING (auth.role() = 'authenticated');

-- 3. 冷知识表
CREATE TABLE IF NOT EXISTS trivia_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  text TEXT NOT NULL,
  time TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE trivia_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "所有人可查看冷知识" ON trivia_items FOR SELECT USING (true);
CREATE POLICY "开发者可添加冷知识" ON trivia_items FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "开发者可编辑冷知识" ON trivia_items FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "开发者可删除冷知识" ON trivia_items FOR DELETE USING (auth.role() = 'authenticated');

-- 4. 留言表（所有页面共用）
CREATE TABLE IF NOT EXISTS comments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  page TEXT NOT NULL,   -- 'home' | 'images' | 'novels' | 'trivia'
  user_name TEXT NOT NULL DEFAULT '匿名',
  text TEXT NOT NULL,
  time TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "所有人可查看留言" ON comments FOR SELECT USING (true);
CREATE POLICY "所有人可发布留言" ON comments FOR INSERT WITH CHECK (true);

-- 5. 索引
CREATE INDEX IF NOT EXISTS idx_comments_page ON comments(page);
CREATE INDEX IF NOT EXISTS idx_images_category ON images(category);
CREATE INDEX IF NOT EXISTS idx_images_name ON images(name);
