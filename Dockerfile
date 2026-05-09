FROM python:3.11-slim
WORKDIR /app
ENV PYTHONUNBUFFERED=1
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
# Make entrypoint executable and normalise line endings (safe on Linux)
RUN sed -i 's/\r//' entrypoint.sh && chmod +x entrypoint.sh
EXPOSE 8501
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address", "0.0.0.0", "--server.headless", "true"]