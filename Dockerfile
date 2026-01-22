# Stage 1: Build frontend
FROM node:20-alpine AS frontend-builder

WORKDIR /app/frontend

# Copy package files first for better caching
COPY frontend/package*.json ./

# Install dependencies
RUN npm ci

# Copy frontend source
COPY frontend/ ./

# Build the frontend
RUN npm run build

# Stage 2: Python backend with frontend assets
FROM python:3.10-slim

WORKDIR /app

# Install uv for fast Python package management
RUN pip install uv

# Copy Python dependency files
COPY pyproject.toml uv.lock* ./

# Install Python dependencies
RUN uv pip install --system -e .

# Copy backend source code
COPY backend/ ./backend/

# Copy built frontend from previous stage
COPY --from=frontend-builder /app/frontend/dist ./frontend/dist

# Create data directory for conversation storage
RUN mkdir -p data/conversations

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PORT=8001

# Expose the port
EXPOSE 8001

# Run the application
CMD ["python", "-m", "backend.main"]
