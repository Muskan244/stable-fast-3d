#!/bin/bash

set -e

echo "🔄 Starting Stable Fast 3D Offline Installer..."

# Load environment variables
source setup.env

# Step 1: Setup virtual environment
echo "📦 Setting up Python virtual environment..."
python$PYTHON_VERSION -m venv $VENV_NAME
source $VENV_NAME/bin/activate

# installing pytorch and torchvision
pip install torch torchvision 
# Step 2: Upgrade pip and install build tools
echo "⬆️  Upgrading pip and installing build tools..."
pip install --no-index --find-links=offline_packages pip setuptools==69.5.1 wheel

# Step 3: Install main requirements
echo "📂 Installing main project dependencies..."
pip install --no-index --find-links=offline_packages -r requirements.txt

# Step 4: Install Gradio requirements
pip install --no-index --find-links=offline_packages -r requirements-demo.txt

# Step 5: Hugging Face login
if [[ -z "$HF_TOKEN" ]]; then
  echo "🔐 Please enter your Hugging Face token (read access):"
  read -r HF_TOKEN
fi
huggingface-cli login --token "$HF_TOKEN"


# Step 6: Confirm installation
echo "✅ All dependencies installed successfully!"
echo "👉 To test the app, run:"
echo "   source $VENV_NAME/bin/activate"
echo "   python run.py demo_files/examples/chair1.png --output-dir output/"
echo "   if the above command show any error like 'RuntimeError: Invalid buffer size: 5.09 GB' then run the following command:"
echo "   SF3D_USE_CPU=1 python run.py demo_files/examples/chair1.png --output-dir output/"
echo "   or start Gradio UI: python gradio_app.py"
