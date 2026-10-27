#!/bin/bash
# deploy.sh — Build and prepare the TVET Lecturer Hub for production
# Run from the project root: ./deploy.sh
# Requires: PHP, Composer, Node.js, npm

set -e

echo "=== TVET Lecturer Hub — Production Build ==="
echo ""

# ── Step 1: Build the React frontend ─────────────────────────────────────────
echo "[1/5] Building React frontend..."
cd frontend
npm ci
npm run build
cd ..
echo "      ✓ Frontend built → backend/public/"

# ── Step 2: Install Laravel PHP dependencies (production, no dev) ─────────────
echo "[2/5] Installing PHP dependencies (production)..."
cd backend
composer install --no-dev --optimize-autoloader
echo "      ✓ Composer dependencies installed"

# ── Step 3: Run migrations ────────────────────────────────────────────────────
echo "[3/5] Running database migrations..."
php artisan migrate --force
echo "      ✓ Migrations complete"

# ── Step 4: Clear and cache configuration ─────────────────────────────────────
echo "[4/5] Caching configuration..."
php artisan config:cache
php artisan route:cache
php artisan view:cache
echo "      ✓ Config, routes, and views cached"

# ── Step 5: Create storage symlink ────────────────────────────────────────────
echo "[5/5] Creating storage symlink..."
php artisan storage:link || echo "      (symlink may already exist)"
cd ..

echo ""
echo "=== Build complete ==="
echo "Upload the contents of backend/ to your server's public_html/ directory."
echo "See DEPLOYMENT.md for detailed cPanel hosting instructions."
