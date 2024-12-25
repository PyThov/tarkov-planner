# Step 1: Build the React Frontend
FROM node:20-slim AS frontend-builder
WORKDIR /frontend
COPY tarkov-planner-ui/package*.json ./
RUN npm install
COPY tarkov-planner-ui/ .
RUN npm run build

# Step 2: Set Up the FastAPI Backend
FROM python:3.10-slim AS backend
WORKDIR /backend
COPY tarkov-planner-backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY tarkov-planner-backend/ .

# Step 3: Combine Frontend and Backend
# Serve static files from FastAPI
COPY --from=frontend-builder /frontend/dist /backend/static

# Expose ports and define entrypoint
EXPOSE 8000
CMD ["python", "-m", "uvicorn", "api.v1.tarkov:api", "--host", "0.0.0.0", "--port", "8000", "--log-level", "debug"]
