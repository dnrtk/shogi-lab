-- 将棋ラボ：学習記録テーブル
-- Supabase ダッシュボード → SQL Editor に貼り付けて実行する。

create table if not exists public.progress (
  user_id    uuid        not null default auth.uid() references auth.users(id) on delete cascade,
  key        text        not null,          -- 例: 'c9:37'（章ID:ページ番号）
  value      bigint      not null,          -- 解答日時(ms) または既読フラグ 1
  updated_at timestamptz not null default now(),
  primary key (user_id, key)
);

alter table public.progress enable row level security;

drop policy if exists "progress: own rows select" on public.progress;
drop policy if exists "progress: own rows insert" on public.progress;
drop policy if exists "progress: own rows update" on public.progress;
drop policy if exists "progress: own rows delete" on public.progress;

create policy "progress: own rows select" on public.progress for select to authenticated using (auth.uid() = user_id);
create policy "progress: own rows insert" on public.progress for insert to authenticated with check (auth.uid() = user_id);
create policy "progress: own rows update" on public.progress for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "progress: own rows delete" on public.progress for delete to authenticated using (auth.uid() = user_id);
