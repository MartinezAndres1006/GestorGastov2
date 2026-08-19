-- ============================================================================
-- GESTOR FINANCIERO PERSONAL - ESQUEMA SUPABASE POSTGRESQL + RLS (V2)
-- ============================================================================
-- Instrucciones:
-- 1. Ve a tu proyecto en Supabase (https://supabase.com/dashboard).
-- 2. Entra en "SQL Editor" en el menú lateral izquierdo.
-- 3. Crea una "New Query", pega todo este contenido y presiona "RUN".
-- ============================================================================

-- Habilitar extensión UUID
create extension if not exists "uuid-ossp";

-- ============================================================================
-- 1. TABLA: PROFILES (Perfiles de Usuario vinculados a Supabase Auth)
-- ============================================================================
create table if not exists public.profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  email text not null,
  full_name text,
  created_at timestamptz default timezone('utc'::text, now()) not null,
  updated_at timestamptz default timezone('utc'::text, now()) not null
);

-- Trigger para crear automáticamente el perfil al registrarse un nuevo usuario
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, full_name, created_at, updated_at)
  values (new.id, new.email, coalesce(new.raw_user_meta_data->>'full_name', ''), now(), now())
  on conflict (id) do nothing;
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ============================================================================
-- 2. TABLA: ACCOUNTS (Cuentas Bancarias, Billeteras, Efectivo, USD)
-- ============================================================================
create table if not exists public.accounts (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  type text not null, -- 'bank', 'wallet', 'cash', 'usd', 'other'
  currency text not null default 'ARS', -- 'ARS', 'USD'
  initial_balance numeric not null default 0,
  icon text default '🏦',
  color text default '#3b82f6',
  is_active boolean default true not null,
  created_at timestamptz default timezone('utc'::text, now()) not null,
  updated_at timestamptz default timezone('utc'::text, now()) not null
);

-- ============================================================================
-- 3. TABLA: CATEGORIES (Categorías de Gastos e Ingresos)
-- ============================================================================
create table if not exists public.categories (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  icon text default '🏷️',
  color text default '#6366f1',
  type text not null, -- 'expense', 'income'
  is_custom boolean default true not null,
  created_at timestamptz default timezone('utc'::text, now()) not null,
  updated_at timestamptz default timezone('utc'::text, now()) not null
);

-- ============================================================================
-- 4. TABLA: CREDIT_CARDS (Tarjetas de Crédito)
-- ============================================================================
create table if not exists public.credit_cards (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  issuer text not null,
  card_limit numeric not null default 0,
  currency text not null default 'ARS',
  closing_day integer not null check (closing_day between 1 and 31),
  due_day integer not null check (due_day between 1 and 31),
  is_active boolean default true not null,
  created_at timestamptz default timezone('utc'::text, now()) not null,
  updated_at timestamptz default timezone('utc'::text, now()) not null
);

-- ============================================================================
-- 5. TABLA: CARD_PURCHASES (Compras con Tarjeta en Cuotas)
-- ============================================================================
create table if not exists public.card_purchases (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  card_id text not null,
  description text not null,
  total_amount numeric not null,
  currency text not null default 'ARS',
  total_installments integer not null default 1 check (total_installments >= 1),
  installment_amount numeric not null,
  first_due_date text not null,
  status text not null default 'active', -- 'active', 'paid'
  created_at timestamptz default timezone('utc'::text, now()) not null,
  updated_at timestamptz default timezone('utc'::text, now()) not null
);

-- ============================================================================
-- 6. TABLA: LOANS (Préstamos y Deudas)
-- ============================================================================
create table if not exists public.loans (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  entity text not null,
  initial_amount numeric not null,
  currency text not null default 'ARS',
  total_installments integer not null default 1,
  paid_installments integer not null default 0,
  installment_amount numeric not null,
  interest_rate numeric default 0,
  start_date text,
  due_date text,
  frequency text default 'monthly',
  account_id text,
  notes text,
  status text default 'active',
  created_at timestamptz default timezone('utc'::text, now()) not null,
  updated_at timestamptz default timezone('utc'::text, now()) not null
);

-- ============================================================================
-- 7. TABLA: TRANSACTIONS (Movimientos: Gastos, Ingresos, Transferencias, Pagos)
-- ============================================================================
create table if not exists public.transactions (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  type text not null, -- 'expense', 'income', 'transfer', 'card_payment', 'loan_payment', 'card_purchase'
  amount numeric not null check (amount > 0),
  currency text not null default 'ARS',
  description text not null,
  category_id text,
  account_id text,
  to_account_id text,
  card_purchase_id text,
  loan_id text,
  date text not null, -- 'YYYY-MM-DD'
  notes text,
  is_recurring boolean default false,
  recurring_id text,
  is_fixed boolean default false,
  created_at timestamptz default timezone('utc'::text, now()) not null,
  updated_at timestamptz default timezone('utc'::text, now()) not null
);

