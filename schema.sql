-- Create tables

CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  username TEXT UNIQUE NOT NULL,
  full_name TEXT,
  bio TEXT,
  avatar_url TEXT,
  interests TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS tasks (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES profiles ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  category TEXT,
  priority TEXT CHECK (priority IN ('low', 'medium', 'high')),
  status TEXT CHECK (status IN ('pending', 'in_progress', 'done')) DEFAULT 'pending',
  due_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS pomodoro_sessions (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES profiles ON DELETE CASCADE,
  work_duration INT DEFAULT 25,
  break_duration INT DEFAULT 5,
  completed_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ai_conversations (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES profiles ON DELETE CASCADE,
  title TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ai_messages (
  id UUID PRIMARY KEY,
  conversation_id UUID REFERENCES ai_conversations ON DELETE CASCADE,
  role TEXT CHECK (role IN ('user', 'assistant')),
  content TEXT NOT NULL,
  bookmarked BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS saved_resources (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES profiles ON DELETE CASCADE,
  title TEXT NOT NULL,
  url TEXT NOT NULL,
  type TEXT CHECK (type IN ('video', 'article', 'document')),
  level TEXT CHECK (level IN ('beginner', 'intermediate', 'advanced')),
  thumbnail_url TEXT,
  saved_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS friendships (
  id UUID PRIMARY KEY,
  requester_id UUID REFERENCES profiles ON DELETE CASCADE,
  addressee_id UUID REFERENCES profiles ON DELETE CASCADE,
  status TEXT CHECK (status IN ('pending', 'accepted', 'blocked')) DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(requester_id, addressee_id)
);

CREATE TABLE IF NOT EXISTS conversations (
  id UUID PRIMARY KEY,
  is_group BOOLEAN DEFAULT FALSE,
  name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS conversation_members (
  conversation_id UUID REFERENCES conversations ON DELETE CASCADE,
  user_id UUID REFERENCES profiles ON DELETE CASCADE,
  PRIMARY KEY (conversation_id, user_id)
);

CREATE TABLE IF NOT EXISTS messages (
  id UUID PRIMARY KEY,
  conversation_id UUID REFERENCES conversations ON DELETE CASCADE,
  sender_id UUID REFERENCES profiles ON DELETE CASCADE,
  content TEXT NOT NULL,
  sent_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS study_rooms (
  id UUID PRIMARY KEY,
  host_id UUID REFERENCES profiles ON DELETE CASCADE,
  name TEXT NOT NULL,
  topic TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  max_participants INT DEFAULT 10,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS room_participants (
  room_id UUID REFERENCES study_rooms ON DELETE CASCADE,
  user_id UUID REFERENCES profiles ON DELETE CASCADE,
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (room_id, user_id)
);

CREATE TABLE IF NOT EXISTS posts (
  id UUID PRIMARY KEY,
  author_id UUID REFERENCES profiles ON DELETE CASCADE,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  type TEXT CHECK (type IN ('article', 'note', 'video')),
  tags TEXT[],
  category TEXT,
  published BOOLEAN DEFAULT FALSE,
  views INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS post_bookmarks (
  user_id UUID REFERENCES profiles ON DELETE CASCADE,
  post_id UUID REFERENCES posts ON DELETE CASCADE,
  PRIMARY KEY (user_id, post_id)
);

-- Note: RLS needs schema level altering and policies correctly applied.
-- First, enable RLS for all newly created tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE pomodoro_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE saved_resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE friendships ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversation_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE study_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE room_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_bookmarks ENABLE ROW LEVEL SECURITY;


-- 1. Profiles: SELECT for everyone, INSERT/UPDATE for own row only
CREATE POLICY "Public profiles are visible to everyone" ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can insert their own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

-- 2. Tasks: All operations for own rows only
CREATE POLICY "Users do all operations on own tasks" ON tasks FOR ALL USING (auth.uid() = user_id);

-- 3. Pomodoro Sessions: all operations for own rows only
CREATE POLICY "Users do all operations on own pomodoro sessions" ON pomodoro_sessions FOR ALL USING (auth.uid() = user_id);

-- 4. AI Conversations: all operations for own rows only
CREATE POLICY "Users do all operations on own ai conversations" ON ai_conversations FOR ALL USING (auth.uid() = user_id);

-- 5. AI Messages: all operations for own rows only (based on conversation_id relation)
-- Supabase joins require specialized nested checks or defining policies differently.
-- Simplification since nested joins via policies can be tricky. Here's a clean way:
CREATE POLICY "Users do all operations on ai messages of own conversations" ON ai_messages FOR ALL USING (
  conversation_id IN (SELECT id FROM ai_conversations WHERE user_id = auth.uid())
);

-- 6. Saved Resources: all operations for own rows only
CREATE POLICY "Users do all operations on own saved resources" ON saved_resources FOR ALL USING (auth.uid() = user_id);

-- 7. Friendships: SELECT/INSERT/DELETE where auth.uid() = requester_id OR addressee_id
CREATE POLICY "Users manage own friendships" ON friendships FOR ALL USING (auth.uid() = requester_id OR auth.uid() = addressee_id);

-- 8. Conversations + Messages: SELECT/INSERT for members only
CREATE POLICY "Users participate in member conversations" ON conversations FOR ALL USING (
  id IN (SELECT conversation_id FROM conversation_members WHERE user_id = auth.uid())
);
CREATE POLICY "Users send/read messages in member conversations" ON messages FOR ALL USING (
  conversation_id IN (SELECT conversation_id FROM conversation_members WHERE user_id = auth.uid())
);

-- 9. Study Rooms: SELECT for all, INSERT/UPDATE/DELETE for host only
CREATE POLICY "Study rooms are viewable by everyone" ON study_rooms FOR SELECT USING (true);
CREATE POLICY "Hosts can manage their study rooms" ON study_rooms FOR ALL USING (auth.uid() = host_id);

-- 10. Room Participants: SELECT for all, INSERT/DELETE for own row
CREATE POLICY "Participants are viewable to all" ON room_participants FOR SELECT USING (true);
CREATE POLICY "Users manage their own participation" ON room_participants FOR ALL USING (auth.uid() = user_id);

-- 11. Posts: SELECT for published=true for all, all operations for own rows
CREATE POLICY "Published posts visible to everyone" ON posts FOR SELECT USING (published = true);
CREATE POLICY "Authors full access to own posts" ON posts FOR ALL USING (auth.uid() = author_id);

-- 12. Post Bookmarks: all operations for own rows
CREATE POLICY "Users can do all operations with own post bookmarks" ON post_bookmarks FOR ALL USING (auth.uid() = user_id);


-- Supabase Trigger: Auto-insert into profiles on new user
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, username, full_name, avatar_url)
  VALUES (
    new.id,
    -- Extract raw email split by '@' as default username, and add a random suffix to ensure uniqueness
    split_part(new.email, '@', 1) || '_' || substr(md5(random()::text), 1, 6),
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'avatar_url'
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