-- ============================================================================
-- 8. TABLA: BUDGETS (Presupuestos Mensuales por Categoría)
-- ============================================================================
create table if not exists public.budgets (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  category_id text not null,
  month text not null, -- 'YYYY-MM'
  amount numeric not null check (amount >= 0),
  currency text not null default 'ARS',
  created_at timestamptz default timezone('utc'::text, now()) not null,
  updated_at timestamptz default timezone('utc'::text, now()) not null
);

-- ============================================================================
-- 9. TABLA: FINANCIAL_GOALS (Objetivos de Ahorro)
-- ============================================================================
create table if not exists public.financial_goals (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  target_amount numeric not null check (target_amount > 0),
  current_amount numeric not null default 0 check (current_amount >= 0),
  currency text not null default 'ARS',
  target_date text,
  description text,
  category text,
  status text default 'in_progress', -- 'in_progress', 'completed', 'paused'
  created_at timestamptz default timezone('utc'::text, now()) not null,
  updated_at timestamptz default timezone('utc'::text, now()) not null
);

-- ============================================================================
-- 10. TABLA: RECURRING_TRANSACTIONS (Gastos/Ingresos Recurrentes Fijos)
-- ============================================================================
create table if not exists public.recurring_transactions (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  type text not null default 'expense',
  amount numeric not null check (amount > 0),
  currency text not null default 'ARS',
  category_id text,
  account_id text,
  frequency text default 'monthly',
  day_of_month integer not null check (day_of_month between 1 and 31),
  start_date text,
  end_date text,
  is_active boolean default true not null,
  last_generated_date text,
  created_at timestamptz default timezone('utc'::text, now()) not null,
  updated_at timestamptz default timezone('utc'::text, now()) not null
);

-- ============================================================================
-- 11. TABLA: USER_SETTINGS (Ajustes de Usuario: Tipo de Cambio, etc.)
-- ============================================================================
create table if not exists public.user_settings (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  key text not null,
  value text not null,
  created_at timestamptz default timezone('utc'::text, now()) not null,
  updated_at timestamptz default timezone('utc'::text, now()) not null,
  unique (user_id, key)
);

-- ============================================================================
-- ÍNDICES DE RENDIMIENTO
-- ============================================================================
create index if not exists idx_accounts_user on public.accounts(user_id);
create index if not exists idx_categories_user on public.categories(user_id);
create index if not exists idx_transactions_user_date on public.transactions(user_id, date desc);
create index if not exists idx_transactions_user_type on public.transactions(user_id, type);
create index if not exists idx_credit_cards_user on public.credit_cards(user_id);
create index if not exists idx_card_purchases_user on public.card_purchases(user_id);
create index if not exists idx_loans_user on public.loans(user_id);
create index if not exists idx_budgets_user_month on public.budgets(user_id, month);
create index if not exists idx_goals_user on public.financial_goals(user_id);
create index if not exists idx_recurring_user on public.recurring_transactions(user_id);
create index if not exists idx_settings_user on public.user_settings(user_id);

-- ============================================================================
-- TRIGGER PARA ACTUALIZAR AUTOMÁTICAMENTE `updated_at`
-- ============================================================================
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = timezone('utc'::text, now());
  return new;
end;
$$ language plpgsql;

drop trigger if exists trigger_profiles_updated_at on public.profiles;
create trigger trigger_profiles_updated_at before update on public.profiles for each row execute procedure public.set_updated_at();

drop trigger if exists trigger_accounts_updated_at on public.accounts;
create trigger trigger_accounts_updated_at before update on public.accounts for each row execute procedure public.set_updated_at();

drop trigger if exists trigger_categories_updated_at on public.categories;
create trigger trigger_categories_updated_at before update on public.categories for each row execute procedure public.set_updated_at();

drop trigger if exists trigger_credit_cards_updated_at on public.credit_cards;
create trigger trigger_credit_cards_updated_at before update on public.credit_cards for each row execute procedure public.set_updated_at();

drop trigger if exists trigger_card_purchases_updated_at on public.card_purchases;
create trigger trigger_card_purchases_updated_at before update on public.card_purchases for each row execute procedure public.set_updated_at();

drop trigger if exists trigger_loans_updated_at on public.loans;
create trigger trigger_loans_updated_at before update on public.loans for each row execute procedure public.set_updated_at();

drop trigger if exists trigger_transactions_updated_at on public.transactions;
create trigger trigger_transactions_updated_at before update on public.transactions for each row execute procedure public.set_updated_at();

drop trigger if exists trigger_budgets_updated_at on public.budgets;
create trigger trigger_budgets_updated_at before update on public.budgets for each row execute procedure public.set_updated_at();

drop trigger if exists trigger_goals_updated_at on public.financial_goals;
create trigger trigger_goals_updated_at before update on public.financial_goals for each row execute procedure public.set_updated_at();

drop trigger if exists trigger_recurring_updated_at on public.recurring_transactions;
create trigger trigger_recurring_updated_at before update on public.recurring_transactions for each row execute procedure public.set_updated_at();

drop trigger if exists trigger_settings_updated_at on public.user_settings;
create trigger trigger_settings_updated_at before update on public.user_settings for each row execute procedure public.set_updated_at();

-- ============================================================================
-- HABILITAR ROW LEVEL SECURITY (RLS) EN TODAS LAS TABLAS
-- ============================================================================
alter table public.profiles enable row level security;
alter table public.accounts enable row level security;
alter table public.categories enable row level security;
alter table public.credit_cards enable row level security;
alter table public.card_purchases enable row level security;
alter table public.loans enable row level security;
alter table public.transactions enable row level security;
alter table public.budgets enable row level security;
alter table public.financial_goals enable row level security;
alter table public.recurring_transactions enable row level security;
alter table public.user_settings enable row level security;

-- ============================================================================
-- POLÍTICAS RLS (AISLAMIENTO TOTAL: CADA USUARIO SOLO ACCEDE A SUS DATOS)
-- ============================================================================

-- 1. Profiles
create policy "profiles_select_own" on public.profiles for select using (auth.uid() = id);
create policy "profiles_update_own" on public.profiles for update using (auth.uid() = id);
create policy "profiles_insert_own" on public.profiles for insert with check (auth.uid() = id);
create policy "profiles_delete_own" on public.profiles for delete using (auth.uid() = id);

-- 2. Accounts
create policy "accounts_select_own" on public.accounts for select using (auth.uid() = user_id);
create policy "accounts_insert_own" on public.accounts for insert with check (auth.uid() = user_id);
create policy "accounts_update_own" on public.accounts for update using (auth.uid() = user_id);
create policy "accounts_delete_own" on public.accounts for delete using (auth.uid() = user_id);

-- 3. Categories
create policy "categories_select_own" on public.categories for select using (auth.uid() = user_id);
create policy "categories_insert_own" on public.categories for insert with check (auth.uid() = user_id);
create policy "categories_update_own" on public.categories for update using (auth.uid() = user_id);
create policy "categories_delete_own" on public.categories for delete using (auth.uid() = user_id);

-- 4. Credit Cards
create policy "credit_cards_select_own" on public.credit_cards for select using (auth.uid() = user_id);
create policy "credit_cards_insert_own" on public.credit_cards for insert with check (auth.uid() = user_id);
create policy "credit_cards_update_own" on public.credit_cards for update using (auth.uid() = user_id);
create policy "credit_cards_delete_own" on public.credit_cards for delete using (auth.uid() = user_id);

-- 5. Card Purchases
create policy "card_purchases_select_own" on public.card_purchases for select using (auth.uid() = user_id);
create policy "card_purchases_insert_own" on public.card_purchases for insert with check (auth.uid() = user_id);
create policy "card_purchases_update_own" on public.card_purchases for update using (auth.uid() = user_id);
create policy "card_purchases_delete_own" on public.card_purchases for delete using (auth.uid() = user_id);

-- 6. Loans
create policy "loans_select_own" on public.loans for select using (auth.uid() = user_id);
create policy "loans_insert_own" on public.loans for insert with check (auth.uid() = user_id);
create policy "loans_update_own" on public.loans for update using (auth.uid() = user_id);
create policy "loans_delete_own" on public.loans for delete using (auth.uid() = user_id);

-- 7. Transactions
create policy "transactions_select_own" on public.transactions for select using (auth.uid() = user_id);
create policy "transactions_insert_own" on public.transactions for insert with check (auth.uid() = user_id);
create policy "transactions_update_own" on public.transactions for update using (auth.uid() = user_id);
create policy "transactions_delete_own" on public.transactions for delete using (auth.uid() = user_id);

-- 8. Budgets
create policy "budgets_select_own" on public.budgets for select using (auth.uid() = user_id);
create policy "budgets_insert_own" on public.budgets for insert with check (auth.uid() = user_id);
create policy "budgets_update_own" on public.budgets for update using (auth.uid() = user_id);
create policy "budgets_delete_own" on public.budgets for delete using (auth.uid() = user_id);

-- 9. Financial Goals
create policy "goals_select_own" on public.financial_goals for select using (auth.uid() = user_id);
create policy "goals_insert_own" on public.financial_goals for insert with check (auth.uid() = user_id);
create policy "goals_update_own" on public.financial_goals for update using (auth.uid() = user_id);
create policy "goals_delete_own" on public.financial_goals for delete using (auth.uid() = user_id);

-- 10. Recurring Transactions
create policy "recurring_select_own" on public.recurring_transactions for select using (auth.uid() = user_id);
create policy "recurring_insert_own" on public.recurring_transactions for insert with check (auth.uid() = user_id);
create policy "recurring_update_own" on public.recurring_transactions for update using (auth.uid() = user_id);
create policy "recurring_delete_own" on public.recurring_transactions for delete using (auth.uid() = user_id);

-- 11. User Settings
create policy "settings_select_own" on public.user_settings for select using (auth.uid() = user_id);
create policy "settings_insert_own" on public.user_settings for insert with check (auth.uid() = user_id);
create policy "settings_update_own" on public.user_settings for update using (auth.uid() = user_id);
create policy "settings_delete_own" on public.user_settings for delete using (auth.uid() = user_id);
